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

@interface DatabaseHelper : NSObject{
    
    FMDatabase                          *db;
    
}



@property (nonatomic, retain)FMDatabase                          *db;




//创建数据库
- (BOOL)createDatabase;

/***********************用户表增改查***********************/
//插入一条用户数据
- (BOOL)insertAUserInfo:(NSString *)account
                   name:(NSString *)name
                   note:(NSString *)note
                 height:(NSString *)h
                 weight:(NSString *)w
               brithday:(NSString *)btime
                    sex:(NSString *)sex
                    age:(NSString *)age;

//修改用户数据的某一个字段值
- (BOOL)modifyUserInfo:(NSString *)uid
             witchInfo:(UserInfo)info
              newValue:(NSString *)value;

//查询用户信息 <由于目前无服务，暂定用户名不能重复，根据名字查询信息>
- (Users *)getUserInfomation:(NSString *)name;


/***********************手环增删改查操作***********************/
//插入手环记录
- (BOOL)insertAWatchInfo:(NSString *)uuid
                   color:(NSString *)color
              surfaceVer:(NSString *)surfaceVer
                 softVer:(NSString *)softVer
                   power:(NSString *)power
                    date:(NSString *)date
            accountMoney:(NSString *)accMoney
               cardMoney:(NSString *)cardMoney
                     uid:(NSString *)uid;

//手环是否已经添加过
- (BOOL)wathcIsAdd:(NSString *)uuid;

//获取某个用户绑定的手环 <可能有多个>
- (NSArray *)getUserWatches:(NSString *)uid;






@end
