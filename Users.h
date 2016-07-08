//
//  Users.h
//  testBleStable
//
//  Created by Rover on 16/7/8.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _UserInfo {
    name = 0,
    note,
    height,
    weight,
    brithday,
    sex,
    age
} UserInfo;

@interface Users : NSObject


@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *note;
@property (nonatomic, retain) NSString *height;
@property (nonatomic, retain) NSString *weight;
@property (nonatomic, retain) NSString *brithday;
@property (nonatomic, retain) NSString *sex;
@property (nonatomic, retain) NSString *age;




@end
