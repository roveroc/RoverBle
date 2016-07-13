//
//  DatabaseHelper.h
//  testBleStable
//
//  Created by Rover on 16/7/8.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import "Users.h"
#import "Watch.h"
#import "Clockes.h"
#import "Movementes.h"
#import "Sleepes.h"
#import "Charges.h"
#import "Spendes.h"
#import "BindCard.h"
#import <DateTools.h>

@interface DatabaseHelper : NSObject{
    
    FMDatabase                          *db;
    
}



@property (nonatomic, retain)FMDatabase                          *db;


//创建数据库
- (BOOL)createDatabase;


/***********************用户表增改查***********************/
//插入一条用户数据
- (BOOL)insertAUserInfo:(Users *)user;
//修改用户数据的某一个字段值
- (BOOL)modifyUserInfo:(NSString *)uid
             whichInfo:(UserInfo)info
              newValue:(NSString *)value;
//查询用户信息 <由于目前无服务，暂定用户名不能重复，根据名字查询信息>
- (Users *)getUserInfomation:(NSString *)name;


/***********************手环增删改查操作***********************/
//插入手环记录
- (BOOL)insertAWatchInfo:(Watch *)watch;
//手环是否已经添加过
- (BOOL)wathcIsAdd:(NSString *)uuid;
//获取某个用户绑定的手环 <可能有多个>
- (NSArray *)getUserWatches:(NSString *)uid;
//修改手环表的某一个字段值
- (BOOL)modifyWatchInfo:(NSString *)uuid
              whichInfo:(WatchInfo)info
               newValue:(NSString *)value;
//删除一个手环
- (BOOL)deleteWatchInfo:(NSString *)uuid;


/***********************闹钟增删改查操作***********************/
//添加一个闹钟
- (BOOL)insertAClock:(Clockes *)clock;
//获取某一个手环所有闹钟
- (NSArray *)getAllClock:(NSString *)watchUUID;
//修改某一个闹钟
- (BOOL)modifyAClock:(Clockes *)clock;
//删除某一个闹钟
- (BOOL)deleteAClock:(int)cid;


/***********************运动记录表的相关操作***********************/
//增加一条运动记录
- (BOOL)insertAMovementRecord:(Movementes *)move;
//跟新运动记录的相关值
- (BOOL)modifyMovementValue:(Movementes *)move;
//查询当天的运动记录
- (Movementes *)getTodayMovementRecord;
//查询最近某些天的运动记录 <从今天往前推>
- (NSArray *)getMovementRecordInDays:(int)days;


/***********************睡眠记录表的相关操作***********************/
//增加一条睡眠记录
- (BOOL)insertASleepRecord:(Sleepes *)sleep;
//查询当天的运动记录
- (Sleepes *)getTodaySleepRecord;
//查询最近某些天的睡眠记录 <从今天往前推>
- (NSArray *)getSleepRecordInDays:(int)days;


/**********************手环充值记录表的相关操作***********************/
//增加一条充值记录
- (BOOL)insertAChargeRecord:(Charges *)charge;
//查询最近某些天的充值记录 <从今天往前推>
- (NSArray *)getChargeRecordInDays:(int)days;


/**********************手环消费记录表的相关操作***********************/  //暂时没用到




/**********************绑定银行卡***********************/
//增加一条银行卡绑定记录
- (BOOL)insertAbindcardInfo:(BindCard *)bc;
//删除一条银行卡绑定记录
- (BOOL)deleteAbindcardInfo:(BindCard *)bc;
//获取所有已绑定卡信息
- (NSArray *)getAllBindcardInfo:(NSString *)watchUUID;



@end
