//
//  Stu.m
//  Realm-ObjC
//
//  Created by LiLe on 2018/10/9.
//Copyright © 2018年 LiLe. All rights reserved.
//

#import "Stu.h"

@implementation Stu

// *** Terminating app due to uncaught exception 'RLMException', reason: ''Stu' does not have a primary key and can not be updated'
+ (NSString *)primaryKey
{
    return @"num";
}

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"love" : @"乐乐乐"};
}

// Specify properties to ignore (Realm won't persist these)

+ (NSArray<NSString *> *)ignoredProperties
{
    return @[@"love"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%d - %@ - %@", self.num, self.name, self.love];
}

@end
