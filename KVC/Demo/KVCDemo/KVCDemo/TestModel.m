//
//  TestModel.m
//  KVCDemo
//
//  Created by jianghai on 15/10/29.
//  Copyright © 2015年 jianghai. All rights reserved.
//

#import "TestModel.h"
@implementation TestModel
{
    NSArray* _numbersProxy;
}
-(instancetype)init
{
    if(self = [super init]){
        _numbersProxy = [NSArray arrayWithObjects:@(2),@(3),@(4),@(12),@(13),@(14),@(22),@(23),@(24), nil];
    }
    return self;
}
-(NSArray *)numbers
{
    return [self valueForKey:@"numbersProxy"];
}

-(NSUInteger)countOfNumbersProxy
{
    return [_numbersProxy count];
}
-(id)objectInNumbersProxyAtIndex:(NSUInteger)index
{
    return _numbersProxy[index];
}
-(void)getNumbers:(id **)buffer range:(NSRange)inRange
{
    **buffer = [_numbersProxy subarrayWithRange:inRange];
}
@end
