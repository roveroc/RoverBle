//
//  Sleepes.h
//  testBleStable
//
//  Created by Rover on 16/7/12.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sleepes : NSObject


@property (assign)            int                 sp_id;
@property (nonatomic, retain) NSDate              *sp_date;
@property (nonatomic, retain) NSString            *sp_begintTime;
@property (nonatomic, retain) NSString            *sp_endTime;
@property (nonatomic, retain) NSString            *sp_clearTime;
@property (nonatomic, retain) NSString            *sp_sleepDegree;
@property (nonatomic, retain) NSString            *sp_watchUUID;


@end
