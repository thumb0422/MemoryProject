//
//  DetailViewController.m
//  MemoryProject
//
//  Created by chliu.brook on 28/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "DetailViewController.h"
#import "SubDetailViewController.h"
#import "DetailCell.h"
#import "db005.h"

@interface DetailViewController (){
    NSMutableArray *_dataArray;
}
@property (nonatomic,strong) StoreManager *storeManager;
@end

@implementation DetailViewController
static NSString * const reuseIdentifier = @"DetailCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSDictionary *qryDic = @{@"tableName":@"db005",
                             @"filterInfo":@{@"dataType":INT2STRING(_type)}
                             };
    [self qryData:qryDic];
}

#pragma mark qryData
-(void)qryData:(NSDictionary *)qryDic{
    [_dataArray removeAllObjects];
    NSArray *qryDataArray = [self.storeManager qryData:qryDic];
    for (int i = 0;i < qryDataArray.count;i ++){
        NSError *error;
        db005 *db5 = SECMODEL([db005 class], [qryDataArray objectAtIndex:i], error);
        [_dataArray addObject:db5];
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark storeManager
-(StoreManager *)storeManager{
    if (_storeManager == nil){
        _storeManager = [StoreManager getInstance];
    }
    return _storeManager;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    SubDetailViewController *vc = [HOME_STORYBOARD instantiateViewControllerWithIdentifier:@"SubDetailViewController"];
//    vc.db = [_dataArray objectAtIndex:indexPath.row];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.tag = indexPath.row;
    db005 *data = [_dataArray objectAtIndex:indexPath.row];
    cell.accountDescText.text = data.accountDesc;
    return cell;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"%@,identify = %@",sender,segue.identifier);
    if ([segue.destinationViewController class] == [SubDetailViewController class]){
        SubDetailViewController *vc = segue.destinationViewController;
        NSInteger row = -1;
        if ([sender isKindOfClass:(DetailCell.self)]){
            row = ((DetailCell *)sender).tag;
        }
        vc.db = [_dataArray objectAtIndex:row];
    }
}
 
-(IBAction)unwindForSegue:(UIStoryboardSegue *)unwindSegue towardsViewController:(UIViewController *)subsequentVC{
    NSLog(@"identify = %@",unwindSegue.identifier);
}
@end
