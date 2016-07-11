//
//  BLeHelper.m
//  testBleStable
//
//  Created by Rover on 16/7/6.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import "BLeHelper.h"

@interface BLeHelper()
@property (nonatomic, retain) NSArray             *sendDataArray;       //需要发送的指令数组
@property (assign)            int                 sendDataCount;        //已经成功发送指令的计数
@end


@implementation BLeHelper

@synthesize babyBle;
@synthesize babyCenter;
@synthesize deviceDic;
@synthesize delegate;
@synthesize scannTime;
@synthesize connectPer;
@synthesize deviceUUID;
@synthesize serviceUUID;
@synthesize characterUUIDArray;
@synthesize connectCharacter;
@synthesize writeUUID;

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
    NSMutableArray *servicesUUID = [NSMutableArray arrayWithObject:[CBUUID UUIDWithString:serviceUUID]];
    [connectPer discoverServices:servicesUUID];
}


- (void)writeValueToDevice:(NSData *)data{
    [connectPer writeValue:data forCharacteristic:connectCharacter type:CBCharacteristicWriteWithResponse];
}

#pragma mark ------------------------------------------- 设置蓝牙委托
-(void)babyDelegate{
    __weak BLeHelper *weakSelf = self;
/********************************************/
#pragma mark +++++++++++++++++++++++++++++++++++++++++++ 搜索到外围设备的回调
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
#pragma mark +++++++++++++++++++++++++++++++++++++++++++ 结束扫描操作的回调
/********************************************/
    [babyBle setBlockOnCancelScanBlock:^(CBCentralManager *central){
        [weakSelf.delegate scannFinish:weakSelf.deviceDic];
    }];
    
    
/********************************************/
#pragma mark +++++++++++++++++++++++++++++++++++++++++++ 连接设备成功的回调，此时并不知道设备提供的服务和特征
/********************************************/
    [babyBle setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"连接 成功");
        weakSelf.connectPer = peripheral;
        [weakSelf getDeviceServices];
    }];
    
    
/********************************************/
#pragma mark +++++++++++++++++++++++++++++++++++++++++++ 连接设备失败的回调
/********************************************/
    [babyBle setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
       NSLog(@"连接 失败 error = %@",error);
        [weakSelf.delegate connectFailed];
    }];
    
    
/********************************************/
#pragma mark +++++++++++++++++++++++++++++++++++++++++++ 捕获蓝牙断开的回调，如距离、断电等
/********************************************/
    [babyBle setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"各种原因 断开连接");
        [weakSelf.delegate disConnectWithDevice];
        [weakSelf.babyBle.centralManager connectPeripheral:peripheral options:nil]; //断开连接后重连
    }];
    
    
/********************************************/
#pragma mark +++++++++++++++++++++++++++++++++++++++++++ 获取手机蓝牙状态的回调，如蓝牙开启，关闭
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
#pragma mark +++++++++++++++++++++++++++++++++++++++++++ 读取已经连接设备的RSSI回调
/********************************************/
    [babyBle setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
       NSLog(@"当前的蓝牙 RSSI  = %@ ",RSSI );
    }];
    
    
/********************************************/
#pragma mark +++++++++++++++++++++++++++++++++++++++++++ 发现设备服务的回调
/********************************************/
    [babyBle setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services){
            NSLog(@"发现外设的服务号为 ------> %@",service.UUID);
            if ([service.UUID isEqual:[CBUUID UUIDWithString:weakSelf.serviceUUID]]){
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for(int i = 0;i<weakSelf.characterUUIDArray.count;i++){
                    [arr addObject:[CBUUID UUIDWithString:weakSelf.characterUUIDArray[i]]];
                }
                [weakSelf.connectPer discoverCharacteristics:arr forService:service];     //读取服务上的特征
            }
        }
    }];
    
    
/********************************************/
#pragma mark +++++++++++++++++++++++++++++++++++++++++++ 发现设备的特征回调
/********************************************/
    [babyBle setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        for (CBCharacteristic *cha in service.characteristics){
            if ([cha.UUID isEqual:[CBUUID UUIDWithString:weakSelf.writeUUID]])
            {
                weakSelf.connectCharacter = cha;
                [weakSelf.delegate connectSuccessAndFindSerivce:peripheral character:cha];
            }
            NSLog(@"连接 成功，发现制定的服务和特征");

            [weakSelf.babyBle notify:peripheral
                      characteristic:cha
                               block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                       //接收到值会进入这个方法
//                       NSLog(@"向特征 %@ 写值后，\n设备返回的数据 =  %@",characteristics,characteristics.value);
                                   [weakSelf.delegate sendDataScuccess:characteristics.value];
                   }];
        }
    }];
    
/********************************************/
#pragma mark +++++++++++++++++++++++++++++++++++++++++++ 写Characteristic成功后的block
/********************************************/
    [babyBle setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error){
//        NSLog(@"写Characteristic成功后的block = %@",characteristic.value);
        
        
    }];

    
/********************************************/
#pragma mark +++++++++++++++++++++++++++++++++++++++++++ characteristic订阅状态改变的block
/********************************************/
    [babyBle setBlockOnDidUpdateNotificationStateForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"characteristic订阅状态改变的block = %@",characteristic);
    }];
    
}



@end
