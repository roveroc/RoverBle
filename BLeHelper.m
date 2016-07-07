//
//  BLeHelper.m
//  testBleStable
//
//  Created by Rover on 16/7/6.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import "BLeHelper.h"

@implementation BLeHelper
@synthesize babyBle;
@synthesize babyCenter;
@synthesize deviceDic;
@synthesize delegate;
@synthesize scannTime;
@synthesize connectPer;
@synthesize deviceUUID;
@synthesize serviceUUID;
@synthesize characterUUID;
@synthesize connectCharacter;

#pragma mark ------------------------------------------- 初始化
- (id)initBabyBle{
    self = [super init];
    if (self != nil) {
        babyBle = [BabyBluetooth shareBabyBluetooth];
        babyCenter = [[BabyCentralManager alloc] init];
        scannTime = 5;
        //设置蓝牙委托
        [self babyDelegate];
    }
    return self;
}

#pragma mark ------------------------------------------- 开始扫描
- (void)startScann{
    deviceDic = [[NSMutableDictionary alloc] init];
    
    //设置babybluetooth运行时参数，查找制定设备，可让程序在进入后台后继续运行
    NSMutableArray *device = [NSMutableArray arrayWithObject:[CBUUID UUIDWithString:serviceUUID]];
    [babyBle setBabyOptionsWithScanForPeripheralsWithOptions:nil connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:device discoverWithCharacteristics:nil];
    
    babyBle.scanForPeripherals().begin();
    babyBle.scanForPeripherals().stop(scannTime);
}

#pragma mark ------------------------------------------- 停止扫描
- (void)stopScann{
    [babyBle cancelScan];
}


#pragma mark ------------------------------------------- 连接某一个设备
- (void)connectDevice:(CBPeripheral *)per{
    [babyBle.centralManager connectPeripheral:per options:nil];
    [babyBle AutoReconnect:per];
}

#pragma mark ------------------------------------------- 断开连接
- (void)breakConnect{
    [babyCenter cancelAllPeripheralsConnection];
}

#pragma mark ------------------------------------------- 获取已连接设备的RSSI值
- (void)getRSSIValueOfConnectDevice{
    if(connectPer != nil){
        [connectPer readRSSI];
    }
}

#pragma mark ------------------------------------------- 获取服务、特征
- (void)getDeviceServices{
    NSLog(@"获取服务和特征");
    NSMutableArray *servicesUUID = [NSMutableArray arrayWithObject:[CBUUID UUIDWithString:serviceUUID]];
    [connectPer discoverServices:servicesUUID];
}

#pragma mark ------------------------------------------- 向设备写值
- (void)writeValueToDevice:(Byte *)bt{
    NSData *data = [NSData dataWithBytes:bt length:sizeof(bt)];
    [connectPer writeValue:data forCharacteristic:connectCharacter type:CBCharacteristicWriteWithResponse];
}

#pragma mark ------------------------------------------- 设置蓝牙委托
-(void)babyDelegate{
    __weak BLeHelper *weakSelf = self;
/********************************************/
//搜索到外围设备的回调
/********************************************/
    [babyBle setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        if(peripheral.name.length > 0){
            
            NSArray *keys = [weakSelf.deviceDic allKeys];
            if(![keys containsObject:peripheral.identifier.UUIDString]){
                NSDictionary *dic = [NSDictionary dictionaryWithObject:peripheral
                                                                forKey:peripheral.identifier.UUIDString];
                [weakSelf.deviceDic addEntriesFromDictionary:dic];
            }
            [weakSelf.delegate findNewDevice:weakSelf.deviceDic];
        }
    }];
    
    
/********************************************/
//结束扫描操作的回调
/********************************************/
    [babyBle setBlockOnCancelScanBlock:^(CBCentralManager *central){
        [weakSelf.delegate scannFinish:weakSelf.deviceDic];
    }];
    
    
/********************************************/
//连接设备成功的回调，此时并不知道设备提供的服务和特征
/********************************************/
    [babyBle setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"连接 成功");
        weakSelf.connectPer = peripheral;
//        [weakSelf.delegate connectSuccess:peripheral];
        [weakSelf getDeviceServices];
    }];
    
    
/********************************************/
//连接设备失败的回调
/********************************************/
    [babyBle setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
       NSLog(@"连接 失败 error = %@",error);
        [weakSelf.delegate connectFailed];
    }];
    
    
/********************************************/
//捕获蓝牙断开的回调，如距离、断电等
/********************************************/
    [babyBle setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"各种原因 断开连接");
        [weakSelf.delegate disConnectWithDevice];
        [weakSelf.babyBle.centralManager connectPeripheral:peripheral options:nil]; //断开连接后重连
    }];
    
    
/********************************************/
//获取手机蓝牙状态的回调，如蓝牙开启，关闭
/********************************************/
    [babyBle setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        NSLog(@"当前的蓝牙状态 == %ld",(long)weakSelf.babyBle.centralManager.state);
        if((long)weakSelf.babyBle.centralManager.state == 4){
            [weakSelf.delegate blePowerOff];
        }else if ((long)weakSelf.babyBle.centralManager.state == 5){
            [weakSelf.delegate blePowerOn];
        }
    }];
   
    
/********************************************/
//读取已经连接设备的RSSI回调
/********************************************/
    [babyBle setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
       NSLog(@"当前的蓝牙 RSSI  = %@ ",RSSI );
    }];
    
    
/********************************************/
//发现设备服务的对调
/********************************************/
    [babyBle setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        NSArray *service = peripheral.services;
        for (CBService *service in peripheral.services){
            NSLog(@"发现外设的服务号为 ------> %@",service.UUID);
            if ([service.UUID isEqual:[CBUUID UUIDWithString:weakSelf.serviceUUID]]){
                NSMutableArray *character = [NSMutableArray arrayWithObject:[CBUUID UUIDWithString:weakSelf.characterUUID]];
                [weakSelf.connectPer discoverCharacteristics:character forService:service];     //读取服务上的特征
                break;
            }
        }
        [weakSelf.connectPer discoverCharacteristics:nil forService:service[0]];
    }];
    
    
/********************************************/
//发现设备特征的对调
/********************************************/
    [babyBle setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        for (CBCharacteristic *cha in service.characteristics){
            NSLog(@"发现外设的服务号为 ------> %@",cha);
            if ([cha.UUID isEqual:[CBUUID UUIDWithString:weakSelf.characterUUID]]){
                NSLog(@"连接 成功，发现制定的服务和特征");
                weakSelf.connectCharacter = cha;
                [weakSelf.delegate connectSuccessAndFindSerivce:peripheral character:cha];
                break;
            }
        }
    }];
}



@end
