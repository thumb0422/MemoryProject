//
//  NSString+Utility.h
//  Security
//
//  Created by chliu.brook on 16/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

/**
 生成UUID

 @return UUID
 */
+(NSString *)uuidString;

/**
 把字符串显示成*********

 @return ********
 */
+ (NSString *)warpped;
@end
