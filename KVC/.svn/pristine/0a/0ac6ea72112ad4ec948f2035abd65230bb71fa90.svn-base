//
//  CustomModel.m
//  KVCDemo
//
//  Created by jianghai on 15/10/21.
//  Copyright © 2015年 jianghai. All rights reserved.
//

#import "CustomModel.h"

@implementation BaseClass
@end

@interface CustomModel()
{
    NSArray* _userList;
    NSMutableArray* _wholeArray2;
}
@end

@implementation CustomModel
//@dynamic userList;
@dynamic wholeArray2;
-(instancetype)init{
    self = [super init];
    if (self) {
        _wholeArray1 = [NSMutableArray arrayWithObjects:@(1),@(2), nil];
        _wholeArray2 = [NSMutableArray arrayWithObjects:@(1),@(2), nil];
    }
    return self;
}
-(void)setNilValueForKey:(NSString *)key
{
    NSLog(@"setNilValueForKey:%@",key);
    if([key isEqualToString:@"hidden"])
        _hidden = NO;
}
-(BOOL)hidden
{
    NSLog(@"%s",__func__);
    return _hidden;
}
-(BOOL)isHidden
{
    NSLog(@"%s",__func__);
    return _hidden;
}
-(BOOL)validateCount:(id*)inValue error:(out NSError * _Nullable __autoreleasing *)outError
{
    NSLog(@"%s",__func__);
    if(*inValue == nil)
        return YES;
    
    if([*inValue floatValue] < 3){
        
        NSNumber* num = [NSNumber numberWithFloat:1];
        if(num){
            *inValue = num;
            return YES;
        }
        if(outError != NULL){
            NSString* errorStr = @"errooooo";
            NSDictionary* userinfo = @{NSLocalizedDescriptionKey:errorStr};
            NSError* err = [[NSError alloc] initWithDomain:@"PERSON_ERROR_DOMAIN" code:1 userInfo:userinfo];
            *outError = err;
        }
        return NO;
    }
    return YES;
}

#pragma mark 有序集合
-(void)setUserList:(NSArray<BaseClass *> *)userList
{
    NSLog(@"%s",__func__);
    _userList = userList;
}
-(NSUInteger)countOfUserList
{
    NSLog(@"%s",__func__);
    return _userList.count;
}
-(id)objectInUserListAtIndex:(NSUInteger)index
{
    NSLog(@"%s",__func__);
    return [_userList objectAtIndex:index];
}

-(NSMutableArray *)mutableArrayValueForKey:(NSString *)key{
    return _wholeArray2;
}
-(void)insertObject:(NSObject*)object inWholeArray2AtIndex:(NSUInteger)index{
    [_wholeArray2 insertObject:object atIndex:index];
}
-(void)removeObjectFromWholeArray2AtIndex:(NSUInteger)index{
    [_wholeArray2 removeObjectAtIndex:index];
}

//-(NSMutableArray *)mutableArrayValueForKey:(NSString *)key
//{
//    return nil;
//}
//-(NSMutableArray *)mutableArrayValueForKeyPath:(NSString *)keyPath
//{
//    return nil;
//}

@end
