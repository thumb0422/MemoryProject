//
//  StoreManager.h
//  Security
//
//  Created by chliu.brook on 12/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

/**************************
data 格式
action:U/A/D
tableName:tableName //表名
tableInfo:dictionary //需要变化的字段名与字段值
filterInfo:dictionary //过滤条件(主要在update 与 delete)
**************************/

#import <Foundation/Foundation.h>
#import "EnumDataType.h"

@interface StoreManager : NSObject

+(instancetype)getInstance;

/**
 把数据存储进文件系统 U/A/D

 @param data data
 */
-(void)storeDataToStorage:(NSDictionary *)data;

/**
 根据key条件查找出对应数据

 @param data 格式
 @return NSArray
 */
-(NSArray *)qryData:(NSDictionary *)data;

@end
