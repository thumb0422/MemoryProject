//
//  DetailTVController.m
//  MemoryProject
//
//  Created by chliu.brook on 30/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "DetailTVController.h"
#import "DetailCell.h"
#import "db005.h"
#import "SubDetailViewController.h"
@interface DetailTVController (){
    NSMutableArray *_dataArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) StoreManager *storeManager;
@end

@implementation DetailTVController
@synthesize tableView;
static NSString * const reuseIdentifier = @"DetailCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"detail";
    NSArray *typeArray = [TYPES componentsSeparatedByString:@"、"];
    self.title = [NSString stringWithFormat:@"%@记忆",[typeArray objectAtIndex:(_type - 1000)]];
    _dataArray = [NSMutableArray arrayWithCapacity:0];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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

#pragma mark storeManager
-(StoreManager *)storeManager{
    if (_storeManager == nil){
        _storeManager = [StoreManager getInstance];
    }
    return _storeManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.tag = indexPath.row;
    db005 *data = [_dataArray objectAtIndex:indexPath.row];
    cell.accountDescText.text = data.accountDesc;
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"DetailTV2SubDetail"]){
        SubDetailViewController *vc = segue.destinationViewController;
        NSInteger row = -1;
        if ([sender isKindOfClass:(DetailCell.self)]){
            row = ((DetailCell *)sender).tag;
        }
        if (row < 0){
            row = 0;
        }
        vc.db = [_dataArray objectAtIndex:row];
    }
}

-(IBAction)unwindForSegue:(UIStoryboardSegue *)unwindSegue towardsViewController:(UIViewController *)subsequentVC{
    
}

@end
