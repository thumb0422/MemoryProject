//
//  ViewController.m
//  MemoryProject
//
//  Created by chliu.brook on 28/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "ViewController.h"
#import "DetailTVController.h"
#import "ButtonCell.h"
#import "DYYFloatWindow.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface ViewController ()<MFMailComposeViewControllerDelegate,UIAlertViewDelegate>{
    NSArray *_typeArray;
    NSArray *_imageArray;
}
@property (nonatomic,strong) DYYFloatWindow *floatWindow;
@end

@implementation ViewController
static NSString * const reuseIdentifier = @"ButtonCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHex:0xEEFBFF]];
    [self.view addSubview:self.floatWindow];
    //理财、邮箱、社交、购物、支付、游戏、培训、其他
    _typeArray = [TYPES componentsSeparatedByString:@"、"];
    _imageArray = @[@"licai",@"youxiang",@"shejiao",@"gouwu",@"zhifu",@"youxi",@"work",@"qita"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.floatWindow showWindow];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.floatWindow dissmissWindow];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(DYYFloatWindow *)floatWindow{
    if (_floatWindow == nil){
        _floatWindow = [[DYYFloatWindow alloc]initWithFrame:CGRectMake(30, self.view.height - 80, 50, 50) mainImageName:@"contactUs" imagesAndTitle:@{@"clearData":@"清除数据",@"feedBack":@"反馈"/*，@"about":@"关于"*/} bgcolor:[UIColor yellowColor] animationColor:[UIColor purpleColor]];
        __weak typeof(self) weakSelf = self;
        _floatWindow.clickBolcks = ^(NSString *titleName) {
            if ([titleName isEqualToString:@"反馈"]){
                [weakSelf sendEmailFeedBack];
            }else if ([titleName isEqualToString:@"关于"]) {
                [weakSelf performSegueWithIdentifier:@"Home2About" sender:nil];
            }else if ([titleName isEqualToString:@"清除数据"]){
                [weakSelf clearAllData];
            }
            
        };
    }
    return _floatWindow;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _typeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[_imageArray objectAtIndex:indexPath.row]];
    cell.type = 1000 + indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark <UICollectionViewDelegate>
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
     return YES;
 }

 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     return YES;
 }

//-(IBAction)unwindForSegue:(UIStoryboardSegue *)unwindSegue towardsViewController:(UIViewController *)subsequentVC{
//
//}

-(IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Home2DetailTV"]){
        DetailTVController *vc = [segue destinationViewController];
        vc.type = ((ButtonCell *)sender).type;
    }
}

#pragma mark 清除数据
-(void)clearAllData{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"是否要清除数据,过程不可逆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        
    }else {
        NSDictionary *deleteDic = @{@"action":[NSNumber numberWithInt:kDataActionDelete],
                                    @"tableName":@"db005",
                                    };
        StoreManager *storeManager = [StoreManager getInstance];
        [storeManager storeDataToStorage:deleteDic];
        [self.view makeToast:@"清除数据成功" duration:1.0f position:CSToastPositionCenter];
    }
}
#pragma mark 发送邮件反馈
-(void)sendEmailFeedBack{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [self.view makeToast:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替" duration:1.5f position:CSToastPositionCenter];
        return;
    }
    if (![mailClass canSendMail]) {
        [self.view makeToast:@"用户没有设置邮件账户" duration:1.5f position:CSToastPositionCenter];
        return;
    }
    [self displayMailPicker];
}

//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: [NSString stringWithFormat:@"%@意见反馈",AppName]];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"thumb0422@163.com"];
    [mailPicker setToRecipients: toRecipients];
    
    NSString *emailBody = @"";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentViewController:mailPicker animated:YES completion:^{
        
    }];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *msg;
        switch (result) {
            case MFMailComposeResultCancelled:
                msg = @"取消编辑邮件";
                break;
            case MFMailComposeResultSaved:
                msg = @"成功保存邮件";
                break;
            case MFMailComposeResultSent:
                msg = @"邮件在队列中等待发送";
                break;
            case MFMailComposeResultFailed:
                msg = @"发送邮件失败";
                break;
            default:
                msg = @"";
                break;
        }
        if ([msg isEqualToString:@""]){
            
        }else {
            [self.view makeToast:msg duration:1.5f position:CSToastPositionCenter];
        }
    }];
}
@end
