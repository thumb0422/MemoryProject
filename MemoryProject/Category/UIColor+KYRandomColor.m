//
//  UIColor+KYRandomColor.m
//  CollectionDemo
//
//  Created by chliu.brook on 27/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "UIColor+KYRandomColor.h"

@implementation UIColor (KYRandomColor)

+(UIColor*) randomColor{
    CGFloat hue = arc4random() % 256 / 256.0; //色调随机:0.0 ~ 1.0
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5; //饱和随机:0.5 ~ 1.0
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5; //亮度随机:0.5 ~ 1.0
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (UIColor *) colorWithHex:(NSInteger)hexValue{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hexValue & 0xFF)) / 255.0
                           alpha:1.0f];
}
@end
