//
//  db005.m
//  Security
//
//  Created by chliu.brook on 12/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "db005.h"

@implementation db005

-(id)init{
    self = [super init];
    if (self){
        self.dataType = @"";
        self.account = @"";
        self.accountKey = [NSString uuidString];
        self.accountPWD = @"";
        self.accountDesc = @"";
    }
    return self;
}

@end
