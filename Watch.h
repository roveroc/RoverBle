//
//  Watch.h
//  testBleStable
//
//  Created by Rover on 16/7/8.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _Watch {
    softVer = 0,
    power,
    date,
    accountMoney,
    cardMoney
} WatchInfo;

@interface Watch : NSObject



@property (nonatomic, retain) NSString *uuid;               //添加后不可修改
@property (nonatomic, retain) NSString *color;
@property (nonatomic, retain) NSString *surfaceVer;
@property (nonatomic, retain) NSString *uid;

@property (nonatomic, retain) NSString *softVer;            //可修改
@property (nonatomic, retain) NSString *power;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *accountMoney;
@property (nonatomic, retain) NSString *cardMoney;





@end
