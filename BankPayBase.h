//
//  BankPayBase.h
//  1
//
//  Created by wumiao on 16/3/31.
//  Copyright © 2016年 wumiao. All rights reserved.
//
//BluetoothBleAdapter
#import <Foundation/Foundation.h>


#import "BLeHelper.h"

#define BTC 0xc0
#define BTC_CONTACT 0x01
#define BTC00 0x00
#define BTC01 0x01
#define BTC02 0x02
#define BTC03 0x03
#define BTC04 0x04
#define BTC05 0x05
typedef enum _EN_Command_Type
{
    EN_Command_INFO = -1,
    EN_Command_IDLE = 0x0,
    EN_Command_UNIT = 0x1,
    EN_Command_DATA,
    EN_Command_AUTH,
    EN_Command_DISCONNECT,
    EN_Command_CONNECT,
    EN_Command_ATR,
    EN_Command_APDU,
    EN_Command_PPS,

}EN_CommandType;

@interface BankPayBase : NSObject

@property (nonatomic, strong) NSString *sscstring;
@property (nonatomic, strong) NSData *MTUdata;
@property BOOL flat;

/**
 *  单例方法
 *
 *  @return 单例
 */
+ (BankPayBase *)shareInstance;
/**
 *  发送指令
 *
 *  string 指令数据
 */
- (NSString *)sendPayData:(EN_CommandType)command string:(NSString *)string;
/**
 *  发送上电指令
 */
- (NSString *)sendMustData;
/**
 *  查询余额
 */
- (void)checkBalance:(NSString *)applicationString;
/**
 *  查询交易明细
 */
- (void)checkRecords:(NSString *)applicationString;
/**
 *  钱包充值
 */
- (void)rechargeWithWallet:(NSString *)money;
/**
 *  应用充值
 */
- (void)rechargeWithApplication:(NSString *)money;
/**
 *  查询实时步数
 */
- (NSArray *)checkStep;
/**
 *  查询昨天睡眠
 */
- (void)checkSleepWithYesterday;
/**
 *  设置当前时间
 */
- (void)setCurrentTime;
@end
