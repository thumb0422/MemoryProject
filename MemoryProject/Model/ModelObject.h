//
//  ModelObject.h
//  Security
//
//  Created by chliu.brook on 12/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelObject : MTLModel<MTLJSONSerializing>

/**
 *  json key 值映射
 *  属性名与json key
 *  @return NSDictionary
 */
+ (NSDictionary *)mapKey;

/**
 *  过滤掉不参加映射的属性值
 *
 *  @return NSArray
 */
+ (NSArray *)filter;

/**
 对对象的操作

 @param action 操作类型
 */
-(void)doAction:(kDataAction)action;

@end

id modelsFromJsonArray(Class cls, NSArray *jsonArray, NSError *err);
id modelFromJsonDic(Class cls, NSDictionary *jsonDic, NSError *err);

