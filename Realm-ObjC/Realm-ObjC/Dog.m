//
//  Dog.m
//  Realm-ObjC
//
//  Created by LiLe on 2018/9/30.
//Copyright © 2018年 LiLe. All rights reserved.
//

#import "Dog.h"

@implementation Dog

+ (NSDictionary<NSString *,RLMPropertyDescriptor *> *)linkingObjectsProperties
{
    return @{@"master" : [RLMPropertyDescriptor descriptorWithClass:NSClassFromString(@"Person") propertyName:@"pets"]};
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
