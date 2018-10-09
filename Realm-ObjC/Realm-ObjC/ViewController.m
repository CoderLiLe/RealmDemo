//
//  ViewController.m
//  Realm-ObjC
//
//  Created by LiLe on 2018/9/30.
//  Copyright © 2018年 LiLe. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Stu.h"
#import "DataType.h"
#import "DataMigration.h"

@interface ViewController ()

@property RLMNotificationToken *token;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self databaseMigration];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    self.token = [realm addNotificationBlock:^(RLMNotification  _Nonnull notification, RLMRealm * _Nonnull realm) {
        NSLog(@"接收到变更通知 -- %@", notification);
    }];
    
}

- (IBAction)saveModel {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    Dog *dog1 = [Dog new];
    dog1.num = 1;
    dog1.name = @"aaa";
    
    Dog *dog2 = [Dog new];
    dog2.num = 2;
    dog2.name = @"bbb";
    
    [realm transactionWithBlock:^{
        for (int i = 0; i < 10; i++) {
            Person *person = [[Person alloc] init];
            person.personId = [NSString stringWithFormat:@"%d", i];
            person.sex = (i % 2 == 0 ? @"woman" : @"man");
            person.status = YES;
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"jpeg"];
            person.imageData = [NSData dataWithContentsOfFile:filePath];
            
            [person.pets addObject:dog1];
            [person.pets addObject:dog2];
            
            [realm addObject:person];
        }
    }];
    
    [realm transactionWithBlock:^{
        for (int j = 0; j < 10; j++) {
            Stu *stu = [[Stu alloc] init];
            stu.num = j;
            stu.name = [NSString stringWithFormat:@"%d", arc4random() % 100];
            [realm addObject:stu];
        }
    }];
    
    DataMigration *dataMigration = [[DataMigration alloc] initWithValue:@{@"a": @1, @"b":@2, @"c":@3, @"sum": @0}];
    [realm beginWriteTransaction];
    [realm addObject:dataMigration];
    [realm commitWriteTransaction];
    
    [realm transactionWithBlock:^{
        [DataMigration createInRealm:realm withValue:@{@"a": @10, @"b":@20, @"c":@30, @"sum": @0}];
    }];
}

- (IBAction)updateModel {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
#if 0
    // 此stu模型已经被 realm 所管理，已经和磁盘上的对象进行了地址映射
    Stu *stu = [[Stu alloc] initWithValue:@[@1, @"乐乐乐乐"]];
    
    [realm transactionWithBlock:^{
        [realm addObject:stu];
    }];
    
    // 这里修改的模型，一定是被 realm 所管理的模型
    [realm transactionWithBlock:^{
        stu.name = @"明天你好，乐乐乐乐";
    }];
    
    RLMResults *results = [Stu objectsWhere:@"name = '明天你好，乐乐乐乐'"];
    Stu *stu1 = results.firstObject;
    [realm transactionWithBlock:^{
        stu1.name = @"乐乐";
    }];
    
#elif 1
    Stu *stu2 = [[Stu alloc] initWithValue:@[@2, @"乐乐"]];
    [realm transactionWithBlock:^{
        [realm addOrUpdateObject:stu2];
    }];
    [realm transactionWithBlock:^{
        [Stu createOrUpdateInRealm:realm withValue:@[@2, @"乐哥"]];
    }];
    
#else
    
#endif
    
}

- (IBAction)deleteModel {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
#if 0
    // *** Terminating app due to uncaught exception 'RLMException', reason: 'Can only delete an object from the Realm it belongs to.'
    // 删除的模型，一定要求是被 realm 所管理的
    Stu *stu = [[Stu alloc] initWithValue:@[@3, @"李乐乐乐"]];
    [realm transactionWithBlock:^{
        [realm deleteObject:stu];
    }];
#elif 0
    RLMResults *results = [Stu objectsWhere:@"name = '乐乐'"];
    Stu *stu = results.firstObject;
    [realm transactionWithBlock:^{
        [realm deleteObject:stu];
    }];

#else
    [realm transactionWithBlock:^{
        [realm deleteAllObjects];
    }];

#endif
    
}

- (IBAction)deleteSpecal {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
#if 0
    // 场景：删除某一特定类型的所有模型
    RLMResults *stuRes = [Stu allObjects];
    for (Stu *stu in stuRes) {
        [realm transactionWithBlock:^{
            [realm deleteObject:stu];
        }];
    }
#else
    // 场景：根据主键删除一个模型
    // 1. 根据主键，查询到这个模型（这个模型，就是被realm数据库管理的模型）
    Stu *stuDel = [Stu objectInRealm:realm forPrimaryKey:@2];
    // 2. 删除该模型
    [realm transactionWithBlock:^{
        [realm deleteObject:stuDel];
    }];
#endif
    
}

- (IBAction)queryModel {
    
    // 所有的查询（包括查询和属性的访问）在realm中都是延迟加载的，只有当属性被访问时，才能够读取响应的数据
    RLMResults *stuRes = [Stu allObjects];
    NSLog(@"before = %@", stuRes);
    
    Stu *stu = [[Stu alloc] initWithValue:@[@11, @"土豆"]];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:stu];
    }];
    
     NSLog(@"after = %@", stuRes);
    
    Person *firstPerson = [Person allObjects].firstObject;
    NSLog(@"firstPerson.pets.firstObject.master = %@", firstPerson.pets.firstObject.master);
}

