//
//  Charges.h
//  testBleStable
//
//  Created by Rover on 16/7/12.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Charges : NSObject


@property (assign)            int                 cg_id;
@property (assign)            NSString            *cg_chargeMoney;
@property (nonatomic, retain) NSString            *cg_chargeWay;
@property (nonatomic, retain) NSString            *cg_chargeTime;
@property (nonatomic, retain) NSString            *cg_chargeAddress;
@property (nonatomic, retain) NSString            *cg_TSN;
@property (nonatomic, retain) NSString            *cg_watchUUID;




@end
