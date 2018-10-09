//
//  Person.m
//  Realm-ObjC
//
//  Created by LiLe on 2018/9/30.
//Copyright © 2018年 LiLe. All rights reserved.
//

#import "Person.h"

@implementation Person

// 设置主键,确保数据唯一性
+ (NSString *)primaryKey
{
    return @"personId";
}

// 设置属性不为nil
+ (NSArray<NSString *> *)requiredProperties
{
    return @[@"sex"];
}

// 设置默认值,对于不为null的属性,默认给空
+ (NSDictionary *)defaultPropertyValues
{
    return @{@"sex":@""};
}

//索引属性,主要用于搜索,根据性别进行搜索
+ (NSArray<NSString *> *)indexedProperties
{
    return @[@"sex",@"woman"];
}

- (UIImage *)image
{
    return [UIImage imageWithData:self.imageData];
}

@end
