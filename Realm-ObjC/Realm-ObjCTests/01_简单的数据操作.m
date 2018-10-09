//
//  01_简单的数据操作.m
//  Realm-ObjCTests
//
//  Created by LiLe on 2018/9/30.
//  Copyright © 2018年 LiLe. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"

@interface ModelOperation : XCTestCase

@end

@implementation ModelOperation

- (void)testSaveModel {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        for (int i = 0; i < 100; i++) {
            Person *person = [[Person alloc] init];
            person.personId = [NSString stringWithFormat:@"%d", i];
            person.sex = (i % 2 == 0 ? @"woman" : @"man");
            person.status = YES;
            [realm addObject:person];
        }
    }];
}
@end
