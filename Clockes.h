//
//  Clockes.h
//  testBleStable
//
//  Created by Rover on 16/7/11.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum _Clock {
    ck_name = 0,
    ck_note,
    ck_date,
    ck_week,
    ck_state,
    ck_watchUUID
} ClockInfo;


@interface Clockes : NSObject
    
@property (assign)            int                 ck_id;
@property (nonatomic, retain) NSString            *ck_name;
@property (nonatomic, retain) NSString            *ck_note;
@property (nonatomic, retain) NSString            *ck_date;
@property (nonatomic, retain) NSString            *ck_week;
@property (nonatomic, retain) NSString            *ck_state;
@property (nonatomic, retain) NSString            *ck_watchUUID;



@end
