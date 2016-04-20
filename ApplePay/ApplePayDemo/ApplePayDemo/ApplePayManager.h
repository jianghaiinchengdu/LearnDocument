//
//  ApplePayManager.h
//  ApplePayDemo
//
//  Created by jianghai on 16/4/20.
//  Copyright © 2016年 jianghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>
#import <AddressBook/AddressBook.h>

@protocol PaymentSummaryData<NSObject>

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSDecimalNumber *amount;
@property (nonatomic, assign) PKPaymentSummaryItemType type;
@end

@interface ApplePayManager : NSObject

+(ApplePayManager *)sharedManager;

-(void)presentPayVCFrom:(UIViewController *)target withOrdersInfo:(NSArray<NSObject<PaymentSummaryData> *> *)order;

@end
