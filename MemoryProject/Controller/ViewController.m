//
//  ViewController.m
//  MemoryProject
//
//  Created by chliu.brook on 28/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "ButtonCell.h"
#import "DYYFloatWindow.h"

@interface ViewController (){
    NSArray *_typeArray;
}
@property (nonatomic,strong) DYYFloatWindow *floatWindow;
@end

@implementation ViewController
static NSString * const reuseIdentifier = @"ButtonCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    _typeArray = [TYPES componentsSeparatedByString:@"、"];
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

-(DYYFloatWindow *)floatWindow{
    if (_floatWindow == nil){
        _floatWindow = [[DYYFloatWindow alloc]initWithFrame:CGRectMake(self.view.width - 65, self.view.height - 65, 50, 50) mainImageName:@"add.png" bgcolor:[UIColor lightGrayColor] animationColor:[UIColor purpleColor]];
        __weak typeof(self) weakSelf = self;
        _floatWindow.clickBolcks = ^(NSInteger i) {
            UIViewController *vc = [HOME_STORYBOARD instantiateViewControllerWithIdentifier:@"AddViewController"];
            [weakSelf presentViewController:vc animated:YES completion:^{
                //todo
            }];
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
    cell.titleLabel.text = [_typeArray objectAtIndex:indexPath.row];
    cell.type = 1000 + indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"++++ %ld",indexPath.row);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"--- %ld",indexPath.row);
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
    NSLog(@"%@,identify = %@",sender,segue.identifier);
    if ([[segue destinationViewController] class] == [DetailViewController class]){
        DetailViewController *vc = [segue destinationViewController];
        vc.type = ((ButtonCell *)sender).type;
    }
    
}
@end
