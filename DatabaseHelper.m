//
//  DatabaseHelper.m
//  testBleStable
//
//  Created by Rover on 16/7/8.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import "DatabaseHelper.h"



@implementation DatabaseHelper
@synthesize db;

-(id)init{
    self = [super init];  
    if (self != nil) {
        
    }
    return self;
}

#pragma mark ------------------------------------------- 创建数据库
- (BOOL)createDatabase{
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:@"testDB.sqlite"];
    NSLog(@"数据库路径为 = %@",dbpath);
    db = [FMDatabase databaseWithPath:dbpath];
    if([db open]){
        //用户表
        NSString *users = @"create table IF NOT EXISTS users (id integer primary key autoincrement,account text,name text,\
        note text,height text,weight text,brithday text,sex text,age int);";
        //手环表
        NSString *watchs = @"create table IF NOT EXISTS watch (id integer primary key autoincrement,uuid text,color text,\
        surfaceVer text,softVer text,power text,date text,accountMoney text,cardMoney text,userID integer,\
        FOREIGN KEY(userID) REFERENCES users(id));";
        //闹钟表
        NSString *alarm = @"create table IF NOT EXISTS alarm (id integer primary key autoincrement,name text,note text,\
        time text,week text,state text,watchID interger,FOREIGN KEY(watchID) REFERENCES watch(id));";
        //手环充值记录表
        NSString *charge = @"create table IF NOT EXISTS charge (id integer primary key autoincrement,chargeMoney float,\
        chargeWay text,chargetime text,chargeAddress text,TSN text,watchID interger,FOREIGN KEY(watchID) \
        REFERENCES watch(id));";
        //手环消费记录表
        NSString *spend = @"create table IF NOT EXISTS spend (id integer primary key autoincrement,spendMoney float,\
        spendWay text,spendtime text,spendAddress text,TSN text,watchID interger,FOREIGN KEY(watchID) REFERENCES watch(id));";
        //睡眠表
        NSString *sleep = @"create table IF NOT EXISTS sleep (id integer primary key autoincrement,day text,beginTime text,\
        endTime text,clearTime text,sleepDegree text,watchID interger,FOREIGN KEY(watchID) REFERENCES watch(id));";
        //运动表
        NSString *movement = @"create table IF NOT EXISTS movement (id integer primary key autoincrement,day text,\
        beginTime text,endTime text,stepNumber text,distance text,calorie text,watchID interger,\
        FOREIGN KEY(watchID) REFERENCES watch(id));";
        //银行卡绑定表
        NSString *bindCard = @"create table IF NOT EXISTS bindCard (id integer primary key autoincrement,bankName text,\
        cardNumber text,bindTime text,watchID interger,FOREIGN KEY(watchID) REFERENCES watch(id));";
        
        
        
        if([db executeStatements:users] && [db executeStatements:watchs] && [db executeStatements:alarm] &&
           [db executeStatements:charge] && [db executeStatements:spend] && [db executeStatements:sleep] &&
           [db executeStatements:movement] && [db executeStatements:bindCard]){
            NSLog(@"创建数据库和表成功");
        }else{
            NSLog(@"Something Wrong About Create");
        }
        
        
        [db close];
        return YES;
    }
    return NO;
}

#pragma mark ------------------------------------------- 插入一条用户数据
- (BOOL)insertAUserInfo:(NSString *)account
                   name:(NSString *)name
                   note:(NSString *)note
                 height:(NSString *)h
                 weight:(NSString *)w
               brithday:(NSString *)btime
                    sex:(NSString *)sex
                    age:(NSString *)age{
    
    if([db open]){
        FMResultSet *s = [db executeQuery:@"select name from users where name = ?",name];
        if ([s next]) {
            NSLog(@"用户名不能重复");
            [db close];
            return NO;
        }
        
        BOOL flag = [db executeUpdate:@"insert into users (account,name,note,height,weight,brithday,sex,age) \
         values (?,?,?,?,?,?,?,?)",account,name,note,h,w,btime,sex,age];
        if(flag == NO){
            NSLog(@"插入用户数据出错");
        }
    }
    [db close];
    return NO;
}

