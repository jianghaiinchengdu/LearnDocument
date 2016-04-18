//
//  KVOtest.m
//  KVCDemo
//
//  Created by jianghai on 16/1/20.
//  Copyright © 2016年 jianghai. All rights reserved.
//

#import "KVOtest.h"

@interface KVOtest()
{
    NSMutableArray* _pro;
}
@end

@implementation KVOtest

@dynamic array2;
@synthesize array1 = _array1;

-(instancetype)init{
    self = [super init];
    if (self) {
        _array1 = [NSMutableArray arrayWithObjects:@(1),@(2), nil];
        _pro = [NSMutableArray arrayWithObjects:@(1),@(2), nil];
    }
    return self;
}
-(void)setArray1:(NSMutableArray *)array1{
    _array1 = array1;
}
-(NSMutableArray *)array1{
    return _array1;
}



-(void)setArray2:(NSMutableArray *)array2{
    _pro = array2;
}

//-(NSUInteger)countOfArray2{
//    NSLog(@"%s",__func__);
//   return  _pro.count;
//}
//-(id)objectInArray2AtIndex:(NSUInteger)index{
//    
//    NSLog(@"%s",__func__);
//    return [_pro objectAtIndex:index];
//}
-(void)insertObject:(NSObject *)object inArray2AtIndex:(NSUInteger)index{
    
    NSLog(@"%s",__func__);
    [_pro insertObject:object atIndex:index];
}
-(void)removeObjectFromArray2AtIndex:(NSUInteger)index{
    
    NSLog(@"%s",__func__);
    [_pro removeObjectAtIndex:index];
}

@end
