//
//  Movement.m
//  BLE
//
//  Created by wumiao on 16/4/13.
//  Copyright © 2016年 wumiao. All rights reserved.
//

#import "Movement.h"
#import "number.h"
#import "BankPayBase.h"
@implementation Movement
/**
 *  发送命令
 *  @param command 命令内容
 */
+ (NSString *)sendMoveData:(EN_CommandTypeMovement)command string:(NSString *)string{
    NSInteger num = 0;
    unsigned char data[200] = {0};
    switch (command) {
        case EN_Command_QuertMTU:
        {
            data[0] = 0x01;
            data[1] = 0x00;
            data[2] = 0x01;
            data[3] = 0x01;
        }
            break;
        case EN_Command_CurrentTime:
        {
            data[0] = 0x04;
            data[1] = 0x00;
            data[2] = 0x07;
            data[9] = 0x01;
            Byte *b = (Byte *)[[Movement getCurrentTime] bytes];
            for (NSInteger i = 0; i < 4; i++) {
                data[3+i] = b[i];
            }
        }
            break;
        case EN_Command_QuertElectricity:
        {
            data[0] = 0x13;
            data[1] = 0x00;
            data[2] = 0x00;
        }
            break;
        case EN_Command_QuertKey:
        {
            data[0] = 0x03;
            data[1] = 0x00;
            data[2] = 0x00;
        }
            break;
        case EN_Command_QuertTimeFormat:
        {
            data[0] = 0x05;
            data[1] = 0x00;
            data[2] = 0x00;
        }
            break;
        case EN_Command_QuertAlarmClockTimeFormat:
        {
            data[0] = 0x07;
            data[1] = 0x00;
            data[2] = 0x00;
        }
            break;
        case EN_Command_AlarmClockTime:
        {
            data[0] = 0x06;
            data[1] = 0x00;
            data[2] = 0x00;
            Byte *b = (Byte *)[[Movement getData:string] bytes];
            NSInteger n = string.length/2;
            for (NSInteger i = 0; i < n; i++) {
                data[2] += 0x01;
                data[3+i] = b[i];
            }
        }
            break;
        case EN_Command_Step:
        {
            data[0] = 0x1e;
            data[1] = 0x00;
            data[2] = 0x0a;
            Byte *b = (Byte *)[[Movement stepGaugeAndSleep:1] bytes];
            for (NSInteger i = 0; i < 10; i++) {
                data[3+i] = b[i];
            }
        }
            break;
        case EN_Command_todayDataWithStep:
        {
            data[0] = 0x1e;
            data[1] = 0x00;
            data[2] = 0x0a;
            Byte *b = (Byte *)[[Movement stepGaugeAndSleep:2] bytes];
            for (NSInteger i = 0; i < 10; i++) {
                data[3+i] = b[i];
            }
        }
            break;
        case EN_Command_historyDataWithStep:
        {
            data[0] = 0x1e;
            data[1] = 0x00;
            data[2] = 0x0a;
            Byte *b = (Byte *)[[Movement stepGaugeAndSleep:3] bytes];
            for (NSInteger i = 0; i < 10; i++) {
                data[3+i] = b[i];
            }
        }
            break;
        case EN_Command_todayDataWithSleep:
        {
            data[0] = 0x1e;
            data[1] = 0x00;
            data[2] = 0x0a;
            Byte *b = (Byte *)[[Movement stepGaugeAndSleep:4] bytes];
            for (NSInteger i = 0; i < 10; i++) {
                data[3+i] = b[i];
            }
        }
            break;
        case EN_Command_historyDataWithSleep:
        {
            data[0] = 0x1e;
            data[1] = 0x00;
            data[2] = 0x0a;
            Byte *b = (Byte *)[[Movement stepGaugeAndSleep:5] bytes];
            for (NSInteger i = 0; i < 10; i++) {
                data[3+i] = b[i];
            }
        }
            break;
        default:
            break;
    }
    NSString *lengthStr = [NSString stringWithFormat:@"%02x%02x",data[1]&0xff,data[2]&0xff];
    unsigned long length = strtoul([lengthStr UTF8String],0,16);
    num = 2 + length;
    data[num + 1] = 0x00;
    for (NSInteger i = 0; i <= num; i++) {
        data[num + 1] = data[num + 1]^data[i];
    }
    NSData *adata = [[NSData alloc] initWithBytes:data length:sizeof(data)];
    NSInteger n = 0;
    Byte *newByte = (Byte *)[adata bytes];
    for (NSInteger i = 0; i < 200; i++) {
        if (newByte[i] != 0x00) {
            n = i;
        }
    }
    unsigned char newData[n];
    for (NSInteger i = 0; i <= n; i++) {
        newData[i] = newByte[i];
    }
    NSString *hexStr = @"";
    NSString *str = @"";
    for (int i = 0; i <= n; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x",newData[i]&0xff];
        hexStr = [NSString stringWithFormat:@"%@0x%@",hexStr,newHexStr];
        str = [str stringByAppendingString:newHexStr];
    }
    return str;
    
}
+ (NSData *)stepGaugeAndSleep:(NSInteger)n{
    NSString *string = @"";
    for (NSInteger i = 1; i <= 10; i++) {
        if (n == i) {
            string = [string stringByAppendingString:@"01"];
        }else{
            string = [string stringByAppendingString:@"00"];
        }
    }
    NSData *data = [number hexToBytes:string];
    return data;
}

+ (NSData *)getData:(NSString *)string{
    NSData *data = [number hexToBytes:string];
    return data;
}
/**
 *  获取当前16进制时间撮
 */
+ (NSData *)getCurrentTime{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localDate = [date  dateByAddingTimeInterval: interval];
    NSTimeInterval timeStamp= [localDate timeIntervalSince1970];
    unsigned long num = (int)timeStamp;
    NSString *str = [NSString stringWithFormat:@"%lx",num];
    NSString *newStr = @"";
    for (NSInteger i = 3; i >= 0; i--) {
        newStr = [newStr stringByAppendingString:[str substringWithRange:NSMakeRange(2*i, 2)]];
    }
    NSData *data = [number hexToBytes:newStr];
    return data;
}

-(id)init
{
    if(self = [super init]){
        _cmdString = [[NSString alloc] init];
    }
    return self;
}
@end
