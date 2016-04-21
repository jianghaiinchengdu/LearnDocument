//
//  ApplePayManager.m
//  ApplePayDemo
//
//  Created by jianghai on 16/4/20.
//  Copyright © 2016年 jianghai. All rights reserved.
//

#import "ApplePayManager.h"
#import "UPAPayPlugin.h"

@interface ApplePayManager()<PKPaymentAuthorizationViewControllerDelegate , UPAPayPluginDelegate>
@property (nullable ,nonatomic , strong)NSMutableArray *summaryItems;
@property (nullable ,nonatomic , strong)NSMutableArray <PKShippingMethod *> *shipingMethod;
@property (nonnull ,nonatomic , strong)NSArray *supportedNetworks;
@end

@implementation ApplePayManager

+(ApplePayManager *)sharedManager {
    static dispatch_once_t onceToken;
    static ApplePayManager* _instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[ApplePayManager alloc] init];
        _instance.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa];
    });
    return _instance;
}

-(void)presentPayVCFrom:(UIViewController *)target withOrdersInfo:(NSArray<NSObject<PaymentSummaryData> *> *)orders {
    
    if ([self canBeginPayProcess]) {
        PKPaymentRequest *paymentRequest = [self createRequestWithOrders:orders];
        PKPaymentAuthorizationViewController *view = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:paymentRequest];
        view.delegate = self;
        [target presentViewController:view animated:YES completion:nil];
    }
}

-(BOOL)presentUPAPayVC:(UIViewController *)target withOrdersInfo:(NSArray<NSObject<PaymentSummaryData> *> *)order {
    NSString* payInfo = @"201511181055564938258";//这个地方将订单发送至自己的服务器，生成订单支付信息
    return [UPAPayPlugin startPay:payInfo mode:@"01" viewController:target delegate:self andAPMechantID:@"merchant.com.mll.mllcustomer"];
}

-(BOOL)canBeginPayProcess {
    
    if(![PKPaymentAuthorizationViewController class]){
        return NO;
    }
    if (![PKPaymentAuthorizationViewController canMakePayments]) {
        return NO;
    }
    
    /**
     *  检查用户是否可进行某种卡的支付，是否支持Amex、
     *  MasterCard、Visa与银联四种卡，根据自己项目的
     *  需 要进行检测，返回NO代表所有类型的卡都不支持
     */
    if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:self.supportedNetworks]) {
        NSLog(@"没有绑定支付卡");
        return NO;
    }
    return YES;
}

-(PKPaymentRequest *)createRequestWithOrders:(NSArray<NSObject<PaymentSummaryData> *> *)orders {
    
    PKPaymentRequest *paymentRequest = [[PKPaymentRequest alloc] init];
    paymentRequest.countryCode = @"CN";//国家代码
    paymentRequest.currencyCode = @"CNY";//货币代码
    paymentRequest.merchantIdentifier = @"merchant.com.mll.mllcustomer";//后台申请的商人ID
    paymentRequest.supportedNetworks = self.supportedNetworks;
    paymentRequest.merchantCapabilities = PKMerchantCapability3DS|PKMerchantCapabilityEMV;//交易的处理协议
    
    paymentRequest.requiredBillingAddressFields = PKAddressFieldAll;
    //如果需要邮寄账单可以选择进行设置，默认PKAddressFieldNone(不邮寄账单)
    //楼主感觉账单邮寄地址可以事先让用户选择是否需要，否则会增加客户的输入麻烦度，体验不好，
    paymentRequest.requiredShippingAddressFields = PKAddressFieldAll;
    //送货地址信息，这里设置需要地址和联系方式和姓名，如果需要进行设置，默认PKAddressFieldNone(没有送货地址)
    
    
    //设置配送方式
    PKShippingMethod *shipingOne = [PKShippingMethod summaryItemWithLabel:@"包邮" amount:[NSDecimalNumber zero]];
    shipingOne.identifier = @"shipingOne";
    shipingOne.detail = @"免费送货,但是速度超慢";
    PKShippingMethod *shipingTwo = [PKShippingMethod summaryItemWithLabel:@"包邮" amount:[NSDecimalNumber decimalNumberWithMantissa:1000 exponent:-2 isNegative:NO]];
    shipingTwo.identifier = @"shipingOne";
    shipingTwo.detail = @"免费送货,但是速度超慢";
    self.shipingMethod = (NSMutableArray <PKShippingMethod *>*)(@[shipingOne,shipingTwo]);
    paymentRequest.shippingMethods = self.shipingMethod;
    
    
    NSDecimalNumber *priceOne = [NSDecimalNumber decimalNumberWithMantissa:123456 exponent:-2 isNegative:NO];
    PKPaymentSummaryItem *item1 = [PKPaymentSummaryItem summaryItemWithLabel:@"item1价格" amount:priceOne];
    
    NSDecimalNumber *priceTwo = [NSDecimalNumber decimalNumberWithMantissa:123456 exponent:-4 isNegative:YES];
    PKPaymentSummaryItem *item2 = [PKPaymentSummaryItem summaryItemWithLabel:@"item2价格" amount:priceTwo];
    
    NSDecimalNumber *price1= [NSDecimalNumber decimalNumberWithMantissa:345345 exponent:-1 isNegative:NO];
    PKPaymentSummaryItem *item3 = [PKPaymentSummaryItem summaryItemWithLabel:@"XXXXX" amount:price1];
    
    NSDecimalNumber *price2= [NSDecimalNumber decimalNumberWithMantissa:345345 exponent:-2 isNegative:NO];
    PKPaymentSummaryItem *item4 = [PKPaymentSummaryItem summaryItemWithLabel:@"WWWW价格" amount:price2];
    
    
    NSDecimalNumber *totalPrice = [NSDecimalNumber zero];
    totalPrice = [totalPrice decimalNumberByAdding:priceOne];
    totalPrice = [totalPrice decimalNumberByAdding:priceTwo];
    totalPrice = [totalPrice decimalNumberByAdding:price1];
    totalPrice = [totalPrice decimalNumberByAdding:price2];
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"蒋海" amount:totalPrice];//最后这个是支付给谁。哈哈，快支付给我
    
    self.summaryItems = [NSMutableArray arrayWithObjects:item1,item2,item3,item4,total, nil];
    //summaryItems为账单列表，类型是 NSMutableArray，这里设置成成员变量，在后续的代理回调中可以进行支付金额的调整。
    paymentRequest.paymentSummaryItems = self.summaryItems;
    
    return paymentRequest;
}

