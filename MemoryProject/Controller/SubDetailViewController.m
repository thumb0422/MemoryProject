//
//  SubDetailViewController.m
//  MemoryProject
//
//  Created by chliu.brook on 28/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "SubDetailViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface SubDetailViewController ()<DownSelectViewDelegate>{
    BOOL isShowed;//是否显示明文
    StoreManager *storeManager;
    NSInteger selectedDataType;
}
@end

@implementation SubDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记忆详情";
    [self addObserver:self forKeyPath:@"isShowed" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    isShowed = false;
    [self setValue:[NSNumber numberWithBool:isShowed] forKey:@"isShowed"];
    selectedDataType = 1000;
    storeManager = [StoreManager getInstance];
    NSArray *typeArray = [TYPES componentsSeparatedByString:@"、"];
    self.accountType.placeholder = @"类型选择";
    self.accountType.delegate = self;
    self.accountType.listArray = typeArray;
    NSInteger dataType = [self.db.dataType integerValue] - 1000;
    if (dataType < 0){
        dataType = 0;
        NSLog(@"有异常数据");
    }
    NSString *selectTypeStr = [typeArray objectAtIndex:dataType];
    self.accountType.text = selectTypeStr;
    self.accountDescText.text = self.db.accountDesc;
    self.accountUrlText.text = self.db.accountUrl;
    [self extracted:isShowed];
    
    [self Indentify];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"isShowed"]){
        Boolean tmpShowed = [[self valueForKey:@"isShowed"] boolValue];
        [self textEnable:tmpShowed];
    }
}

- (void)extracted:(BOOL)isShow {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.accountText setText:(isShow ? [AESCrypt decrypt:self.db.account password:EnCryptPWD]:[NSString warpped])];
        [self.accountPWDText setText:(isShow ? [AESCrypt decrypt:self.db.accountPWD password:EnCryptPWD]:[NSString warpped])];
    });
}

-(void)textEnable:(BOOL)enable{
    UIColor *bgTmpColor = enable ? [UIColor whiteColor] :[UIColor colorWithHex:0xDBDEE4];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.accountType setMultipleTouchEnabled:enable];
        [self.accountType setBackgroundColor:bgTmpColor];
        
        [self.accountText setEnabled:enable];
        [self.accountText setBackgroundColor:bgTmpColor];
        
        [self.accountPWDText setEnabled:enable];
        [self.accountPWDText setBackgroundColor:bgTmpColor];
        
        [self.accountDescText setEnabled:enable];
        [self.accountDescText setBackgroundColor:bgTmpColor];
        
        [self.accountUrlText setEnabled:enable];
        [self.accountUrlText setBackgroundColor:bgTmpColor];
        
        [self.deleteBtn setHidden:!enable];
        
        [self.saveBtn setHidden:!enable];
    });
}

-(void)Indentify{
    __block BOOL isSuccess = false;
    //新建LAContext实例
    LAContext  *authenticationContext= [[LAContext alloc]init];
    NSError *error;
    //1:检查Touch ID 是否可用
    if ([authenticationContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSLog(@"touchId 可用");
        //2:执行认证策略
        NSString *localizedReson = [NSString stringWithFormat:@"%@需要验证您的指纹来确认您的身份信息",AppName];
        [authenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:localizedReson reply:^(BOOL success, NSError * _Nullable error) {
            isShowed = success;
            [self setValue:[NSNumber numberWithBool:isShowed] forKey:@"isShowed"];
            if (success) {
                isSuccess = YES;
                NSLog(@"通过了Touch Id指纹验证");
                [self extracted:isSuccess];
            }else{
                isSuccess = false;
                NSString *errorMsg = @"";
                NSLog(@"error===%@",error);
                NSLog(@"code====%ld",error.code);
                NSLog(@"errorStr ======%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]);
                if (error.code == -2) {//点击了取消按钮
                    NSLog(@"点击了取消按钮");
                }else if (error.code == -3){//点输入密码按钮
                    NSLog(@"点输入密码按钮");
                }else if (error.code == -1){//连续三次指纹识别错误
                    NSLog(@"连续三次指纹识别错误");
                    errorMsg = @"连续三次指纹识别错误";
                }else if (error.code == -4){//按下电源键
                    NSLog(@"按下电源键");
                }else if (error.code == -8){//Touch ID功能被锁定，下一次需要输入系统密码
                    NSLog(@"Touch ID功能被锁定，下一次需要输入系统密码");
                    errorMsg = @"指纹识别功能被锁定，下一次需要输入系统密码";
                }
                NSLog(@"未通过Touch Id指纹验证");
                if ([errorMsg isEqualToString:@""]){
                    errorMsg = @"未通过指纹验证";
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToast:errorMsg duration:1.5f position:CSToastPositionCenter];
                });
                [self extracted:isSuccess];
            }
        }];
    }else{
        //todo goto 输入密码页面
        isSuccess = false;
        isShowed = isSuccess;
        [self setValue:[NSNumber numberWithBool:isShowed] forKey:@"isShowed"];
        [self.view makeToast:@"抱歉，指纹识别不可用，不可查看具体信息" duration:1.5f position:CSToastPositionCenter];
    }
}

#pragma mark DownSelectViewDelegate
- (void)downSelectedView:(DownSelectView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath{
    selectedDataType = 1000 + indexPath.row;
}

- (IBAction)deleteClick:(UIButton *)sender {
    if (!isShowed){
        [self.view makeToast:@"未解锁，不能删除数据" duration:1.5f position:CSToastPositionCenter];
        return;
    }
    NSDictionary *deleteDic = @{@"action":[NSNumber numberWithInt:kDataActionDelete],
                                @"tableName":@"db005",
                                @"filterInfo":@{@"accountKey":self.db.accountKey}
                                };
    [storeManager storeDataToStorage:deleteDic];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveClick:(UIButton *)sender {
    if (!isShowed){
        [self.view makeToast:@"未解锁，不能更新数据" duration:1.5f position:CSToastPositionCenter];
        return;
    }
    //更新操作
    NSDictionary *updateDic = @{@"action":[NSNumber numberWithInt:kDataActionUpdate],
                                @"tableName":@"db005",
                                @"tableInfo":@{@"account":[AESCrypt encrypt:self.accountText.text password:EnCryptPWD],
                                               @"accountPWD":[AESCrypt encrypt:self.accountPWDText.text password:EnCryptPWD],
                                               @"accountUrl":self.accountUrlText.text,
                                               @"accountDesc":self.accountDescText.text,
                                               @"dataType":INT2STRING(selectedDataType)},
                                @"filterInfo":@{@"accountKey":self.db.accountKey}
                                };
    [storeManager storeDataToStorage:updateDic];
    [self.view makeToast:@"更新数据成功" duration:1.5f position:CSToastPositionCenter];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@,identify = %@",sender,segue.identifier);
}
 
-(IBAction)unwindForSegue:(UIStoryboardSegue *)unwindSegue towardsViewController:(UIViewController *)subsequentVC{
    NSLog(@"identify = %@",unwindSegue.identifier);
}
@end
