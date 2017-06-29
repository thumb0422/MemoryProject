//
//  DBManager.h
//  Security
//
//  Created by chliu.brook on 12/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//  数据库存储管理

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+(instancetype)getInstance;

- (BOOL)notResultSetWithSql:(NSString*)sql;

- (NSArray*)qureyWithSql:(NSString*)sql;
@end
