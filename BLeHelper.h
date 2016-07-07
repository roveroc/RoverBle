//
//  BLeHelper.h
//  testBleStable
//
//  Created by Rover on 16/7/6.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BabyBluetooth.h>
#import <BabyCentralManager.h>

@protocol BleHelperDelegate <NSObject>

- (void)findNewDevice:(NSMutableDictionary *)bleDic;        //发现新设备调用
- (void)scannFinish:(NSMutableDictionary *)bleDic;          //搜索结束

- (void)connectSuccess:(CBPeripheral *)per;                 //连接设备成功 <没有指定服务和特征，纯粹连接上而已>
- (void)connectSuccessAndFindSerivce:(CBPeripheral *)per
                           character:(CBCharacteristic *)character;       //连接设备成功 <发现制定服务和特征>
- (void)connectFailed;                                      //连接失败
- (void)disConnectWithDevice;                               //由于距离等一些原因，设备断开连接

- (void)blePowerOn;                                         //蓝牙被打开
- (void)blePowerOff;                                        //蓝牙被关闭

@end


@interface BLeHelper : NSObject<BleHelperDelegate>{
    
    BabyBluetooth                       *babyBle;
    BabyCentralManager                  *babyCenter;
    int                                 scannTime;
    NSMutableDictionary                 *deviceDic;
    id<BleHelperDelegate>               delegate;
    CBPeripheral                        *connectPer;
    CBCharacteristic                    *connectCharacter;
    NSString                            *deviceUUID;
    NSString                            *serviceUUID;
    NSString                            *characterUUID;
    
}
@property (nonatomic, retain) BabyBluetooth                     *babyBle;
@property (nonatomic, retain) BabyCentralManager                *babyCenter;
@property (assign)            int                               scannTime;      //扫描时间长度
@property (nonatomic, retain) NSMutableDictionary               *deviceDic;     //扫描到的设备
@property (nonatomic, retain) id<BleHelperDelegate>             delegate;
@property (nonatomic, retain) CBPeripheral                      *connectPer;          //连接成功的外设
@property (nonatomic, retain) CBCharacteristic                  *connectCharacter;    //连接成功的外设的特征
@property (nonatomic, retain) NSString                          *deviceUUID;
@property (nonatomic, retain) NSString                          *serviceUUID;
@property (nonatomic, retain) NSString                          *characterUUID;


//初始化
- (id)initBabyBle;

//开始扫描
- (void)startScann;

//停止扫描
- (void)stopScann;

//链接某一个设备
- (void)connectDevice:(CBPeripheral *)per;

//断开连接
- (void)breakConnect;

//往设备写值
- (void)writeValueToDevice:(Byte *)bt;

//读取已连接设备的RSSI值
- (void)getRSSIValueOfConnectDevice;




@end
