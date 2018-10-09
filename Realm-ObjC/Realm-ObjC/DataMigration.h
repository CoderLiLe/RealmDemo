//
//  DataMigration.h
//  Realm-ObjC
//
//  Created by LiLe on 2018/10/9.
//Copyright © 2018年 LiLe. All rights reserved.
//

#import <Realm/Realm.h>

@interface DataMigration : RLMObject

@property int aa;
@property int b;
@property int c;
@property int sum;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<DataMigration *><DataMigration>
RLM_ARRAY_TYPE(DataMigration)
