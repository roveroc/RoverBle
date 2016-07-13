//
//  mainViewController.m
//  testBleStable
//
//  Created by Rover on 16/7/6.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import "mainViewController.h"
#import <CommonCrypto/CommonCryptor.h>
#import "BankPayBase.h"

@interface mainViewController ()

@end

@implementation mainViewController
@synthesize bleHelp;
@synthesize deviceArray;
@synthesize deviceTable;
@synthesize connectDeviceUUID;
@synthesize myPer;
@synthesize myCharacter;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//测试蓝牙功能
//    deviceArray = [[NSMutableDictionary alloc] init];
//    connectDeviceUUID = @"";
//    
//    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"扫描" style:UIBarButtonItemStyleDone target:self action:@selector(beganScann)];
//    self.navigationItem.rightBarButtonItem = btn;
//    
//    deviceTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 375, 667-200) style:UITableViewStylePlain];
//    deviceTable.delegate = self;
//    deviceTable.dataSource = self;
//    deviceTable.tableFooterView = [[UIView alloc] init];
//    [self.view addSubview:deviceTable];
//    
//    [self beganScann];
//    
    
    
    
    
    
//测试数据库功能
    DatabaseHelper *db = [[DatabaseHelper alloc] init];
    [db createDatabase];
    
    Users *user = [[Users alloc] init];
    user.account    = @"123";
    user.name       = @"Rover";
    user.note       = @"where my code";
    user.height     = @"178";
    user.weight     = @"66";
    user.brithday   = @"1978";
    user.sex        = @"man";
    user.age        = @"18";
    
    [db insertAUserInfo:user];
    [db modifyUserInfo:@"1" whichInfo:name      newValue:@"Jack"];
    [db modifyUserInfo:@"1" whichInfo:note      newValue:@"moster"];
    [db modifyUserInfo:@"1" whichInfo:height    newValue:@"180"];
    [db modifyUserInfo:@"1" whichInfo:weight    newValue:@"70"];
    [db modifyUserInfo:@"1" whichInfo:brithday  newValue:@"19900909"];
    [db modifyUserInfo:@"1" whichInfo:sex       newValue:@"man"];
    [db modifyUserInfo:@"1" whichInfo:age       newValue:@"28"];
    
    Users *u = [db getUserInfomation:@"Rover"];
    NSLog(@"查询到的信息为 = %@",u);
    
    Watch *watch = [[Watch alloc] init];
    watch.uuid          = @"123456";
    watch.color         = @"红色";
    watch.surfaceVer    = @"V1.0";
    watch.softVer       = @"V1.0";
    watch.power         = @"100%";
    watch.date          = @"1978_07_07";
    watch.accountMoney  = @"1000";
    watch.cardMoney     = @"121";
    watch.uid           = @"1";
    
    Watch *watch1 = [[Watch alloc] init];
    watch1.uuid          = @"123456";
    watch1.color         = @"红色";
    watch1.surfaceVer    = @"V1.0";
    watch1.softVer       = @"V1.0";
    watch1.power         = @"100%";
    watch1.date          = @"1978_07_07";
    watch1.accountMoney  = @"1000";
    watch1.cardMoney     = @"121";
    watch1.uid           = @"1";
    
    [db insertAWatchInfo:watch];
    [db insertAWatchInfo:watch1];
    
    NSArray *arr = [db getUserWatches:@"1"];
    NSLog(@"查询到的手环信息为 = %@",arr);
    
    [db modifyWatchInfo:@"123456" whichInfo:softVer      newValue:@"V1.2"];
    [db modifyWatchInfo:@"123456" whichInfo:power        newValue:@"9%"];
    [db modifyWatchInfo:@"123456" whichInfo:date         newValue:@"19890707"];
    [db modifyWatchInfo:@"654321" whichInfo:accountMoney newValue:@"1000000$"];
    [db modifyWatchInfo:@"654321" whichInfo:cardMoney    newValue:@"10000$"];
    
    [db deleteWatchInfo:@"654321"];
    
//闹钟
    Clockes *clock = [[Clockes alloc] init];
    clock.ck_name = @"上班闹钟";
    clock.ck_note = @"刷牙洗脸抹皮鞋";
    clock.ck_date = @"6:30";
    clock.ck_week = @"周一";
    clock.ck_state = @"1";
    clock.ck_watchUUID = @"123456";
    [db insertAClock:clock];
    
    NSArray *c_arr = [db getAllClock:@"123456"];
    for(int i=0;i<c_arr.count;i++){
        Clockes *temp = [c_arr objectAtIndex:i];
        NSLog(@"id = %d  name = %@",temp.ck_id,temp.ck_name);
    }
    
    Clockes *clock1 = [[Clockes alloc] init];
    clock1.ck_name = @"上班闹钟";
    clock1.ck_note = @"刷牙洗脸抹皮鞋";
    clock1.ck_date = @"7:30";
    clock1.ck_week = @"周一、周二";
    clock1.ck_state = @"0";
    clock1.ck_watchUUID = @"123456";
    clock1.ck_id = 1;
    [db modifyAClock:clock1];
    
    [db deleteAClock:10];
    
