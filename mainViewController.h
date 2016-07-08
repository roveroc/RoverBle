//
//  mainViewController.h
//  testBleStable
//
//  Created by Rover on 16/7/6.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLeHelper.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <MBProgressHUD.h>
#import "DatabaseHelper.h"

@interface mainViewController : UIViewController<BleHelperDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    BLeHelper                *bleHelp;
    NSMutableDictionary      *deviceArray;
    
    UITableView              *deviceTable;
    
    NSString                 *connectDeviceUUID;
    
    CBPeripheral             *myPer;
    CBCharacteristic         *myCharacter;
    
}
@property (nonatomic, retain) BLeHelper                 *bleHelp;
@property (nonatomic, retain) NSMutableDictionary       *deviceArray;
@property (nonatomic, retain) UITableView               *deviceTable;
@property (nonatomic, retain) NSString                  *connectDeviceUUID;
@property (nonatomic, retain) CBPeripheral              *myPer;
@property (nonatomic, retain) CBCharacteristic          *myCharacter;


- (IBAction)testWriteValue:(id)sender;


@end
