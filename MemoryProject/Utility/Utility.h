//
//  Utility.h
//  Security
//
//  Created by chliu.brook on 13/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
#define INT2STRING(x)       [NSString stringWithFormat:@"%ld",(x)]
#else
#define INT2STRING(x)       [NSString stringWithFormat:@"%d",(x)]
#endif

#define FLOAT2STRING(x)     [NSString stringWithFormat:@"%.2f",(x)]
#define ID2STRING(x)        [NSString stringWithFormat:@"%@",(x)]

#define degreesToRadian(x)        (M_PI * (x) / 180.0)
#define radianToDegrees(radian)   (radian * 180.0) / (M_PI)

#define fequal(a, b)  (fabsf((a) - (b)) < FLT_EPSILON) //判断两个float是否相等
#define fequalzero(a) (fabsf(a) < FLT_EPSILON)          //判断float数字是否为0
#define dequal(a, b)  (fabs((a) - (b)) < DBL_EPSILON)  //判断两个double是否相等
#define dequalzero(a) (fabs(a) < DBL_EPSILON)          //判断double数字是否为0

#define SECMODEL(cls, jsonDic, err) modelFromJsonDic(cls, jsonDic, err)
#define SECMODELS(cls, jsonArray, err) modelsFromJsonArray(cls, jsonArray, err)

#define DictionaryToModel(Class, NSDictionary)                                                                 \
{                                                                                                              \
    id value = [[Class alloc] init];                                                                               \
    [value setValuesForKeysWithDictionary:NSDictionary];                                                           \
    return value;                                                                                                  \
}

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)
#define STATUS_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAV_HEIGHT      (self.navigationController.navigationBar.frame.size.height)
#define NAV_STATUS_HEIGHT (STATUS_HEIGHT + NAV_HEIGHT)

#define AppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] // APP Name
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define AppBuild [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define AppBundle [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
