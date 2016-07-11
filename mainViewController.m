//
//  mainViewController.m
//  testBleStable
//
//  Created by Rover on 16/7/6.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import "mainViewController.h"
#import <CommonCrypto/CommonCryptor.h>
#import "Users.h"


#import "BankPayBase.h"

@interface mainViewController ()

@end

@implementation mainViewController
@synthesize bleHelp;
@synthesize deviceArray;
@synthesize deviceTable;
@synthesize connectDeviceUUID;
@synthesize myPer;
@synthesize myCharacter;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//测试蓝牙功能
    deviceArray = [[NSMutableDictionary alloc] init];
    connectDeviceUUID = @"";
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"扫描" style:UIBarButtonItemStyleDone target:self action:@selector(beganScann)];
    self.navigationItem.rightBarButtonItem = btn;
    
    deviceTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 375, 667-200) style:UITableViewStylePlain];
    deviceTable.delegate = self;
    deviceTable.dataSource = self;
    deviceTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:deviceTable];
    
    [self beganScann];
    
    
//测试数据库功能
//    DatabaseHelper *db = [[DatabaseHelper alloc] init];
//    [db createDatabase];
//    
//    [db insertAUserInfo:@"123" name:@"rover001" note:@"rover" height:@"rover" weight:@"rover" brithday:@"rover" sex:@"rover" age:@"rover"];
//    [db modifyUserInfo:@"1" witchInfo:name      newValue:@"Jack"];
//    [db modifyUserInfo:@"1" witchInfo:note      newValue:@"moster"];
//    [db modifyUserInfo:@"1" witchInfo:height    newValue:@"180"];
//    [db modifyUserInfo:@"1" witchInfo:weight    newValue:@"70"];
//    [db modifyUserInfo:@"1" witchInfo:brithday  newValue:@"19900909"];
//    [db modifyUserInfo:@"1" witchInfo:sex       newValue:@"man"];
//    [db modifyUserInfo:@"1" witchInfo:age       newValue:@"28"];
//    
//    Users *user = [db getUserInfomation:@"rover001"];
//    NSLog(@"查询到的信息为 = %@",user);
//    
//    
//    [db insertAWatchInfo:@"123456" color:@"红色" surfaceVer:@"V1.0" softVer:@"V1.1" power:@"100%" date:@"19900011" accountMoney:@"1000" cardMoney:@"100" uid:@"1"];
//    
//    [db insertAWatchInfo:@"654321" color:@"红色" surfaceVer:@"V1.0" softVer:@"V1.1" power:@"100%" date:@"19900011" accountMoney:@"1000" cardMoney:@"100" uid:@"1"];
//    
//    NSArray *arr = [db getUserWatches:@"1"];
//    NSLog(@"查询到的手环信息为 = %@",arr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --------------------------------------- 开始扫描周围设备
- (void)beganScann {
    if(bleHelp == nil){
        bleHelp = [[BLeHelper alloc] initBabyBle];
        bleHelp.scannTime = 6;
        bleHelp.delegate = self;
        bleHelp.deviceUUID    = @"C0933BCB-F113-0567-F826-154BFAECCC68";
        
        bleHelp.serviceUUID   = @"48EB9001-F352-5FA0-9B06-8FCAA22602CF";
        
        bleHelp.writeUUID     = @"48EB9002-F352-5FA0-9B06-8FCAA22602CF";
        
        bleHelp.characterUUIDArray = [[NSArray alloc] initWithObjects:@"48EB9002-F352-5FA0-9B06-8FCAA22602CF",
                                                                      @"48eb9003-f352-5fa0-9b06-8fcaa22602cf",
                                                                      nil];
        
        
    }
    [bleHelp startScann];
}


/**********************************************************************/
/**********************************************************************/
/**********************************************************************/
//一些代理
#pragma mark --------------------------------------- 发现新设备
- (void)findNewDevice:(NSMutableDictionary *)bleDic{
    if(deviceArray.allKeys.count > 0){
        [deviceArray removeAllObjects];
    }
    deviceArray = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary *)bleDic];
    [deviceTable reloadData];
}