#pragma mark ------------------------------------------- 修改用户数据的某一个字段值
- (BOOL)modifyUserInfo:(NSString *)uid
             witchInfo:(UserInfo)info
              newValue:(NSString *)value{
    if([db open]){
        switch (info) {
            case name:{
                BOOL flag = [db executeUpdate:@"update users set name = ? where id = ?",value,uid];
                if(flag == NO){
                    NSLog(@"更新用户 名字 失败");
                }
            }
                break;
            case note:{
                BOOL flag = [db executeUpdate:@"update users set note = ? where id = ?",value,uid];
                if(flag == NO){
                    NSLog(@"更新用户 签名 失败");
                }
            }
                break;
            case height:{
                BOOL flag = [db executeUpdate:@"update users set height = ? where id = ?",value,uid];
                if(flag == NO){
                    NSLog(@"更新用户 身高 失败");
                }
            }
                break;
            case weight:{
                BOOL flag = [db executeUpdate:@"update users set weight = ? where id = ?",value,uid];
                if(flag == NO){
                    NSLog(@"更新用户 体重 失败");
                }
            }
                break;
            case brithday:{
                BOOL flag = [db executeUpdate:@"update users set brithday = ? where id = ?",value,uid];
                if(flag == NO){
                    NSLog(@"更新用户名字 失败");
                }
            }
                break;
            case sex:{
                BOOL flag = [db executeUpdate:@"update users set sex = ? where id = ?",value,uid];
                if(flag == NO){
                    NSLog(@"更新用户名字 失败");
                }
            }
                break;
            case age:{
                BOOL flag = [db executeUpdate:@"update users set age = ? where id = ?",value,uid];
                if(flag == NO){
                    NSLog(@"更新用户名字 失败");
                }
            }
                break;
                
            default:
                break;
        }
    }else{
        [db close];
        NSLog(@"数据库打开出错");
    }
    [db close];
    return NO;
}

#pragma mark ------------------------------------------- 修改用户数据的某一个字段值
- (Users *)getUserInfomation:(NSString *)name{
    Users *user = [[Users alloc] init];
    if([db open]){
        FMResultSet *s = [db executeQuery:@"select account,name,note,height,weight,brithday,sex,age from users \
                          where name = ?",name];
        while ([s next]) {
            user.account    = [s stringForColumn:@"account"];
            user.name       = [s stringForColumn:@"name"];
            user.note       = [s stringForColumn:@"note"];
            user.height     = [s stringForColumn:@"height"];
            user.weight     = [s stringForColumn:@"weight"];
            user.brithday   = [s stringForColumn:@"brithday"];
            user.sex        = [s stringForColumn:@"sex"];
            user.age        = [s stringForColumn:@"age"];
        }
    }else{
        NSLog(@"数据库打开出错");
        [db close];
        return nil;
    }
    [db close];
    return user;
}


#pragma mark ------------------------------------------- 修改用户数据的某一个字段值
- (BOOL)insertAWatchInfo:(NSString *)uuid
                   color:(NSString *)color
              surfaceVer:(NSString *)surfaceVer
                 softVer:(NSString *)softVer
                   power:(NSString *)power
                    date:(NSString *)date
            accountMoney:(NSString *)accMoney
               cardMoney:(NSString *)cardMoney
                     uid:(NSString *)uid{
    if([db open]){
        FMResultSet *s = [db executeQuery:@"select uuid from watch where uuid = ?",uuid];
        if ([s next]) {
            NSLog(@"手环已经添加");
            [db close];
            return YES;
        }
        
        BOOL flag = [db executeUpdate:@"insert into watch (uuid,color,surfaceVer,softVer,power,date,\
                     accountMoney,cardMoney,userID) values (?,?,?,?,?,?,?,?,?)",uuid,color,surfaceVer,softVer,power,date,accMoney,cardMoney,uid];
        if(flag == NO){
            NSLog(@"插入手环数据出错");
        }
    }
    [db close];
    return NO;
}

#pragma mark ------------------------------------------- 判断手环是否添加过
- (BOOL)wathcIsAdd:(NSString *)uuid{
    if([db open]){
        FMResultSet *s = [db executeQuery:@"select uuid from watch where uuid = ?",uuid];
        if ([s next]) {
            NSLog(@"手环已经添加");
            [db close];
            return YES;
        }
    }
    [db close];
    return NO;
}

#pragma mark ------------------------------------------- 获取某个用户绑定的手环 <可能有多个>
- (NSArray *)getUserWatches:(NSString *)uid{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if([db open]){
        FMResultSet *s = [db executeQuery:@"select uuid,color,surfaceVer,softVer,power,date,accountMoney,\
                          cardMoney,userID from watch where userID = ?",uid];
        while ([s next]) {
            Watch *w = [[Watch alloc] init];
            w.uuid              = [s stringForColumn:@"uuid"];
            w.color             = [s stringForColumn:@"color"];
            w.surfaceVer        = [s stringForColumn:@"surfaceVer"];
            w.softVer           = [s stringForColumn:@"softVer"];
            w.power             = [s stringForColumn:@"power"];
            w.date              = [s stringForColumn:@"date"];
            w.accountMoney      = [s stringForColumn:@"accountMoney"];
            w.cardMoney         = [s stringForColumn:@"cardMoney"];
            w.uid               = [s stringForColumn:@"userID"];
            [arr addObject:w];
        }
    }else{
        NSLog(@"数据库打开出错");
        [db close];
        return nil;
    }
    [db close];
    return (NSArray *)arr;
}


@end
