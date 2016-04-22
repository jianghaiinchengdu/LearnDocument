//
//  ApplePayManager.m
//  ApplePayDemo
//
//  Created by jianghai on 16/4/20.
//  Copyright © 2016年 jianghai. All rights reserved.
//

#import "ApplePayManager.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UPAPayPlugin.h"
#import <PassKit/PassKit.h>

@interface ApplePayManager()<PKPaymentAuthorizationViewControllerDelegate , UPAPayPluginDelegate ,NSURLSessionDataDelegate>
@property (nullable ,nonatomic , strong)NSMutableArray *summaryItems;
@property (nullable ,nonatomic , strong)NSMutableArray <PKShippingMethod *> *shipingMethod;
@property (nonnull ,nonatomic , strong)NSArray *supportedNetworks;
@property (nonatomic , strong)NSOperationQueue *queue;
@end

@implementation ApplePayManager

-(NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

+(ApplePayManager *)sharedManager {
    static dispatch_once_t onceToken;
    static ApplePayManager* _instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[ApplePayManager alloc] init];
        _instance.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
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

-(void)presentUPAPayVC:(UIViewController *)target withOrdersInfo:(NSArray<NSObject<PaymentSummaryData> *> *)order {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://101.231.204.84:8091/sim/getacptn"]] queue:self.queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
         NSString* payInfo = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];//这个地方将订单发送至自己的服务器，生成订单支付信息
        [UPAPayPlugin startPay:payInfo mode:@"01" viewController:target delegate:self andAPMechantID:@"merchant.com.mll.mllcustomer"];
    }];
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
    
    
    NSDecimalNumber *priceOne = [NSDecimalNumber decimalNumberWithMantissa:1000 exponent:-2 isNegative:NO];
    PKPaymentSummaryItem *item1 = [PKPaymentSummaryItem summaryItemWithLabel:@"item1价格" amount:priceOne];
    
    NSDecimalNumber *priceTwo = [NSDecimalNumber decimalNumberWithMantissa:2000 exponent:-2 isNegative:YES];
    PKPaymentSummaryItem *item2 = [PKPaymentSummaryItem summaryItemWithLabel:@"item2价格" amount:priceTwo];
    
    NSDecimalNumber *price1= [NSDecimalNumber decimalNumberWithMantissa:3000 exponent:-2 isNegative:NO];
    PKPaymentSummaryItem *item3 = [PKPaymentSummaryItem summaryItemWithLabel:@"XXXXX" amount:price1];
    
    NSDecimalNumber *price2= [NSDecimalNumber decimalNumberWithMantissa:4000 exponent:-1 isNegative:NO];
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

//银联支付回调
-(void) UPAPayPluginResult:(UPPayResult *) payResult {
    NSLog(@"sdfdsfsdfdsf");
}

#pragma mark
#pragma mark PKPaymentAuthorizationViewControllerDelegate
/**
 *  告诉代理用户已经授权该支付请求。delegate应当检查这个payment是否被授权。
    当授权支付请求之后调用该方法，提交支付信息给支付进程授权该交易，并回调完成的Block。
 *
 *  @param controller 支付授权视图控制器
 *  @param payment 授权的支付。该对象不仅包含需要提交给支付处理器的支付密钥，还包含支付请求需要的账单和运送信息。
 *  @param completion 当app授权支付之后回调完成的Block。该Block取下面的参数：status 支付的授权状态。
 */

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion {
    completion(PKPaymentAuthorizationStatusSuccess);
}

/**
 *使用该方法dismiss支付授权视图控制器，更新其他的app状态。当用户授权一个支付请求时，当paymentAuthorizationViewController:didAuthorizePayment:completion:方法的完成Block已经展示给用户
 ，该方法被调用。当用户没有授权支付请求引起取消操作时，仅仅paymentAuthorizationViewControllerDidFinish:被调用。

 @param controller 支付授权视图控制器。
 */
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    NSLog(@"%s",__func__);
    [controller dismissViewControllerAnimated:YES completion:^{
        self.summaryItems = nil;
        self.shipingMethod = nil;
    }];
    controller = nil;
}

