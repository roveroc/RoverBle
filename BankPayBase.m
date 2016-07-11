//
//  BankPayBase.m
//  1
//
//  Created by wumiao on 16/3/31.
//  Copyright © 2016年 wumiao. All rights reserved.
//

#import "BankPayBase.h"
#import "Movement.h"
#import "number.h"

@interface BankPayBase()

@end

@implementation BankPayBase
{
    NSTimer *timer;
    dispatch_source_t timer3;
    BOOL ret;
    int balanceNum;
    NSTimer *balanceTimer;
}
+ (BankPayBase *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static BankPayBase *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}
//发送上电指令，必须等待结果返回的ssc
- (NSString *)sendMustData{
    Byte byte[] = {0xc0,0x01,0x00,0x00,0x00,0x01,0x02,0x00,0x00,0x02,0xc0};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    return [number stringWithHexBytes2:data];
}

- (NSString *)sendPayData:(EN_CommandType)command string:(NSString *)string{
    NSInteger num = 0;
    unsigned char data[500] = {0};
    data[0] = BTC;
    data[1] = BTC_CONTACT;
    if (command == EN_Command_DATA) {
        
    }else{
        Byte *b = (Byte *)[[self getSSC] bytes];
        for (NSInteger i = 0; i < sizeof(b); i++) {
            data[3+i] = b[i];
        }
    }
    //加形参来判断命令码
    switch (command) {
        case EN_Command_CONNECT:
        {
            data[5] = BTC01;
            data[6] = BTC02;
            break;
        }
        case EN_Command_ATR:
        {
            data[5] = BTC01;
            data[6] = BTC03;
            break;
        }
        case EN_Command_INFO:
        {
            data[5] = BTC00;
            data[6] = BTC01;
            break;
        }
        case EN_Command_DISCONNECT:
        {
            data[5] = BTC01;
            data[6] = BTC01;
            break;
        }
        case EN_Command_APDU:
        {
            data[5] = BTC01;
            data[6] = BTC04;
            data[7] = 0x00;
            data[8] = 0x00;
            Byte *b = (Byte *)[[self getData:string] bytes];
            NSInteger n = string.length/2;
            for (NSInteger i = 0; i < n; i++) {
                data[9+i] = b[i];
                data[8] += 0x01;
            }
            break;
        }
        case EN_Command_DATA:
        {
            data[5] = 0x00;
            data[6] = 0x04;
            data[7] = 0x00;
            data[8] = 0x00;
            Byte *b = (Byte *)[[self getData:string] bytes];
            NSInteger n = string.length/2;
            for (NSInteger i = 0; i < n; i++) {
                data[9+i] = b[i];
                data[8] += 0x01;
            }
            break;
        }
        default:
            break;
    }
    NSString *lengthStr = [NSString stringWithFormat:@"%02x%02x",data[7]&0xff,data[8]&0xff];
    unsigned long length = strtoul([lengthStr UTF8String],0,16);
    num = 8 + length;
    data[num + 1] = data[1]^data[2]^data[3]^data[4]^data[5]^data[6];
    data[num + 2] = BTC;
    NSData *adata = [[NSData alloc] initWithBytes:data length:sizeof(data)];
   // NSLog(@"%@",adata);
    NSInteger n = 0;
    Byte *newByte = (Byte *)[adata bytes];
    for (NSInteger i = 0; i < 500; i++) {
        if (newByte[i] == 0xc0) {
            n = i;
        }
    }
    unsigned char newData[n];
    for (NSInteger i = 0; i <= n; i++) {
        newData[i] = newByte[i];
    }
    NSString *hexStr = @"";
    NSString *str = @"";
    for (int i = 1; i < n; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x",newData[i]&0xff];
        hexStr = [NSString stringWithFormat:@"%@0x%@",hexStr,newHexStr];
        str = [str stringByAppendingString:newHexStr];
    }
    _sscstring = [str substringWithRange:NSMakeRange(4, 4)];
    NSString *newString = @"c0";
    for (NSInteger i = 0; i < str.length/2; i++) {
        NSString *string = [str substringWithRange:NSMakeRange(i * 2, 2)];
        if ([string isEqualToString:@"db"]) {
            newString = [newString stringByAppendingString:@"dbdd"];
        }else if ([string isEqualToString:@"c0"]){
            newString = [newString stringByAppendingString:@"dbdc"];
        }else{
            newString = [newString stringByAppendingString:string];
        }
    }
    newString = [newString stringByAppendingString:@"c0"];
    return newString;
}
- (NSData *)getSSC{
    Byte *byte = (Byte *)[_MTUdata bytes];
    static Byte arr[2] = {0};
    if (ret) {
        arr[1] = byte[10];
        arr[0] = byte[9];
        ret = NO;
    }
    arr[1] += 0x01;
    if (arr[1] == 0x00) {
        arr[0] = arr[0] + 0x01;
    }
    if (arr[0] == 0x10) {
        arr[0] = 0x00;
        arr[1] = 0x01;
    }
    NSData *data = [[NSData alloc] initWithBytes:arr length:sizeof(arr)];
    return data;
}

