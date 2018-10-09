//
//  DataType.h
//  Realm-ObjC
//
//  Created by LiLe on 2018/10/9.
//Copyright © 2018年 LiLe. All rights reserved.
//

#import <Realm/Realm.h>

@interface DataType : RLMObject

// BOOL, bool, int, NSInteger, long, long long, float, double, NSString, NSDate, NSData, NSNumber
@property BOOL B1;
@property bool b2;
@property int i;
@property NSInteger ite;
@property long l;
@property long long ll;
@property float f;
@property double d;
@property NSString *str;
@property NSDate *date;
@property NSData *data;
@property NSNumber<RLMFloat> *num;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<DataType *><DataType>
RLM_ARRAY_TYPE(DataType)
