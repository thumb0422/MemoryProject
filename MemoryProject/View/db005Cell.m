//
//  db005Cell.m
//  Security
//
//  Created by chliu.brook on 14/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "db005Cell.h"

@implementation db005Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)updateData:(db005 *)data{
//    self.accountText.text = data.account;
//    self.accountPWDText.text = data.accountPWD;
    self.accountDescText.text = data.accountDesc;
}
@end
