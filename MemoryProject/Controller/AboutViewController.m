//
//  AboutViewController.m
//  MemoryProject
//
//  Created by chliu.brook on 02/07/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    [self.view setBackgroundColor:[UIColor colorWithHex:0xF3FFD4]];
    // Do any additional setup after loading the view.
    self.aboutLabel.text = @"   ";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
