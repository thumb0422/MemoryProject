//
//  StoreManager.m
//  Security
//
//  Created by chliu.brook on 12/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "StoreManager.h"
#import "DBManager.h"

@interface StoreManager (){
    
}
@property (nonatomic,strong) DBManager *dbm;
@end

@implementation StoreManager

static id _instance = nil;

+(instancetype)getInstance{
    return [[self alloc] init];
}

/**
 重写allocWithZone方法，用来保证其他人直接使用alloc和init试图获得一个新实力的时候不产生一个新实例
 */

+(id)allocWithZone:(NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

//copy在底层 会调用copyWithZone:
- (id)copyWithZone:(NSZone *)zone{
    return  _instance;
}

+ (id)copyWithZone:(struct _NSZone *)zone{
    return  _instance;
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

-(DBManager *)dbm{
    if (!_dbm){
        _dbm = [DBManager getInstance];
    }
    return _dbm;
}

-(void)storeDataToStorage:(NSDictionary *)data{
    kDataAction action = (kDataAction)([[data objectForKey:@"action"] integerValue]);
    NSString *sqlStr = @"";
    if (action == kDataActionAdd){
        sqlStr = [self insertSQL:data];
    }else if (action == kDataActionDelete){
        sqlStr = [self deleteSQL:data];
    }else if (action == kDataActionUpdate){
        sqlStr = [self updateSQL:data];
    }
    if (![sqlStr isEqualToString:@""]){
        [self.dbm notResultSetWithSql:sqlStr];
    }
}

/**
 insertSQL

 @param data data
 @return sql
 */
-(NSString *)insertSQL:(NSDictionary *)data{
    NSString *result = @"";
    result = [NSString stringWithFormat:@"insert into %@ (",[data objectForKey:@"tableName"]];
    NSDictionary *tableInfoDic = [data objectForKey:@"tableInfo"];
    NSString __block *columnStr = @"";
    NSString __block *columnValueStr = @"";
    [tableInfoDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *column = key;
        NSString *columnValue = obj;
        columnStr = [NSString stringWithFormat:@"%@,%@",columnStr,column];
        columnValueStr = [NSString stringWithFormat:@"%@,'%@'",columnValueStr,columnValue];
    }];
    //去掉第一个多余的 逗号
    columnStr = [columnStr substringFromIndex:1];
    columnValueStr = [columnValueStr substringFromIndex:1];
    
    result = [NSString stringWithFormat:@"%@%@) values (%@)",result,columnStr,columnValueStr];
    return result;
}

/**
 updateSQL

 @param data data
 @return sql
 */
-(NSString *)updateSQL:(NSDictionary *)data{
    __block NSString *resultSql = [NSString stringWithFormat:@"update %@ set ",[data objectForKey:@"tableName"]];
    NSDictionary *tableDic = [data objectForKey:@"tableInfo"];
//    [tableDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        if ((key) && (obj) && ![key isEqualToString:@""] && ![obj isEqualToString:@""]){
//            resultSql = [NSString stringWithFormat:@"%@ and %@ = '%@'",resultSql,key,obj];
//        }
//    }];
    NSArray *keyArray = tableDic.allKeys;
    for (int i = 0;i<keyArray.count;i++){
        NSString *key = [keyArray objectAtIndex:i];
        NSString *obj = [tableDic.allValues objectAtIndex:i];
        if ((key) && (obj) && ![key isEqualToString:@""] && ![obj isEqualToString:@""]){
            if (i == 0){
                resultSql = resultSql;
            }else {
                resultSql = [NSString stringWithFormat:@"%@ , ",resultSql];
            }
            resultSql = [NSString stringWithFormat:@"%@  %@ = '%@'",resultSql,key,obj];
        }
    }
    resultSql = [NSString stringWithFormat:@"%@ where 1=1 ",resultSql];
    NSDictionary *filterDic = [data objectForKey:@"filterInfo"];
    [filterDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ((key) && (obj) && ![key isEqualToString:@""] && ![obj isEqualToString:@""]){
            resultSql = [NSString stringWithFormat:@"%@ and %@ = '%@'",resultSql,key,obj];
        }
    }];
    return resultSql;
}

/**
 deleteSQL

 @param data data
 @return sql
 */
-(NSString *)deleteSQL:(NSDictionary *)data{
    __block NSString *returnSql = [NSString stringWithFormat:@"delete from %@ where 1=1 ",[data objectForKey:@"tableName"]];
    NSDictionary *tableDic = [data objectForKey:@"filterInfo"];
    [tableDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ((key) && (obj) && ![key isEqualToString:@""] && ![obj isEqualToString:@""]){
            returnSql = [NSString stringWithFormat:@"%@ and %@ = '%@'",returnSql,key,obj];
        }
    }];
    return returnSql;
}

/**
 getDataByDataKey

 @param data data
 @return dataArray
 */
-(NSArray *)qryData:(NSDictionary *)data{
    __block NSString *qryStr = [NSString stringWithFormat:@"select * from %@ where 1=1",[data objectForKey:@"tableName"]];
    NSDictionary *tableDic = [data objectForKey:@"filterInfo"];
    [tableDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        qryStr = [NSString stringWithFormat:@"%@ and %@ = '%@'",qryStr,key,obj];
    }];
    NSArray *qryArray = [self.dbm qureyWithSql:qryStr];
    return qryArray;
}
@end
