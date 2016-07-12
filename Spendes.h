//
//  Spendes.h
//  testBleStable
//
//  Created by Rover on 16/7/12.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Spendes : NSObject


@property (assign)            int                 sd_id;
@property (nonatomic, retain) NSDate              *sd_date;
@property (assign)            float               sd_spendMoney;
@property (nonatomic, retain) NSString            *sd_spendWay;
@property (nonatomic, retain) NSString            *sd_spendTime;
@property (nonatomic, retain) NSString            *sd_spendAddress;
@property (nonatomic, retain) NSString            *sd_watchUUID;


@end
