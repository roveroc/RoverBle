//
//  Movementes.h
//  testBleStable
//
//  Created by Rover on 16/7/11.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movementes : NSObject



@property (assign)            int                 mv_id;
@property (nonatomic, retain) NSDate              *mv_date;
@property (nonatomic, retain) NSString            *mv_step;
@property (nonatomic, retain) NSString            *mv_distance;
@property (nonatomic, retain) NSString            *mv_calorie;
@property (nonatomic, retain) NSString            *mv_goalStep;
@property (nonatomic, retain) NSString            *mv_watchUUID;



@end
