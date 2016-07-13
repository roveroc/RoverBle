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
        NSString *watchs = @"create table IF NOT EXISTS watch (uuid text primary key,color text,\
        surfaceVer text,softVer text,power text,date text,accountMoney text,cardMoney text,userID integer,\
        FOREIGN KEY(userID) REFERENCES users(id));";
        //闹钟表
        NSString *alarm = @"create table IF NOT EXISTS alarm (id integer primary key autoincrement,name text,note text,\
        time text,week text,state text,watchUUID text,FOREIGN KEY(watchUUID) REFERENCES watch(uuid));";
        //手环充值记录表
        NSString *charge = @"create table IF NOT EXISTS charge (id integer primary key autoincrement,chargeMoney text,\
        chargeWay text,chargetime text,chargeAddress text,TSN text,watchUUID text,FOREIGN KEY(watchUUID) \
        REFERENCES watch(uuid));";
        //手环消费记录表
        NSString *spend = @"create table IF NOT EXISTS spend (id integer primary key autoincrement,spendMoney text,\
        spendWay text,spendtime text,spendAddress text,TSN text,watchUUID text,FOREIGN KEY(watchUUID) REFERENCES watch(uuid));";
        //睡眠表
        NSString *sleep = @"create table IF NOT EXISTS sleep (id integer primary key autoincrement,day text,beginTime text,\
        endTime text,clearTime text,sleepDegree text,watchUUID text,FOREIGN KEY(watchUUID) REFERENCES watch(uuid));";
        //运动表
        NSString *movement = @"create table IF NOT EXISTS movement (id integer primary key autoincrement,\
        day text,stepNumber text,distance text,goalStep text,calorie text,watchUUID text,\
        FOREIGN KEY(watchUUID) REFERENCES watch(uuid));";
        //银行卡绑定表
        NSString *bindCard = @"create table IF NOT EXISTS bindCard (id integer primary key autoincrement,bankName text,\
        cardNumber text,bindTime text,watchUUID text,FOREIGN KEY(watchUUID) REFERENCES watch(uuid));";
        
        
        
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

#pragma mark ------------------------------------------- <<<用户>>>  插入一条用户数据
- (BOOL)insertAUserInfo:(Users *)user{
    if([db open]){
        FMResultSet *s = [db executeQuery:@"select name from users where name = ?",name];
        if ([s next]) {
            NSLog(@"用户名不能重复");
            [db close];
            return NO;
        }
        
        BOOL flag = [db executeUpdate:@"insert into users (account,name,note,height,weight,brithday,sex,age) \
         values (?,?,?,?,?,?,?,?)",user.account,user.name,user.note,user.height,user.weight,user.brithday,user.sex,user.age];
        if(flag == NO){
            NSLog(@"插入用户数据出错");
        }
    }
    [db close];
    return NO;
}

#pragma mark ------------------------------------------- <<<用户>>>  修改用户数据的某一个字段值
- (BOOL)modifyUserInfo:(NSString *)uid
             whichInfo:(UserInfo)info
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

#pragma mark ------------------------------------------- <<<用户>>>  修改用户数据的某一个字段值
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


#pragma mark ------------------------------------------- <<<手环>>>  插入一条手环信息
- (BOOL)insertAWatchInfo:(Watch *)watch{
    if([db open]){
        FMResultSet *s = [db executeQuery:@"select uuid from watch where uuid = ?",watch.uuid];
        if ([s next]) {
            NSLog(@"手环已经添加");
            [db close];
            return YES;
        }
        
        BOOL flag = [db executeUpdate:@"insert into watch (uuid,color,surfaceVer,softVer,power,date,\
                     accountMoney,cardMoney,userID) values (?,?,?,?,?,?,?,?,?)",watch.uuid,watch.color,watch.surfaceVer,watch.softVer,watch.power,watch.date,watch.accountMoney,watch.cardMoney,watch.uid];
        if(flag == NO){
            NSLog(@"插入手环数据出错");
        }
    }
    [db close];
    return NO;
}

#pragma mark ------------------------------------------- <<<手环>>>  判断手环是否添加过
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

#pragma mark ------------------------------------------- <<<手环>>>  获取某个用户绑定的手环 <可能有多个>
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


