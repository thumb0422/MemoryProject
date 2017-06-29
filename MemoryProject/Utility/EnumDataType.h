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
    kDataTypeA = 1000,
    kDataTypeB = 1001,
    kDataTypeC = 1002,
    kDataTypeD = 1003,
    kDataTypeOther = 2000,
};


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
    kDataActionQry    =  903,
    kDataActionOther  = 909,
};

#define DATA_TYPE_ARRAY @"娱乐、邮箱、支付、其他"
#endif /* EnumDataType_h */
