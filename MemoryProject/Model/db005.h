//
//  db005.h
//  Security
//
//  Created by chliu.brook on 12/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "ModelObject.h"
#import "EnumDataType.h"

@interface db005 : ModelObject

@property(nonatomic,copy) NSString *accountKey;//UUID
@property(nonatomic,copy) NSString *account;//帐号
@property(nonatomic,copy) NSString *accountPWD;//密码
@property(nonatomic,copy) NSString *accountDesc;//其他说明
@property(nonatomic,copy) NSString *dataType;//所属大类

@end
