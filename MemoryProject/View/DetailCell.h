//
//  DetailCell.h
//  MemoryProject
//
//  Created by chliu.brook on 28/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *accountUrlText;
@property (weak, nonatomic) IBOutlet UITextField *accountDescText;

@end
