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

@interface ViewController (){
    NSArray *_typeArray;
    NSArray *_imageArray;
}
@property (nonatomic,strong) DYYFloatWindow *floatWindow;
@end

@implementation ViewController
static NSString * const reuseIdentifier = @"ButtonCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    //理财、邮箱、社交、购物、支付、游戏、培训、其他
    _typeArray = [TYPES componentsSeparatedByString:@"、"];
    _imageArray = @[@"licai",@"youxiang",@"gouwu",@"youxi",@"gouwu",@"licai",@"youxiang",@"youxi"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.floatWindow showWindow];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.floatWindow dissmissWindow];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(DYYFloatWindow *)floatWindow{
    if (_floatWindow == nil){
        _floatWindow = [[DYYFloatWindow alloc]initWithFrame:CGRectMake(self.view.width - 100, self.view.height - 100, 50, 50) mainImageName:@"add.png" bgcolor:[UIColor lightGrayColor] animationColor:[UIColor purpleColor]];
        __weak typeof(self) weakSelf = self;
        _floatWindow.clickBolcks = ^(NSInteger i) {
            [weakSelf performSegueWithIdentifier:@"Home2AddVC" sender:nil];
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
    cell.tag = 1000 + indexPath.row;
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
        vc.type = ((ButtonCell *)sender).tag;
    }
}
@end
