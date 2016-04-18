//
//  ViewController.m
//  KVCDemo
//
//  Created by jianghai on 15/10/21.
//  Copyright © 2015年 jianghai. All rights reserved.
//

#import "ViewController.h"
#import "CustomModel.h"
#import "TestModel.h"
#import "KVOtest.h"

@interface ViewController ()
@property (nonatomic,strong)KVOtest* modelK;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testKVO];
    NSMutableArray* arr = [NSMutableArray array];
    for (int i = 0; i != 10; i++) {
        BaseClass* aClass1 = [[BaseClass alloc] init];
        aClass1.classID = [NSString stringWithFormat:@"this is Base Class %d",i/2];
        aClass1.valueCount = 45;
        [arr addObject:aClass1];
    }
    
    CustomModel* model = [[CustomModel alloc] init];
    [model setValue:arr forKey:@"userList"];
    NSMutableArray* arr1 = [model valueForKey:@"wholeArray1"];
    NSMutableArray* arr2 = [model mutableArrayValueForKey:@"wholeArray2"];

    [model addObserver:self forKeyPath:@"wholeArray2" options:NSKeyValueObservingOptionNew context:nil];
    [model addObserver:self forKeyPath:@"wholeArray1" options:NSKeyValueObservingOptionNew context:nil];
    
    
    [arr1 addObject:@(3)];
    [arr2 addObject:@(3)];
    
    
//    [model setValue:nil forKey:@"aClass"];
//    [model setValue:nil forKey:@"count"];
    
    
    NSNumber* num = [NSNumber numberWithFloat:2];
    NSError* err;
    
    [model validateValue:&num forKey:@"count" error:&err];//默认实现会调用-(BOOL)validate<Key>:error:方法
    [model setValue:num forKey:@"count"];
    [model setValue:0 forKey:@"hidden"];
    [model setValue:num forKey:@"aClass"];
//    [model setValue:num forKey:@"wholeArray"];
//    [model setValue:num forKey:@"userList"];
    
    
    //点语法
    NSMutableArray* aa = [model valueForKey:@"userList"];
    NSLog(@"%@",[aa lastObject]);
    
    TestModel *collectionData = [[TestModel alloc] init];
    NSLog(@"The last prime is %@", [collectionData.numbers lastObject]);
//    NSArray* s = [primes valueForKey:@"primes"];
//    NSLog(@"The last prime is %@", [s lastObject]);
}



-(void)testKVO{
    _modelK = [[KVOtest alloc] init];
    [_modelK addObserver:self forKeyPath:@"array1" options:NSKeyValueObservingOptionNew context:nil];
    [_modelK addObserver:self forKeyPath:@"array2" options:NSKeyValueObservingOptionNew context:nil];
    
    NSMutableArray* arr1 = [_modelK valueForKey:@"array1"];
    NSMutableArray* arr2 = [_modelK mutableArrayValueForKey:@"array2"];
    
    
    [arr2 addObject:@(1)];
    [arr2 removeObjectAtIndex:0];

}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"change");
}
//+(CustomModel*)testModel
//{
//    CustomModel* model = [[CustomModel alloc] init];
//    model.hidden = NO;
//    model.count = 100;
//    BaseClass* aClass = [[BaseClass alloc] init];
//    aClass.classID = @"this is Base Class";
//    aClass.valueCount = 11;
//    model.aClass = aClass;
//    model.userList = [NSMutableArray array];
//    for (int i = 0; i != 10; i++) {
//        BaseClass* aClass1 = [[BaseClass alloc] init];
//        aClass1.classID = [NSString stringWithFormat:@"this is Base Class %d",i/2];
//        aClass1.valueCount = 45;
//        [model.userList addObject:aClass1];
//    }
//    model.wholeArray = [NSMutableArray array];
//    for (int i = 0; i != 5; i++) {
//        [model.wholeArray addObject:model.userList];
//    }
//    return model;
//}
@end