//运动步数

    Movementes *move = [[Movementes alloc] init];
    NSDate * date = [NSDate date];
    move.mv_date        = date;
    move.mv_step        = @"1000000";
    move.mv_distance    = @"1000000";
    move.mv_calorie     = @"2000000";
    move.mv_goalStep    = @"5000000";
    move.mv_watchUUID   = @"123456";
//    [db insertAMovementRecord:move];
    
//    Movementes *mv = [db getTodayMovementRecord];
//    NSLog(@"mv = %@",mv);
//
//    NSArray *mvarr = [db getMovementInDays:5];
//    NSLog(@"mvarr = %@",mvarr);
//    
//    move.mv_id = 5;
//    BOOL bb = [db modifyMovementValue:move];

    
//睡眠记录
    Sleepes *sleep = [[Sleepes alloc] init];
    sleep.sp_date = [NSDate date];
    sleep.sp_begintTime = @"22:00";
    sleep.sp_endTime = @"6:00";
    sleep.sp_clearTime = @"5";
    sleep.sp_sleepDegree = @"deep";
    sleep.sp_watchUUID = @"123456";
    [db insertASleepRecord:sleep];
    
    NSArray *sparr = [db getSleepRecordInDays:5];
    NSLog(@"mvarr = %@",sparr);
    

//充值记录
    Charges *chage = [[Charges alloc] init];
    chage.cg_chargeMoney = @"1000.";
    chage.cg_chargeWay   = @"在线充值";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    chage.cg_chargeTime  = strDate;
    chage.cg_chargeAddress = @"深圳";
    chage.cg_TSN = @"19021931238931844";
    chage.cg_watchUUID = @"123456";
    [db insertAChargeRecord:chage];
    
    NSArray *cgarr = [db getChargeRecordInDays:5];
    NSLog(@"cgarr = %@",cgarr);
    
//银行卡绑定
    BindCard *bc = [[BindCard alloc] init];
    bc.bc_bankName = @"农业银行";
    bc.bc_cardNumber = @"8000988890378876";
    bc.bc_bindTime = strDate;
    bc.bc_watchUUID = @"123456";
    [db insertAbindcardInfo:bc];
    
    NSArray *carArr = [db getAllBindcardInfo:@"123456"];
    NSLog(@"carArr = %@",carArr);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --------------------------------------- 开始扫描周围设备
- (void)beganScann {
    if(bleHelp == nil){
        bleHelp = [[BLeHelper alloc] initBabyBle];
        bleHelp.scannTime = 6;
        bleHelp.delegate = self;
        bleHelp.deviceUUID    = @"C0933BCB-F113-0567-F826-154BFAECCC68";
        
        bleHelp.serviceUUID   = @"48EB9001-F352-5FA0-9B06-8FCAA22602CF";
        
        bleHelp.writeUUID     = @"48EB9002-F352-5FA0-9B06-8FCAA22602CF";
        
        bleHelp.characterUUIDArray = [[NSArray alloc] initWithObjects:@"48EB9002-F352-5FA0-9B06-8FCAA22602CF",
                                                                      @"48eb9003-f352-5fa0-9b06-8fcaa22602cf",
                                                                      nil];
        
        
    }
    [bleHelp startScann];
}


/**********************************************************************/
/**********************************************************************/
/**********************************************************************/
//一些代理
#pragma mark --------------------------------------- 发现新设备
- (void)findNewDevice:(NSMutableDictionary *)bleDic{
    if(deviceArray.allKeys.count > 0){
        [deviceArray removeAllObjects];
    }
    deviceArray = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary *)bleDic];
    [deviceTable reloadData];
}

#pragma mark --------------------------------------- 扫描结束
- (void)scannFinish:(NSMutableDictionary *)bleDic{
    NSLog(@"扫描设备结束 = %@",bleDic);
    if(deviceArray.allKeys.count > 0){
        [deviceArray removeAllObjects];
    }
    deviceArray = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary *)bleDic];
    [deviceTable reloadData];
    if(connectDeviceUUID.length > 0){
        CBPeripheral *per = [deviceArray objectForKey:connectDeviceUUID];
        [bleHelp connectDevice:per];
    }
}

#pragma mark --------------------------------------- 连接成功
- (void)connectSuccess:(CBPeripheral *)per{
//    connectDeviceUUID = per.identifier.UUIDString;
//    [NSTimer scheduledTimerWithTimeInterval:1.0
//                                     target:self
//                                   selector:@selector(getRSSI)
//                                   userInfo:nil
//                                    repeats:YES];
    
}

#pragma mark --------------------------------------- 连接成功，发现制定服务和特征
- (void)connectSuccessAndFindSerivce:(CBPeripheral *)per character:(CBCharacteristic *)character{
    myPer = per;
    connectDeviceUUID = per.identifier.UUIDString;
    myCharacter = character;
}


