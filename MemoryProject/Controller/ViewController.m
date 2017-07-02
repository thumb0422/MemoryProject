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

@interface ViewController ()<MFMailComposeViewControllerDelegate>{
    NSArray *_typeArray;
    NSArray *_imageArray;
}
@property (nonatomic,strong) DYYFloatWindow *floatWindow;
@end

@implementation ViewController
static NSString * const reuseIdentifier = @"ButtonCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.floatWindow];
    //理财、邮箱、社交、购物、支付、游戏、培训、其他
    _typeArray = [TYPES componentsSeparatedByString:@"、"];
    _imageArray = @[@"licai",@"youxiang",@"shejiao",@"gouwu",@"zhifu",@"youxi",@"qita"];
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
        _floatWindow = [[DYYFloatWindow alloc]initWithFrame:CGRectMake(30, self.view.height - 80, 50, 50) mainImageName:@"add" imagesAndTitle:@{@"feedBack":@"用户反馈",@"about":@"关于"} bgcolor:[UIColor whiteColor] animationColor:[UIColor purpleColor]];
        __weak typeof(self) weakSelf = self;
        _floatWindow.clickBolcks = ^(NSInteger i) {
            if (i == 0){
                [weakSelf sendEmailFeedBack];
            }else if (i ==1) {
                [weakSelf performSegueWithIdentifier:@"Home2About" sender:nil];
            }else{
                
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

#pragma mark 发送邮件反馈
-(void)sendEmailFeedBack{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [self.view makeToast:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替" duration:1.5f position:CSToastPositionTop];
        return;
    }
    if (![mailClass canSendMail]) {
        [self.view makeToast:@"用户没有设置邮件账户" duration:1.5f position:CSToastPositionTop];
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
    [mailPicker setSubject: @"记忆宝App意见反馈"];
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
            [self.view makeToast:msg duration:1.5f position:CSToastPositionTop];
        }
    }];
}
@end
