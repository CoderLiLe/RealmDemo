//
//  Person.h
//  Realm-ObjC
//
//  Created by LiLe on 2018/9/30.
//Copyright © 2018年 LiLe. All rights reserved.
//  https://blog.csdn.net/Simona_1973/article/details/82685212?utm_source=copy

/*
 
 关于RLMObject
 1.Realm忽略了OC的属性特性(如nonatomic, atomic, strong, retain, weak, copy等),所以在声明属性时可不写，这些特性会一直生效直到被写入数据库。
 2.Realm支持以下的类型BOOL, NSInteger, long, double, CGFloat, NSString, NSDate, NSData等
 3.定义了RLM_ARRAY_TYPE(Person)表示支持RLMArray属性,相当于允许RLMArray<Person>属性的使用,例如:在其他属性里可@property RLMArray<Person *><Person> *personal如此使用,相当于继承关系
 
 */

#import <Realm/Realm.h>
#import <UIKit/UIKit.h>
#import "Dog.h"

@interface Person : RLMObject

@property NSString *personId;
@property BOOL status;
@property NSString *sex;

@property (readonly) UIImage *image;
@property NSData *imageData;
//@property NSArray<NSString *> *strArr;
// RLMArray 这个集合里面存储的属性必须继承自 RLMObject 类型的属性
@property RLMArray<Dog *><Dog> *pets;

@end

RLM_ARRAY_TYPE(Person)

