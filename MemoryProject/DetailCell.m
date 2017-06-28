//
//  DetailCell.m
//  MemoryProject
//
//  Created by chliu.brook on 28/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "DetailCell.h"
#import "UIColor+KYRandomColor.h"
@implementation DetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor randomColor];
    self.accountDescText.enabled = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
