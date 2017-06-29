//
//  AddViewController.h
//  MemoryProject
//
//  Created by chliu.brook on 28/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownSelectView.h"

@interface AddViewController : UIViewController
@property (weak, nonatomic) IBOutlet DownSelectView *accountType;
@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UITextField *accountPWDText;
@property (weak, nonatomic) IBOutlet UITextField *accountDescText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveDataBtn;

@end
