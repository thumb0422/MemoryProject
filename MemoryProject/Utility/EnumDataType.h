//
//  EnumDataType.h
//  Security
//
//  Created by chliu.brook on 12/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#ifndef EnumDataType_h
#define EnumDataType_h

typedef NS_ENUM (NSInteger,kDataType){
    kDataTypeA = 1000,//理财
    kDataTypeB = 1001,//邮箱
    kDataTypeC = 1002,//社交
    kDataTypeD = 1003,//购物
    kDataTypeE = 1004,//支付
    kDataTypeF = 1005,//游戏
    kDataTypeOther = 2000,//其他
};
#define TYPES  @"理财、邮箱、社交、购物、支付、游戏、其他"

/**
 存储数据action

 - kDataActionAdd: insert
 - kDataActionUpdate: update
 - kDataActionDelete: delete
 - kDataActionOther: other
 */
typedef NS_ENUM (NSInteger,kDataAction){
    kDataActionAdd    = 900,
    kDataActionUpdate = 901,
    kDataActionDelete = 902,
    kDataActionQry    = 903,
    kDataActionOther  = 909,
};

#endif /* EnumDataType_h */
