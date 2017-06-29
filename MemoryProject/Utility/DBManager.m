//
//  DBManager.m
//  Security
//
//  Created by chliu.brook on 12/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "DBManager.h"

@interface DBManager(){
    FMResultSet *_resultSet;
}

@property(nonatomic,strong) FMDatabase *db;

@end

@implementation DBManager

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

-(id)init{
    self = [super init];
    if (self){
        [self createDB];
    }
    return self;
}

-(FMDatabase *)db{
    if (!_db){
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.db"];
//        NSLog(@"%@",path);
        _db = [FMDatabase databaseWithPath:path];
    }
    return _db;
}

-(void)createDB{
    if ([self.db open]){
        NSString *db005TableSql = @"CREATE TABLE db005 (accountKey  VARCHAR (30) NOT NULL UNIQUE PRIMARY KEY,account VARCHAR (200) NOT NULL,accountPWD  VARCHAR (250) NOT NULL,accountDesc VARCHAR (255)  NOT NULL,dataType VARCHAR (8) NOT NULL)";
        BOOL table005 = [self.db executeUpdate:db005TableSql];
        if (table005){
//            NSLog(@"建表成功");
        }
    }else {
        NSLog(@"建库失败");
    }
    
}

-(BOOL)openOrCreateDB{
    if ([self.db open]){
        return YES;
    }else{
        return NO;
    }
}

-(void)closeDB{
    BOOL isClose = [self.db close];
    if (isClose){
//        NSLog(@"close success");
    }else {
        NSLog(@"close failed");
    }
}

- (BOOL)notResultSetWithSql:(NSString*)sql {
    BOOL result = NO;
    BOOL isOpen = [self openOrCreateDB];
    if (isOpen) {
        result = [self.db executeUpdate:sql];
        [self closeDB];
        return result;
    } else {
        NSLog(@"打开数据库失败");
        return result;
    }
}

- (NSArray*)qureyWithSql:(NSString*)sql {
    //打开数据库
    BOOL isOpen = [self openOrCreateDB];
    if (isOpen) {
        //得到所有记录的结果集
        FMResultSet *set = [self.db executeQuery:sql];
        //声明一个可变数组,用来存放所有的记录
        NSMutableArray *array = [NSMutableArray array];
        //遍历结果集,取出每一条记录,将每一条记录转换为字典类型,并且存储到可变数组中
        while ([set next]) {
            //直接将一条记录转换为字典类型
            NSDictionary *dic = [set resultDictionary];
            [array addObject:dic];
        }
        //释放结果集
        [set close];
        [self closeDB];
        return array;
    } else {
        NSLog(@"打开数据库失败");
        return nil;
    }
}
@end
