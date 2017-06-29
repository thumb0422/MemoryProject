//
//  AddViewController.m
//  MemoryProject
//
//  Created by chliu.brook on 28/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "AddViewController.h"
#import "db005.h"

@interface AddViewController ()<DownSelectViewDelegate>{
    NSInteger selectedDataType;
}

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.accountType.placeholder = @"类型选择";
    self.accountType.delegate = self;
    self.accountType.listArray = [TYPES componentsSeparatedByString:@"、"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveClick:(id)sender {
    if ([self.accountDescText.text isEqualToString:@""]){
        [self.view makeToast:@"请输入说明信息"];
        return;
    }
    db005 *db5 = [[db005 alloc] init];
    db5.account = [AESCrypt encrypt:self.accountText.text password:EnCryptPWD];
    db5.accountPWD = [AESCrypt encrypt:self.accountPWDText.text password:EnCryptPWD];
    db5.accountDesc = self.accountDescText.text;
    db5.dataType = INT2STRING(selectedDataType);
    [db5 doAction:kDataActionAdd];
    [self.view makeToast:@"保存成功" duration:1.5f position:CSToastPositionTop];
    UIViewController *vc = [HOME_STORYBOARD instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:vc animated:YES completion:^{
        //todo
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark DownSelectViewDelegate
- (void)downSelectedView:(DownSelectView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath{
    selectedDataType = indexPath.row + 1000;
}

@end
