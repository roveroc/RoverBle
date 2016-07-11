//
//  Movement.h
//  BLE
//
//  Created by wumiao on 16/4/13.
//  Copyright © 2016年 wumiao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum _EN_Command_TypeMovement
{
    EN_Command_QuertMTU = -1,
    EN_Command_QuertKey = 0x0,
    EN_Command_CurrentTime = 0x1,
    EN_Command_QuertTimeFormat,
    EN_Command_QuertAlarmClockTimeFormat,
    EN_Command_QuertElectricity,
    EN_Command_AlarmClockTime,
    EN_Command_Step,
    EN_Command_todayDataWithStep,
    EN_Command_historyDataWithStep,
    EN_Command_todayDataWithSleep,
    EN_Command_historyDataWithSleep,
}EN_CommandTypeMovement;
@interface Movement : NSObject

@property (nonatomic, strong) NSString *cmdString;

/**
 *  发送命令
 *  @param command 命令内容
 */
+ (NSString *)sendMoveData:(EN_CommandTypeMovement)command string:(NSString *)string;

@end