#pragma mark --------------------------------------- 扫描结束
- (void)scannFinish:(NSMutableDictionary *)bleDic{
    NSLog(@"扫描设备结束 = %@",bleDic);
    if(deviceArray.allKeys.count > 0){
        [deviceArray removeAllObjects];
    }
    deviceArray = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary *)bleDic];
    [deviceTable reloadData];
    if(connectDeviceUUID.length > 0){
        CBPeripheral *per = [deviceArray objectForKey:connectDeviceUUID];
        [bleHelp connectDevice:per];
    }
}

#pragma mark --------------------------------------- 连接成功
- (void)connectSuccess:(CBPeripheral *)per{
//    connectDeviceUUID = per.identifier.UUIDString;
//    [NSTimer scheduledTimerWithTimeInterval:1.0
//                                     target:self
//                                   selector:@selector(getRSSI)
//                                   userInfo:nil
//                                    repeats:YES];
    
}

#pragma mark --------------------------------------- 连接成功，发现制定服务和特征
- (void)connectSuccessAndFindSerivce:(CBPeripheral *)per character:(CBCharacteristic *)character{
    myPer = per;
    connectDeviceUUID = per.identifier.UUIDString;
    myCharacter = character;
}


#pragma mark --------------------------------------- 连接失败
- (void)connectFailed{
    
}

#pragma mark --------------------------------------- 由于距离等一些原因，设备断开连接
- (void)disConnectWithDevice{
    
}

#pragma mark --------------------------------------- 手机蓝牙被打开
- (void)blePowerOn{
    [self beganScann];
}

#pragma mark --------------------------------------- 手机蓝牙被关闭
- (void)blePowerOff{

}

#pragma mark --------------------------------------- 读取已连接设备的值，在连接成功后可调用
- (void)getRSSI{
    [bleHelp getRSSIValueOfConnectDevice];
}


/**********************************************************************/
/**********************************************************************/
/**********************************************************************/
#pragma mark ------------------------------------------------ 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark ------------------------------------------------ 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [deviceArray allKeys].count;
}

#pragma mark ------------------------------------------------ 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.;
}

#pragma mark ------------------------------------------------ 点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *keys = [deviceArray allKeys];
    NSString *key = [keys objectAtIndex:indexPath.row];
    CBPeripheral *per = [deviceArray objectForKey:key];
    [bleHelp connectDevice:per];
}

#pragma mark ------------------------------------------------ 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"tableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] init];
    }
    NSArray *keys = [deviceArray allKeys];
    NSString *key = [keys objectAtIndex:indexPath.row];
    CBPeripheral *per = [deviceArray objectForKey:key];
    if([per.name rangeOfString:@"E3E4"].location != NSNotFound){
        cell.textLabel.textColor = [UIColor redColor];
    }
    cell.textLabel.text = per.name;
    return cell;
}




- (NSData*) hexToBytes:(NSString *)string {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= string.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [string substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}


- (IBAction)testWriteValue:(id)sender {
    
    Byte b1[20] = {0xc0,0x01,0x00,0x00,0x00,0x00,0x04,0x00,0x0e,0x1e,0x00,0x0a,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
    
    Byte b2[5] = {0x00,0x00,0x15,0x05,0xc0};
    
    NSData *d1 =  [[NSData alloc] initWithBytes:b1 length:20];
    
    [bleHelp writeValueToDevice:d1];
    
    NSData *d2 =  [[NSData alloc] initWithBytes:b2 length:5];
    
    [bleHelp writeValueToDevice:d2];
    
//    BankPayBase *bank = [[BankPayBase alloc] init];
//    NSString *s = [bank sendMustData];
//    NSData *d3 = [s dataUsingEncoding:NSUTF8StringEncoding];
//    [bleHelp writeValueToDevice:d3];
}


- (void)sendDataScuccess:(NSData *)backData{
    NSLog(@"发送数据后，设备返回的数据为 = %@",backData);
}


@end
