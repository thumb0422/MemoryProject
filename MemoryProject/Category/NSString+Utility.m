//
//  NSString+Utility.m
//  Security
//
//  Created by chliu.brook on 16/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)

+ (NSString *)uuidString{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

+ (NSString *)warpped{
    return @"****************";
}
@end