#pragma mark
#pragma mark UPAPayPluginDelegate

-(void) UPAPayPluginResult:(UPPayResult *) payResult {
    NSLog(@"sdfdsfsdfdsf");
}

#pragma mark
#pragma mark PKPaymentAuthorizationViewControllerDelegate

// Sent to the delegate after the user has acted on the payment request.  The application
// should inspect the payment to determine whether the payment request was authorized.
//
// If the application requested a shipping address then the full addresses is now part of the payment.
//
// The delegate must call completion with an appropriate authorization status, as may be determined
// by submitting the payment credential to a processing gateway for payment authorization.
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion {
    NSLog(@"%s",__func__);
    completion(PKPaymentAuthorizationStatusSuccess);
}


// Sent to the delegate when payment authorization is finished.  This may occur when
// the user cancels the request, or after the PKPaymentAuthorizationStatus parameter of the
// paymentAuthorizationViewController:didAuthorizePayment:completion: has been shown to the user.
//
// The delegate is responsible for dismissing the view controller in this method.
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    NSLog(@"%s",__func__);
    [controller dismissViewControllerAnimated:YES completion:^{
        self.summaryItems = nil;
        self.shipingMethod = nil;
    }];
}


// Sent to the delegate before the payment is authorized, but after the user has authenticated using
// passcode or Touch ID. Optional.
- (void)paymentAuthorizationViewControllerWillAuthorizePayment:(PKPaymentAuthorizationViewController *)controller {
    NSLog(@"%s",__func__);
    
}


// Sent when the user has selected a new shipping method.  The delegate should determine
// shipping costs based on the shipping method and either the shipping address supplied in the original
// PKPaymentRequest or the address fragment provided by the last call to paymentAuthorizationViewController:
// didSelectShippingAddress:completion:.
//
// The delegate must invoke the completion block with an updated array of PKPaymentSummaryItem objects.
//
// The delegate will receive no further callbacks except paymentAuthorizationViewControllerDidFinish:
// until it has invoked the completion block.
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus status, NSArray<PKPaymentSummaryItem *> *summaryItems))completion{
    NSLog(@"%s",__func__);
    
    [controller.navigationController popViewControllerAnimated:YES];
    
    completion(PKPaymentAuthorizationStatusSuccess,self.summaryItems);
}

// Sent when the user has selected a new shipping address.  The delegate should inspect the
// address and must invoke the completion block with an updated array of PKPaymentSummaryItem objects.
//
// The delegate will receive no further callbacks except paymentAuthorizationViewControllerDidFinish:
// until it has invoked the completion block.
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                  didSelectShippingAddress:(ABRecordRef)address
                                completion:(void (^)(PKPaymentAuthorizationStatus status, NSArray<PKShippingMethod *> *shippingMethods,
                                                     NSArray<PKPaymentSummaryItem *> *summaryItems))completion //NS_DEPRECATED_IOS(8_0, 9_0, "Use the CNContact backed delegate method instead");
{
    NSLog(@"%s",__func__);
    completion(PKPaymentAuthorizationStatusSuccess, self.shipingMethod,self.summaryItems);
}


- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                  didSelectShippingContact:(PKContact *)contact
                                completion:(void (^)(PKPaymentAuthorizationStatus status, NSArray<PKShippingMethod *> *shippingMethods,
                                                     NSArray<PKPaymentSummaryItem *> *summaryItems))completion {
    NSLog(@"%s",__func__);
    completion(PKPaymentAuthorizationStatusSuccess, self.shipingMethod,self.summaryItems);
}


// Sent when the user has selected a new payment card.  Use this delegate callback if you need to
// update the summary items in response to the card type changing (for example, applying credit card surcharges)
//
// The delegate will receive no further callbacks except paymentAuthorizationViewControllerDidFinish:
// until it has invoked the completion block.
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                    didSelectPaymentMethod:(PKPaymentMethod *)paymentMethod
                                completion:(void (^)(NSArray<PKPaymentSummaryItem *> *summaryItems))completion {
    NSLog(@"%s",__func__);
    completion(self.summaryItems);
}


@end
