//
//  BindCard.h
//  testBleStable
//
//  Created by Rover on 16/7/13.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BindCard : NSObject


@property (assign)            int                 bc_id;
@property (nonatomic, retain) NSString            *bc_bankName;
@property (nonatomic, retain) NSString            *bc_cardNumber;
@property (nonatomic, retain) NSString            *bc_bindTime;
@property (nonatomic, retain) NSString            *bc_watchUUID;


@end
