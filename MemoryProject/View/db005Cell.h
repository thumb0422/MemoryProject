//
//  db005Cell.h
//  Security
//
//  Created by chliu.brook on 14/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "db005.h"
@interface db005Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *accountDescText;

-(void)updateData:(db005 *)data;
@end