#pragma mark --------------------------------------- 连接失败
- (void)connectFailed{
    
}

#pragma mark --------------------------------------- 由于距离等一些原因，设备断开连接
- (void)disConnectWithDevice{
    
}

#pragma mark --------------------------------------- 手机蓝牙被打开
- (void)blePowerOn{
    [self beganScann];
}

#pragma mark --------------------------------------- 手机蓝牙被关闭
- (void)blePowerOff{

}

#pragma mark --------------------------------------- 读取已连接设备的值，在连接成功后可调用
- (void)getRSSI{
    [bleHelp getRSSIValueOfConnectDevice];
}


/**********************************************************************/
/**********************************************************************/
/**********************************************************************/
#pragma mark ------------------------------------------------ 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark ------------------------------------------------ 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [deviceArray allKeys].count;
}

#pragma mark ------------------------------------------------ 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.;
}

#pragma mark ------------------------------------------------ 点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *keys = [deviceArray allKeys];
    NSString *key = [keys objectAtIndex:indexPath.row];
    CBPeripheral *per = [deviceArray objectForKey:key];
    [bleHelp connectDevice:per];
}

#pragma mark ------------------------------------------------ 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"tableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] init];
    }
    NSArray *keys = [deviceArray allKeys];
    NSString *key = [keys objectAtIndex:indexPath.row];
    CBPeripheral *per = [deviceArray objectForKey:key];
    if([per.name rangeOfString:@"E3E4"].location != NSNotFound){
        cell.textLabel.textColor = [UIColor redColor];
    }
    cell.textLabel.text = per.name;
    return cell;
}




- (NSData*) hexToBytes:(NSString *)string {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= string.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [string substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}


- (IBAction)testWriteValue:(id)sender {
    
//    Byte b1[20] = {0xc0,0x01,0x00,0x00,0x00,0x00,0x04,0x00,0x0e,0x1e,0x00,0x0a,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
//    
//    Byte b2[5] = {0x00,0x00,0x15,0x05,0xc0};
//    
//    NSData *d1 =  [[NSData alloc] initWithBytes:b1 length:20];
//    
//    
//    
//    NSData *d2 =  [[NSData alloc] initWithBytes:b2 length:5];
//    
//    
//    [bleHelp writeValueToDevice:d1];
//    
//    [bleHelp writeValueToDevice:d2];
    
    
    
//    [self performSelector:@selector(testSend) withObject:nil afterDelay:1.0];
    
    
    Byte b3[11] = {0xc0,0x01,0x00,0x00,0x01,0x01,0x01,0x00,0x00,0x00,0xc0};
    NSData *d3 =  [[NSData alloc] initWithBytes:b3 length:11];
    [bleHelp writeValueToDevice:d3];
//
//    BankPayBase *bank = [[BankPayBase alloc] init];
//    NSString *s = [bank sendMustData];
//    NSData *d3 = [s dataUsingEncoding:NSUTF8StringEncoding];
//    [bleHelp writeValueToDevice:d3];
}


- (void)testSend{
//    Byte b3[11] = {0xc0,0x01,0x00,0x00,0x01,0x01,0x01,0x00,0x00,0x00,0xc0};
//    NSData *d3 =  [[NSData alloc] initWithBytes:b3 length:11];
//    [bleHelp writeValueToDevice:d3];
    
    Byte b1[20] = {0xc0,0x01,0x00,0x00,0x00,0x00,0x04,0x00,0x0e,0x1e,0x00,0x0a,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
    
    Byte b2[5] = {0x00,0x00,0x15,0x05,0xc0};
    
    NSData *d1 =  [[NSData alloc] initWithBytes:b1 length:20];
    
    
    
    NSData *d2 =  [[NSData alloc] initWithBytes:b2 length:5];
    
    
    [bleHelp writeValueToDevice:d1];
    
    [bleHelp writeValueToDevice:d2];
    
}

//nsdata转成16进制字符串
- (NSString*)stringWithHexBytes2:(NSData *)sender {
    static const char hexdigits[] = "0123456789ABCDEF";
    const size_t numBytes = [sender length];
    const unsigned char* bytes = [sender bytes];
    char *strbuf = (char *)malloc(numBytes * 2 + 1);
    char *hex = strbuf;
    NSString *hexBytes = nil;
    
    for (int i = 0; i<numBytes; ++i) {
        const unsigned char c = *bytes++;
        *hex++ = hexdigits[(c >> 4) & 0xF];
        *hex++ = hexdigits[(c ) & 0xF];
    }
    
    *hex = 0;
    hexBytes = [NSString stringWithUTF8String:strbuf];
    
    free(strbuf);
    return hexBytes;
}


- (void)sendDataScuccess:(NSData *)backData{
    NSLog(@"发送数据后，设备返回的数据为 = %@",backData);
    
    NSString *s = [self stringWithHexBytes2:backData];
    if([s hasSuffix:@"C0"]){
    
        [self testSend];
    }
}


@end
