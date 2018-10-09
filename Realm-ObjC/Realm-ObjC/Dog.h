//
//  Dog.h
//  Realm-ObjC
//
//  Created by LiLe on 2018/9/30.
//Copyright © 2018年 LiLe. All rights reserved.
//

#import <Realm/Realm.h>

@interface Dog : RLMObject

@property int num;
@property NSString *name;
@property (readonly) RLMLinkingObjects *master;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Dog *><Dog>
RLM_ARRAY_TYPE(Dog)