//查询交易明细
- (void)checkRecords:(NSString *)applicationString{
    //00A404000E315041592E5359532E4444463031    00A4040007A0000003330101    00B2015C00
    NSString *checkString = @"";
    NSString *recordStringWithHeat = @"00B20";
    NSString *recordStringWithFeat = @"";
    if ([applicationString isEqualToString:@"00A4000002DF01"]) {
        checkString = @"0020000003123456";
        recordStringWithFeat = @"C417";
    }else{
        checkString = @"00A4040007A0000003330101";
        recordStringWithFeat = @"5C00";
    }
    NSString *str1 = [self sendMustData];
    NSString *str2 = [self sendPayData:EN_Command_ATR string:nil];
    NSString *str3 = [self sendPayData:EN_Command_APDU string:applicationString];
    NSString *str4 = [self sendPayData:EN_Command_APDU string:checkString];
    NSString *str5 = [self sendPayData:EN_Command_APDU string:[NSString stringWithFormat:@"%@1%@",recordStringWithHeat,recordStringWithFeat]];
    NSString *str6 = [self sendPayData:EN_Command_APDU string:[NSString stringWithFormat:@"%@2%@",recordStringWithHeat,recordStringWithFeat]];
    NSString *str7 = [self sendPayData:EN_Command_APDU string:[NSString stringWithFormat:@"%@3%@",recordStringWithHeat,recordStringWithFeat]];
    NSString *str8 = [self sendPayData:EN_Command_APDU string:[NSString stringWithFormat:@"%@4%@",recordStringWithHeat,recordStringWithFeat]];
    NSString *str9 = [self sendPayData:EN_Command_APDU string:[NSString stringWithFormat:@"%@5%@",recordStringWithHeat,recordStringWithFeat]];
    NSString *str10 = [self sendPayData:EN_Command_APDU string:[NSString stringWithFormat:@"%@6%@",recordStringWithHeat,recordStringWithFeat]];
    NSString *str11 = [self sendPayData:EN_Command_APDU string:[NSString stringWithFormat:@"%@7%@",recordStringWithHeat,recordStringWithFeat]];
    NSString *str12 = [self sendPayData:EN_Command_APDU string:[NSString stringWithFormat:@"%@8%@",recordStringWithHeat,recordStringWithFeat]];
    NSString *str13 = [self sendPayData:EN_Command_APDU string:[NSString stringWithFormat:@"%@9%@",recordStringWithHeat,recordStringWithFeat]];
    NSString *str14 = [self sendPayData:EN_Command_APDU string:[NSString stringWithFormat:@"%@A%@",recordStringWithHeat,recordStringWithFeat]];
    NSArray *array = @[str1,str2,str3,str4,str5,str6,str7,str8,str9,str10,str11,str12,str13,str14];
    NSLog(@"%@",array);
}
//钱包充值
- (void)rechargeWithWallet:(NSString *)money{
    NSString *str1 = [self sendMustData];
    NSString *str2 = [self sendPayData:EN_Command_ATR string:nil];
    NSString *str3 = [self sendPayData:EN_Command_APDU string:@"00A4000002DF01"];
    NSString *str4 = [self sendPayData:EN_Command_APDU string:@"0020000003123456"];
    NSString *str5 = [self sendPayData:EN_Command_APDU string:[[NSString alloc] initWithFormat:@"805000020b01%@010101010101",money]];
    
    //需要拿到上一条指令中的数据
    NSString *str6 = [[BankPayBase shareInstance] sendPayData:EN_Command_APDU string:[[NSString alloc] initWithFormat:@"805200000B%@%@",[self getCurrentTime],@"jisuan"]];
    NSArray *array = @[str1,str2,str3,str4,str5,str6];
    NSLog(@"%@",array);
}
//应用充值
- (void)rechargeWithApplication:(NSString *)money{
    
}
//查询余额
- (void)checkBalance:(NSString *)applicationString{
    NSString *checkString = @"";
    NSString *balanceString = @"";
    if ([applicationString isEqualToString:@"00A4000002DF01"]) {
        checkString = @"00A4000002DF01";
        balanceString = @"805C000204";
    }else{
        checkString = @"00A4040007A0000003330101";
        balanceString = @"80CA9F7909";
    }
    NSString *str1 = [self sendMustData];
    NSString *str2 = [self sendPayData:EN_Command_ATR string:nil];
    NSString *str3 = [self sendPayData:EN_Command_APDU string:applicationString];
    NSString *str4 = [self sendPayData:EN_Command_APDU string:checkString];
    NSString *str5 = [self sendPayData:EN_Command_APDU string:balanceString];
    NSArray *array = @[str1,str2,str3,str4,str5];
    NSLog(@"%@",array);
}
//查询实时步数
- (NSArray *)checkStep{
    NSString *str1 = [self sendPayData:EN_Command_DISCONNECT string:nil];
    NSString *str2 = [self sendPayData:EN_Command_DATA string:[Movement sendMoveData:EN_Command_Step string:nil]];
    NSArray *array = @[str1,str2];
    NSLog(@"%@",array);
    return array;
}
//查询昨天睡眠
- (void)checkSleepWithYesterday{
    NSString *str1 = [self sendPayData:EN_Command_DISCONNECT string:nil];
    NSString *str2 = [self sendPayData:EN_Command_DATA string:[Movement sendMoveData:EN_Command_historyDataWithSleep string:nil]];
    NSArray *array = @[str1,str2];
    NSLog(@"%@",array);
}
//设置当前时间
- (void)setCurrentTime{
    NSString *str1 = [self sendPayData:EN_Command_DATA string:[Movement sendMoveData:EN_Command_CurrentTime string:nil]];
    NSArray *array = @[str1];
    NSLog(@"%@",array);
}

