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
    isShowed = false;
    self.title = @"记忆详情";
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

- (void)extracted:(BOOL)isShow {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.accountText setText:(isShow ? [AESCrypt decrypt:self.db.account password:EnCryptPWD]:[NSString warpped])];
        [self.accountPWDText setText:(isShow ? [AESCrypt decrypt:self.db.accountPWD password:EnCryptPWD]:[NSString warpped])];
    });
}

-(void)textEnable:(BOOL)enable{
    [self.accountType setMultipleTouchEnabled:enable];
    [self.accountText setEnabled:enable];
    [self.accountPWDText setEnabled:enable];
    [self.accountDescText setEnabled:enable];
    [self.accountUrlText setEnabled:enable];
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
                    [self.view makeToast:errorMsg duration:1.5f position:CSToastPositionTop];
                });
                [self extracted:isSuccess];
            }
        }];
    }else{
        //todo goto 输入密码页面
        isSuccess = false;
        isShowed = isSuccess;
        [self.view makeToast:@"抱歉，指纹识别不可用，不可查看具体信息" duration:1.5f position:CSToastPositionTop];
    }
}

#pragma mark DownSelectViewDelegate
- (void)downSelectedView:(DownSelectView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath{
    selectedDataType = 1000 + indexPath.row;
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
