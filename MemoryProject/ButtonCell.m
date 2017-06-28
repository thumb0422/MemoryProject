//
//  ButtonCell.m
//  MemoryProject
//
//  Created by chliu.brook on 28/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "ButtonCell.h"
#import "UIColor+KYRandomColor.h"

@implementation ButtonCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor randomColor];
}

@end