- (IBAction)conditionQuery {
    RLMResults<Stu *> *stus = [Stu objectsWhere:@"num > 1"];
    NSLog(@"stus = %@", stus);
    
    RLMResults *sortRes = [stus sortedResultsUsingKeyPath:@"name" ascending:NO];
    NSLog(@"sortRes = %@", sortRes);
    
    RLMResults *subRes = [[stus objectsWhere:@"num > 2"] objectsWhere:@"num > 3"];
    NSLog(@"subRes = %@", subRes);
    
    RLMResults *allObj = [Stu allObjects];
    NSMutableArray *rangeStus = [NSMutableArray array];
    for (int i = 2; i <= 5; i++) {
        Stu *stu = allObj[i];
        [rangeStus addObject:stu];
    }
    NSLog(@"rangeStus = %@", rangeStus);
}

- (IBAction)dataType {
    
    DataType *dataType = [[DataType alloc] init];
    dataType.B1 = YES;
    dataType.b2 = false;
    dataType.i = 10;
    dataType.ite = 22;
    dataType.l = 33;
    dataType.ll = 44;
    dataType.f = 22.2;
    dataType.d = 33.33;
    dataType.str = @"XXX";
    dataType.date = [NSDate date];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"jpeg"];
    dataType.data = [NSData dataWithContentsOfFile:filePath];
    dataType.num = @2;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:dataType];
    }];
    
    RLMResults *res = [DataType allObjects];
    
    for (DataType *dataType in res) {
        NSLog(@"%@", dataType);
    }
}

- (IBAction)notice {
    Stu *stu = [[Stu alloc] initWithValue:@{@"num" : @1, @"name" : @"bbb"}];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    RLMResults *res = [Stu allObjects];
    self.token = [res addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        NSLog(@"%@ -- %@", change, results);
    }];
    
    [realm transactionWithBlock:^{
        [realm addObject:stu];
    }];
    
    [realm transactionWithBlock:^{
        [realm deleteObject:stu];
    }];
}

#pragma mark - 数据库机制

// 不同的用户，使用不同的数据库

- (IBAction)zhangSann {
    [self setDefaultRealmForUserName:@"zhangsan"];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    Stu *zhangsan = [[Stu alloc] initWithValue:@{@"num":@123, @"name":@"zhangsan"}];
    [realm transactionWithBlock:^{
        [realm addObject:zhangsan];
    }];
}

- (IBAction)liSi {
    [self setDefaultRealmForUserName:@"lisi"];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    Stu *lisi = [[Stu alloc] initWithValue:@{@"num":@123, @"name":@"lisi"}];
    [realm transactionWithBlock:^{
        [realm addObject:lisi];
    }];
}

- (IBAction)onlyRead {
    [self setDefaultRealmForUserName:@"zhangsan"];
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // 将这个配置应用到默认的 Realm 数据库当中
    config.readOnly = YES;
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    // reason: 'Can't perform transactions on read-only Realms.'
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    Stu *zhangsan = [[Stu alloc] initWithValue:@{@"num":@123, @"name":@"lisi"}];
//    [realm transactionWithBlock:^{
//        [realm addObject:zhangsan];
//    }];
    
    RLMResults *res = [Stu allObjects];
    for (Stu *stu in res) {
        NSLog(@"%@", stu);
    }
}

- (IBAction)userDelete {
    [self setDefaultRealmForUserName:@"zhangsan"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    NSArray<NSURL *> *realmFileURLs = @[config.fileURL,
                                        [config.fileURL URLByAppendingPathExtension:@"lock"],
                                        [config.fileURL URLByAppendingPathExtension:@"log_a"],
                                        [config.fileURL URLByAppendingPathExtension:@"log_b"],
                                        [config.fileURL URLByAppendingPathExtension:@"note"],
                                        [config.fileURL URLByAppendingPathExtension:@"management"]
                                        ];
    for (NSURL *URL in realmFileURLs) {
        NSError *error = nil;
        [fileManager removeItemAtURL:URL error:&error];
        if (error) {
            // handle error
        }
    }
}

- (void)setDefaultRealmForUserName:(NSString *)username
{
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // 使用默认的目录，但是使用用户名来替换默认的文件名
    config.fileURL = [[[config.fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:username] URLByAppendingPathExtension:@"realm"];
    // 将这个配置应用到默认的 Realm 数据库中
    [RLMRealmConfiguration setDefaultConfiguration:config];
}

- (void)databaseMigration {
    // 迁移数据结构、升级数据库
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // 1、升级一个版本
    int newVersion = 2;
    config.schemaVersion = newVersion;
    // 2、设置迁移block
    [config setMigrationBlock:^(RLMMigration * _Nonnull migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < newVersion) {
            NSLog(@"数据结构会自动迁移");
            [migration renamePropertyForClass:DataMigration.className oldName:@"a" newName:@"aa"];
            
            [migration enumerateObjects:DataMigration.className block:^(RLMObject * _Nullable oldObject, RLMObject * _Nullable newObject) {
                newObject[@"sum"] = @([oldObject[@"a"] integerValue] + [oldObject[@"b"] integerValue] + [oldObject[@"c"] integerValue]);
            }];
        }
    }];
    // 3、重新设置默认配置
    [RLMRealmConfiguration setDefaultConfiguration:config];
    // 4、立即生效
    [RLMRealm defaultRealm];
}

@end