/**
 *  在用户使用密码或者指纹授权通过之后，但是在支付授权之前被调用
 *  @param controller     支付授权视图控制器
 */
- (void)paymentAuthorizationViewControllerWillAuthorizePayment:(PKPaymentAuthorizationViewController *)controller {
    NSLog(@"%s",__func__);
    
}

/**
 *  当用户选择一个新的运送方式的时候触发。使用该方法更新基于用户选择的运送地址产生的运送费用，该运送地址为先前在
    paymentAuthorizationViewController:didSelectShippingAddress:completion:方法中传送给代理的。如果没有选择
    地址，使用在支付请求中预填充的地址。当该方法被调用时，创建一个新的PKPaymentSummaryItem对象的数组，展示包括运
    费的更新后的费用。
 *
 *  @param controller     支付授权视图控制器
 *  @param shippingMethod 选择的运送方式。该参数包含支付方式的一种，包含在支付请求中。
 *  @param completion     更新运送方式信息时该完成Block被调用。该Block包含下面的参数：
                          * status 支付的授权状态。
                          * summaryItems PKPaymentSummaryItems对象的数组，用以替换当前支付请求的概要项。
 */
//这个方法不会在此被触发,除非支付授权完成或者它调用了自己completion block

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus status, NSArray<PKPaymentSummaryItem *> *summaryItems))completion{
    for (PKPaymentSummaryItem *item in self.summaryItems) {
        item.amount = [item.amount decimalNumberByAdding:[NSDecimalNumber decimalNumberWithMantissa:3000 exponent:-1 isNegative:NO]];
    }
    completion(PKPaymentAuthorizationStatusSuccess,self.summaryItems);
}

/**
 *  使用该方法更新适用的运送方式和如果选中一种运送方式相应的当前的运费。当该方法被调用时，创建一个指定地址
 适用的PKShippingMethod对象的新数组。也可以创建一个显示更新后的费用的PKPaymentSummaryItem对象的数组。概
 要项应该包含选中的适用的运送方式的运费。
 *
 *  @param controller 支付授权视图控制器
 *  @param contact    展示新的运送地址的联系对象。
 *  @param completion 更新运送信息时完成Block被调用。该Block包含下面的参数：
 
                * staus 支付的授权状态。
                * shippingMethods 一个 PKShippingMethod对象的数组，用以替代当前支付请求的运送方式。
                * summaryItems PKPaymentSummaryItems对象的数组，用以替换当前支付请求的概要项。
 */

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                  didSelectShippingContact:(PKContact *)contact
                                completion:(void (^)(PKPaymentAuthorizationStatus status, NSArray<PKShippingMethod *> *shippingMethods,
                                                     NSArray<PKPaymentSummaryItem *> *summaryItems))completion {
    
    for (PKPaymentSummaryItem *item in self.summaryItems) {
        item.amount = [item.amount decimalNumberByAdding:[NSDecimalNumber decimalNumberWithMantissa:300 exponent:-1 isNegative:NO]];
    }
    
    completion(PKPaymentAuthorizationStatusSuccess, self.shipingMethod,self.summaryItems);
}


/**
 *  当用户选择一个新的支付卡时调用该方法。使用该代理回调更新概要项用以响应卡片方式的改变(例如：信用卡附加费)，调用更新概要项的回调。
 *
 *  @param controleller  支付授权视图控制器
 *  @param paymentMethod 新的支付方式
 *  @param completion    当app更新概要项之后回调完成的Block。该Block包含下面参数：
                         *summaryItem 包含任何由支付方式引起的费用或者信用卡附加费带来的改变而更新后的概要项数组。
 */
//这个方法不会在此被触发,除非支付授权完成或者它调用了自己completion block
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                    didSelectPaymentMethod:(PKPaymentMethod *)paymentMethod
                                completion:(void (^)(NSArray<PKPaymentSummaryItem *> *summaryItems))completion {
    NSLog(@"%s",__func__);
    completion(self.summaryItems);//如果不调用此方法,在授权ViewController消失之前，不会再触发这个方法
}


@end
