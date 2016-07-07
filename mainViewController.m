//
//  mainViewController.m
//  testBleStable
//
//  Created by Rover on 16/7/6.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import "mainViewController.h"
#import <CommonCrypto/CommonCryptor.h>

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --------------------------------------- 开始扫描周围设备
- (void)beganScann {
    if(bleHelp == nil){
        bleHelp = [[BLeHelper alloc] initBabyBle];
        bleHelp.scannTime = 10;
        bleHelp.delegate = self;
        bleHelp.deviceUUID    = @"C0933BCB-F113-0567-F826-154BFAECCC68";
        bleHelp.serviceUUID   = @"48EB9001-F352-5FA0-9B06-8FCAA22602CF";
        bleHelp.characterUUID = @"48EB9002-F352-5FA0-9B06-8FCAA22602CF";
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

- (IBAction)testWriteValue:(id)sender {
    
    Byte byte[] = {0xc0,0x01,0x00,0x00,0x00,0x01,0x02,0x00,0x00,0x02,0xc0};
    NSData *data = [[NSData alloc] initWithBytes:byte length:11];
    NSArray *arr = [[NSArray alloc] initWithObjects:data, nil];
    
    [bleHelp writeValueToDevice:arr];
    
}
@end
