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
@property (nonatomic, retain) NSDate              *cg_date;
@property (assign)            float               cg_chargeMoney;
@property (nonatomic, retain) NSString            *cg_chargeWay;
@property (nonatomic, retain) NSString            *cg_chargeTime;
@property (nonatomic, retain) NSString            *cg_chargeAddress;
@property (nonatomic, retain) NSString            *sp_watchUUID;




@end
