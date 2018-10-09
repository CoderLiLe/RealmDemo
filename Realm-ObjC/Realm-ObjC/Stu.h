//
//  Stu.h
//  Realm-ObjC
//
//  Created by LiLe on 2018/10/9.
//Copyright © 2018年 LiLe. All rights reserved.
//

#import <Realm/Realm.h>

@interface Stu : RLMObject

@property int num;
@property NSString *name;
@property NSString *love;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Stu *><Stu>
RLM_ARRAY_TYPE(Stu)