//返回10进制字符串格式时间
- (NSString *)getCurrentTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}
//计算rechargeWithWallet中的mac
//- (void)macWithWallet{
//    NSString *string = [[NSString alloc] initWithFormat:@"%@%@8000",[[BluetoothBleAdapter shareInstance].receiveString substringWithRange:NSMakeRange(34, 8)],[[BluetoothBleAdapter shareInstance].receiveString substringWithRange:NSMakeRange(26, 4)]];
//    NSData *data = [number hexToBytes:string];
//    Byte *dataByte = (Byte *)[data bytes];
//    Byte oneKeyByte[] = {0x78,0x24,0x01,0x27,0x60,0xF7,0x11,0x27};
//    Byte twoKeyByte[] = {0xfd,0x55,0xc6,0xa2,0x57,0x32,0x22,0x33};
//    Byte *keyByte = [DES encryptUseThreeDES:dataByte onekey:oneKeyByte twokey:twoKeyByte];
//    NSString *s = [self getCurrentTime];
//    NSString *str = [[NSString alloc] initWithFormat:@"%@02010101010101%@800000000000",amount,s];
//    NSData *strData = [number hexToBytes:str];
//    Byte *strByte = (Byte *)[strData bytes];
//    NSString *macString = [DES MAC:strByte lenght:24 key:keyByte len:8];
//}
- (NSData *)getData:(NSString *)string{
    NSData *data = [number hexToBytes:string];
    return data;
}
-(id)init
{
    if(self = [super init]){
        _sscstring = [[NSString alloc] init];
        _MTUdata = [[NSData alloc] init];
        _flat = YES;
    }
    return self;
}
@end