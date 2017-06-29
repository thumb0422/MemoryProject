//
//  NSObject+Dictionary.m
//  Security
//
//  Created by chliu.brook on 14/06/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "NSObject+Dictionary.h"
#import <objc/runtime.h>
#import "ModelObject.h"

@implementation NSObject (Dictionary)

- (NSDictionary *)propertyToproperty {
    NSMutableDictionary *dictionary = [@{} mutableCopy];
    
    unsigned int propertyCount;
    objc_property_t *properties = NULL;
    
    unsigned int selfPropertyCount;
    objc_property_t *selfProperties = class_copyPropertyList([self class], &selfPropertyCount);
    
    objc_property_t *superProperties = NULL;
    Class superClass = class_getSuperclass([self class]);
    
    if (superClass != [ModelObject class] && superClass != [NSObject class] && [superClass isSubclassOfClass:[ModelObject class]]) {
        propertyCount = selfPropertyCount;
        for (; superClass != [ModelObject class]; superClass = class_getSuperclass(superClass)) {
            unsigned int superPropertyCount;
            superProperties = class_copyPropertyList(superClass, &superPropertyCount);
            propertyCount += superPropertyCount;
        }
        
        properties = malloc(propertyCount*sizeof(objc_property_t));
        if (properties != NULL) {
            memcpy(properties, selfProperties, selfPropertyCount*sizeof(objc_property_t));
            
            unsigned int position = selfPropertyCount;
            superClass = class_getSuperclass([self class]);
            for (; superClass != [ModelObject class]; superClass = class_getSuperclass(superClass)) {
                unsigned int superPropertyCount;
                superProperties = class_copyPropertyList(superClass, &superPropertyCount);
                
                memcpy(properties+position, superProperties, superPropertyCount*sizeof(objc_property_t));
                position += superPropertyCount;
            }
        }
    }
    else {
        properties = selfProperties;
        propertyCount = selfPropertyCount;
    }
    
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName =
        [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [dictionary setValue:propertyName forKey:propertyName];
    }
    free(properties);
    superProperties = NULL;
    selfProperties = NULL;
    return dictionary;
}

@end