#pragma mark ------------------------------------------- <<<手环>>>  修改手环表的某个属性值
- (BOOL)modifyWatchInfo:(NSString *)uuid whichInfo:(WatchInfo)info newValue:(NSString *)value{
    if([db open]){
        switch (info) {
            case softVer:{
                BOOL flag = [db executeUpdate:@"update watch set softVer = ? where uuid = ?",value,uuid];
                if(flag == NO){
                    NSLog(@"更新手环 固件版本 失败");
                }
            }
                break;
            case power:{
                BOOL flag = [db executeUpdate:@"update watch set power = ? where uuid = ?",value,uuid];
                if(flag == NO){
                    NSLog(@"更新手环 电量 失败");
                }
            }
                break;
            case date:{
                BOOL flag = [db executeUpdate:@"update watch set date = ? where uuid = ?",value,uuid];
                if(flag == NO){
                    NSLog(@"更新手环 时间 失败");
                }
            }
                break;
            case accountMoney:{
                BOOL flag = [db executeUpdate:@"update watch set accountMoney = ? where uuid = ?",value,uuid];
                if(flag == NO){
                    NSLog(@"更新手环 余额 失败");
                }
            }
                break;
            case cardMoney:{
                BOOL flag = [db executeUpdate:@"update watch set cardMoney = ? where uuid = ?",value,uuid];
                if(flag == NO){
                    NSLog(@"更新手环 卡余额 失败");
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

#pragma mark ------------------------------------------- <<<手环>>>  删除某个手环信息，应当删除其它关系表的记录
- (BOOL)deleteWatchInfo:(NSString *)uuid{
    if([db open]){
        BOOL flag = [db executeUpdate:@"delete from watch where uuid = ?",uuid];
        if (flag) {
            NSLog(@"uuid = %@ 的手环  删除成功",uuid);
            [db executeUpdate:@"delete from alarm where watchUUID = ?",uuid];
            [db executeUpdate:@"delete from charge where watchUUID = ?",uuid];
            [db executeUpdate:@"delete from spend where watchUUID = ?",uuid];
            [db executeUpdate:@"delete from sleep where watchUUID = ?",uuid];
            [db executeUpdate:@"delete from movement where watchUUID = ?",uuid];
            [db executeUpdate:@"delete from bindCard where watchUUID = ?",uuid];
            [db close];
            return YES;
        }
    }
    NSLog(@"uuid = %@ 的手环  删除失败",uuid);
    [db close];
    return NO;
}

#pragma mark ------------------------------------------- <<<闹钟>>>  添加一个闹钟
- (BOOL)insertAClock:(Clockes *)clock{
    if([db open]){        
        BOOL flag = [db executeUpdate:@"insert into alarm (name,note,time,week,state,watchUUID) values (?,?,?,?,?,?)",clock.ck_name,clock.ck_note,clock.ck_date,clock.ck_week,clock.ck_state,clock.ck_watchUUID];
        if(flag == NO){
            NSLog(@"添加手环闹钟 失败");
        }
    }
    [db close];
    return NO;
}

#pragma mark ------------------------------------------- <<<闹钟>>>  获取某个手环设置的所有闹钟
- (NSArray *)getAllClock:(NSString *)watchUUID{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if([db open]){
        FMResultSet *s = [db executeQuery:@"select id,name,note,time,week,state,watchUUID from alarm \
                          where watchUUID = ?",watchUUID];
        while ([s next]) {
            Clockes *ck = [[Clockes alloc] init];
            ck.ck_id            = [s intForColumn:@"id"];
            ck.ck_name          = [s stringForColumn:@"name"];
            ck.ck_note          = [s stringForColumn:@"note"];
            ck.ck_date          = [s stringForColumn:@"time"];
            ck.ck_week          = [s stringForColumn:@"week"];
            ck.ck_state         = [s stringForColumn:@"state"];
            ck.ck_watchUUID     = [s stringForColumn:@"watchUUID"];
            [arr addObject:ck];
        }
    }else{
        NSLog(@"数据库打开出错");
        [db close];
        return nil;
    }
    [db close];
    return (NSArray *)arr;
}


#pragma mark ------------------------------------------- <<<闹钟>>>  修改某一个闹钟信息
- (BOOL)modifyAClock:(Clockes *)clock{
    if([db open]){
        BOOL flag = [db executeUpdate:@"update alarm set name=?,note=?,time=?,week=?,state=?\
                      where id = ?",clock.ck_name,clock.ck_note,clock.ck_date,clock.ck_week,clock.ck_state,
                       [NSNumber numberWithInt:clock.ck_id]];
        if(flag == NO){
            NSLog(@"修改手环闹钟 失败");
        }
    }else{
        NSLog(@"数据库打开出错");
        [db close];
        return NO;
    }
    [db close];
    return NO;
}

#pragma mark ------------------------------------------- <<<闹钟>>>  删除一个闹钟
- (BOOL)deleteAClock:(int)cid{
    if([db open]){
        BOOL flag = [db executeUpdate:@"delete from alarm where id = ?",[NSNumber numberWithInt:cid]];
        if (flag) {
            NSLog(@"id = %d 的闹钟  删除成功",cid);
            [db close];
            return YES;
        }
    }
    NSLog(@"id = %d 的手环  删除失败",cid);
    [db close];
    return NO;
}

#pragma mark ------------------------------------------- <<<运动>>>  新增一条运动记录
- (BOOL)insertAMovementRecord:(Movementes *)move{
    if([db open]){
        //将传进日期只去年、月、日
        NSTimeInterval timeValue = [move.mv_date timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.0f", timeValue+8*60*60];
        NSDate *nd = [NSDate dateWithTimeIntervalSince1970:[timeString intValue]];
        NSDate *real = [NSDate dateWithYear:nd.year month:nd.month day:nd.day];
        NSTimeInterval realValue = [real timeIntervalSince1970];
        NSString *realStr = [NSString stringWithFormat:@"%.0f", realValue];
        NSLog(@"插入的运动记录日期 = %@",real);
        BOOL flag = [db executeUpdate:@"insert into movement (day,stepNumber,distance,calorie,goalStep,watchUUID) values (?,?,?,?,?,?)",realStr,move.mv_step,move.mv_distance,move.mv_calorie,move.mv_goalStep,move.mv_watchUUID];
        if(flag == NO){
            NSLog(@"添加手环闹钟 失败");
        }
    }
    [db close];
    return NO;
}

#pragma mark ------------------------------------------- <<<运动>>>  获取当天的运动记录
- (Movementes *)getTodayMovementRecord{
    Movementes *mv = [[Movementes alloc] init];
    if([db open]){
        NSTimeInterval timeValue = [[NSDate date] timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.0f", timeValue+8*60*60];
        NSDate *nd = [NSDate dateWithTimeIntervalSince1970:[timeString intValue]];
        NSDate *real = [NSDate dateWithYear:nd.year month:nd.month day:nd.day];
        NSTimeInterval realValue = [real timeIntervalSince1970];
        NSString *realStr = [NSString stringWithFormat:@"%.0f", realValue];
        FMResultSet *s = [db executeQuery:@"select id,day,stepNumber,distance,calorie,goalStep,watchUUID from\
                          movement where day = ?",realStr];
        while ([s next]) {
            mv.mv_id              = [s intForColumn:@"id"];
            NSString *timeValue   = [s stringForColumn:@"day"];
            NSDate *nd = [NSDate dateWithTimeIntervalSince1970:[timeValue intValue]];
            mv.mv_date            = nd;
            mv.mv_step            = [s stringForColumn:@"stepNumber"];
            mv.mv_distance        = [s stringForColumn:@"distance"];
            mv.mv_calorie         = [s stringForColumn:@"calorie"];
            mv.mv_goalStep        = [s stringForColumn:@"goalStep"];
            mv.mv_watchUUID       = [s stringForColumn:@"watchUUID"];
        }
    }else{
        NSLog(@"数据库打开出错");
        [db close];
        return nil;
    }
    [db close];
    return mv;
}

#pragma mark ------------------------------------------- <<<运动>>>  查询最近某些天的运动记录 <从今天往前推>
- (NSArray *)getMovementRecordInDays:(int)days{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if([db open]){
        NSTimeInterval timeValue = [[NSDate date] timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.0f", timeValue+8*60*60];
        NSDate *nd = [NSDate dateWithTimeIntervalSince1970:[timeString intValue]];
        NSDate *real = [NSDate dateWithYear:nd.year month:nd.month day:nd.day];
        NSDate *real_1 = [real dateBySubtractingDays:days];
        NSTimeInterval realValue = [real_1 timeIntervalSince1970];
        FMResultSet *s1 = [db executeQuery:@"select id ,day from movement"];
        int index = 0;
        while ([s1 next]) {
            index    = [s1 intForColumn:@"id"];
            int _day = [[s1 stringForColumn:@"day"] intValue];
            if(_day > realValue)
                break;
        }
        NSLog(@"查询时间点的间隔为 = %d",index);
        
        FMResultSet *s = [db executeQuery:@"select id,day,stepNumber,distance,calorie,goalStep,watchUUID from\
                          movement where id >= ?",[NSNumber numberWithInt:index]];
        while ([s next]) {
            Movementes *mv = [[Movementes alloc] init];
            mv.mv_id              = [s intForColumn:@"id"];
            NSString *timeValue   = [s stringForColumn:@"day"];
            NSDate *nd = [NSDate dateWithTimeIntervalSince1970:[timeValue intValue]];
            mv.mv_date            = nd;
            mv.mv_step            = [s stringForColumn:@"stepNumber"];
            mv.mv_distance        = [s stringForColumn:@"distance"];
            mv.mv_calorie         = [s stringForColumn:@"calorie"];
            mv.mv_goalStep        = [s stringForColumn:@"goalStep"];
            mv.mv_watchUUID       = [s stringForColumn:@"watchUUID"];
            [arr addObject:mv];
        }
    }else{
        NSLog(@"数据库打开出错");
        [db close];
        return nil;
    }
    [db close];
    return (NSArray *)arr;
}


#pragma mark ------------------------------------------- <<<运动>>>  更新运动记录的相关值
- (BOOL)modifyMovementValue:(Movementes *)move{
    if([db open]){
        BOOL flag = [db executeUpdate:@"update movement set stepNumber=?,distance=?,calorie=?,goalStep=?\
                     where id = ?",move.mv_step,move.mv_distance,move.mv_calorie,move.mv_goalStep,
                     [NSNumber numberWithInt:move.mv_id]];
        if(flag == NO){
            NSLog(@"修改运动记录 失败");
        }
    }else{
        NSLog(@"数据库打开出错");
        [db close];
        return NO;
    }
    [db close];
    return NO;
}


#pragma mark ------------------------------------------- <<<睡眠>>>  增加一条睡眠记录
- (BOOL)insertASleepRecord:(Sleepes *)sleep{
    if([db open]){
        //将传进日期只去年、月、日
        NSTimeInterval timeValue = [sleep.sp_date timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.0f", timeValue+8*60*60];
        NSDate *nd = [NSDate dateWithTimeIntervalSince1970:[timeString intValue]];
        NSDate *real = [NSDate dateWithYear:nd.year month:nd.month day:nd.day];
        NSTimeInterval realValue = [real timeIntervalSince1970];
        NSString *realStr = [NSString stringWithFormat:@"%.0f", realValue];
        NSLog(@"插入的 睡眠 记录日期 = %@",real);
        BOOL flag = [db executeUpdate:@"insert into sleep (day,beginTime,endTime,clearTime,sleepDegree,\
                     watchUUID) values (?,?,?,?,?,?)",realStr,sleep.sp_begintTime,sleep.sp_endTime,sleep.sp_clearTime,sleep.sp_sleepDegree,sleep.sp_watchUUID];
        if(flag == NO){
            NSLog(@"插入的 睡眠 记录 失败");
        }
    }
    [db close];
    return NO;
}


#pragma mark ------------------------------------------- <<<睡眠>>>   查询最近某些天的睡眠记录 <从今天往前推>
- (NSArray *)getSleepRecordInDays:(int)days{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if([db open]){
        NSTimeInterval timeValue = [[NSDate date] timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.0f", timeValue+8*60*60];
        NSDate *nd = [NSDate dateWithTimeIntervalSince1970:[timeString intValue]];
        NSDate *real = [NSDate dateWithYear:nd.year month:nd.month day:nd.day];
        NSDate *real_1 = [real dateBySubtractingDays:days];
        NSTimeInterval realValue = [real_1 timeIntervalSince1970];
        FMResultSet *s1 = [db executeQuery:@"select id ,day from sleep"];
        int index = 0;
        while ([s1 next]) {
            index    = [s1 intForColumn:@"id"];
            int _day = [[s1 stringForColumn:@"day"] intValue];
            if(_day > realValue)
                break;
        }
        NSLog(@"睡眠记录 -- 查询时间点的间隔为 = %d",index);
        
        FMResultSet *s = [db executeQuery:@"select id,day,beginTime,endTime,clearTime,sleepDegree,watchUUID from\
                          sleep where id >= ?",[NSNumber numberWithInt:index]];
        while ([s next]) {
            Sleepes *sp = [[Sleepes alloc] init];
            sp.sp_id              = [s intForColumn:@"id"];
            NSString *timeValue   = [s stringForColumn:@"day"];
            NSDate *nd = [NSDate dateWithTimeIntervalSince1970:[timeValue intValue]];
            sp.sp_date            = nd;
            sp.sp_begintTime      = [s stringForColumn:@"beginTime"];
            sp.sp_endTime         = [s stringForColumn:@"endTime"];
            sp.sp_clearTime       = [s stringForColumn:@"clearTime"];
            sp.sp_sleepDegree     = [s stringForColumn:@"sleepDegree"];
            sp.sp_watchUUID       = [s stringForColumn:@"watchUUID"];
            [arr addObject:sp];
        }
    }else{
        NSLog(@"数据库打开出错");
        [db close];
        return nil;
    }
    [db close];    
    return (NSArray *)arr;
}


#pragma mark ------------------------------------------- <<<充值>>>  增加一条充值记录，充值成功后，更新对应手表的余额
/**
 *  插入一条充值记录
 *
 *  @param charge 充值记录对象
 *
 *  @return 是否插入成功
 */
- (BOOL)insertAChargeRecord:(Charges *)charge{
    if([db open]){
        [db beginTransaction];      //将此次操作当成一个事务处理
        BOOL isRollBack = NO;
        float totalMoney;
        @try {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [dateFormatter dateFromString:charge.cg_chargeTime];
            
            NSTimeInterval timeValue = [date timeIntervalSince1970];
            NSString *timeString = [NSString stringWithFormat:@"%.0f", timeValue];
            NSDate *nd = [NSDate dateWithTimeIntervalSince1970:[timeString intValue]];
            NSTimeInterval realValue = [nd timeIntervalSince1970];
            NSString *realStr = [NSString stringWithFormat:@"%.0f", realValue];
            
            
            BOOL flag1 = [db executeUpdate:@"insert into charge (chargeMoney,chargeWay,chargetime,chargeAddress,TSN,watchUUID) values (?,?,?,?,?,?)",
                         charge.cg_chargeMoney,charge.cg_chargeWay,
                         realStr,charge.cg_chargeAddress,charge.cg_TSN,charge.cg_watchUUID];
            FMResultSet *s  = [db executeQuery:@"select accountMoney from watch where uuid = ?",
                               charge.cg_watchUUID];
            while ([s next]) {
                totalMoney = [[s stringForColumn:@"accountMoney"] floatValue];
            }
            totalMoney+=[charge.cg_chargeMoney floatValue];
            NSString *money = [NSString stringWithFormat:@"%f",totalMoney];
            BOOL flag2 = [db executeUpdate:@"update watch set accountMoney = ? where uuid = ?",money,charge.cg_watchUUID];
            if(flag1 == NO || flag2 == NO){
                isRollBack = YES;
            }
            
        } @catch (NSException *exception) {
            isRollBack = YES;
            [db rollback];
            return NO;
        } @finally {
            if(!isRollBack){
                if([db commit]){
                    NSLog(@"插入充值记录成功，并已同步更新余额");
                    return YES;
                }else{
                    [db rollback];
                    return NO;
                }
            }else{
                [db rollback];
                return NO;
            }
        }
    }
    [db close];
    return NO;
}

#pragma mark ------------------------------------------- <<<充值>>>  查询最近某些天的充值记录
/**
 *  获取最近多少天内的充值记录
 *
 *  @param days 多少天
 *
 *  @return 返回一个数组，数组每一项为充值记录的对象
 */
- (NSArray *)getChargeRecordInDays:(int)days{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if([db open]){
        NSTimeInterval timeValue = [[NSDate date] timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.0f", timeValue];
        NSDate *nd = [NSDate dateWithTimeIntervalSince1970:[timeString intValue]];
        NSDate *real = [NSDate dateWithYear:nd.year month:nd.month day:nd.day];
        NSDate *real_1 = [real dateBySubtractingDays:days];
        NSTimeInterval realValue = [real_1 timeIntervalSince1970];
        FMResultSet *s1 = [db executeQuery:@"select id ,chargetime from charge"];
        int index = 0;
        while ([s1 next]) {
            index    = [s1 intForColumn:@"id"];
            int _day = [[s1 stringForColumn:@"chargetime"] intValue];
            if(_day > realValue)
                break;
        }
        NSLog(@"充值记录 -- 查询时间点的间隔为 = %d",index);
        
        FMResultSet *s = [db executeQuery:@"select id,chargeMoney,chargeWay,chargetime,chargeAddress,\
                          TSN,watchUUID from charge where id >= ?",[NSNumber numberWithInt:index]];
        while ([s next]) {
            Charges *cg = [[Charges alloc] init];
            cg.cg_id              = [s intForColumn:@"id"];
            cg.cg_chargeMoney     = [s stringForColumn:@"chargeMoney"];
            cg.cg_chargeWay       = [s stringForColumn:@"chargeWay"];
            NSString *timeValue   = [s stringForColumn:@"chargetime"];
            NSDate *nd = [NSDate dateWithTimeIntervalSince1970:[timeValue intValue]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:nd];
            cg.cg_chargeTime      = strDate;
            cg.cg_chargeAddress   = [s stringForColumn:@"chargeAddress"];
            cg.cg_TSN             = [s stringForColumn:@"TSN"];
            cg.cg_watchUUID       = [s stringForColumn:@"watchUUID"];
            
            [arr addObject:cg];
        }
    }else{
        NSLog(@"数据库打开出错");
        [db close];
        return nil;
    }
    [db close];
    return (NSArray *)arr;
}


#pragma mark ------------------------------------------- <<<绑定银行卡>>>  增加一条银行卡绑定记录
/**
 *  增加一条银行卡绑定记录
 *
 *  @param bc 绑定卡的对象
 *
 *  @return 增加记录是否成功
 */
- (BOOL)insertAbindcardInfo:(BindCard *)bc{
    if([db open]){
        FMResultSet *s = [db executeQuery:@"select cardNumber from bindCard where cardNumber = ?",bc.bc_cardNumber];
        if ([s next]) {
            NSLog(@"该卡已经添加");
            [db close];
            return NO;
        }
        
        BOOL flag = [db executeUpdate:@"insert into bindCard (bankName,cardNumber,bindTime,watchUUID)\
                     values (?,?,?,?)",bc.bc_bankName,bc.bc_cardNumber,bc.bc_bindTime,bc.bc_watchUUID];
        if(flag == NO){
            NSLog(@"插入用户数据出错");
        }
    }
    [db close];
    return NO;
}


#pragma mark ------------------------------------------- <<<绑定银行卡>>>  删除一条绑定卡记录
/**
 *  解除银行卡绑定
 *
 *  @param bc 银行卡对象
 *
 *  @return 解绑是否成功
 */
- (BOOL)deleteAbindcardInfo:(BindCard *)bc{
    if([db open]){
        BOOL flag = [db executeUpdate:@"delete from bindCard where cardNumber = ?",bc.bc_cardNumber];
        if (flag) {
            [db close];
            return YES;
        }
    }
    NSLog(@"卡号为 = %@ 的银行卡 解除绑定",bc.bc_cardNumber);
    [db close];
    return NO;
}


#pragma mark ------------------------------------------- <<<绑定银行卡>>>
/**
 *  获取某个手表绑定的银行卡
 *
 *  @param watchUUID 手表UUID
 *
 *  @return 返回数组对象，数组每一项为BindCard实例
 */
- (NSArray *)getAllBindcardInfo:(NSString *)watchUUID{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if([db open]){
        FMResultSet *s = [db executeQuery:@"select id,bankName,cardNumber,bindTime,watchUUID from bindCard \
                          where watchUUID = ?",watchUUID];
        while ([s next]) {
            BindCard *bc = [[BindCard alloc] init];
            bc.bc_id            = [s intForColumn:@"id"];
            bc.bc_bankName      = [s stringForColumn:@"bankName"];
            bc.bc_cardNumber    = [s stringForColumn:@"cardNumber"];
            bc.bc_bindTime      = [s stringForColumn:@"bindTime"];
            bc.bc_watchUUID     = [s stringForColumn:@"watchUUID"];
            [arr addObject:bc];
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
