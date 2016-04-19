//
//  ViewController.m
//  ApplePayDemo
//
//  Created by jianghai on 16/4/18.
//  Copyright © 2016年 jianghai. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>
#import <AddressBook/AddressBook.h>

@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>
@property (nonnull ,nonatomic , strong)NSMutableArray *summaryItems;
@property (nonnull ,nonatomic , strong)NSMutableArray <PKShippingMethod *> *shipingMethod;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)payment:(id)sender {
    if(![PKPaymentAuthorizationViewController class]){
        return;
    }
    if (![PKPaymentAuthorizationViewController canMakePayments]) {
        return;
    }
    //检查用户是否可进行某种卡的支付，是否支持Amex、MasterCard、Visa与银联四种卡，根据自己项目的需要进行检测
    NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
    if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
        NSLog(@"没有绑定支付卡");
        return;
    }
    
    
    PKPaymentRequest *paymentRequest = [[PKPaymentRequest alloc] init];
    paymentRequest.countryCode = @"CN";
    paymentRequest.currencyCode = @"CNY";
    paymentRequest.merchantIdentifier = @"merchant.com.mll.mllcustomer";
    paymentRequest.supportedNetworks = supportedNetworks;
    paymentRequest.merchantCapabilities = PKMerchantCapability3DS|PKMerchantCapabilityEMV;
    
    // payRequest.requiredBillingAddressFields = PKAddressFieldEmail;
    //如果需要邮寄账单可以选择进行设置，默认PKAddressFieldNone(不邮寄账单)
    //楼主感觉账单邮寄地址可以事先让用户选择是否需要，否则会增加客户的输入麻烦度，体验不好，
    paymentRequest.requiredShippingAddressFields = PKAddressFieldPhone|PKAddressFieldPostalAddress|PKAddressFieldName;
    //送货地址信息，这里设置需要地址和联系方式和姓名，如果需要进行设置，默认PKAddressFieldNone(没有送货地址)
    
    
    //设置配送方式
    PKShippingMethod *shipingOne = [PKShippingMethod summaryItemWithLabel:@"包邮" amount:[NSDecimalNumber zero]];
    shipingOne.identifier = @"shipingOne";
    shipingOne.detail = @"免费送货,但是速度超慢";
    PKShippingMethod *shipingTwo = [PKShippingMethod summaryItemWithLabel:@"包邮" amount:[NSDecimalNumber decimalNumberWithMantissa:1000 exponent:-2 isNegative:NO]];
    shipingTwo.identifier = @"shipingOne";
    shipingTwo.detail = @"免费送货,但是速度超慢";
    self.shipingMethod = (NSMutableArray <PKShippingMethod *>*)@[shipingOne,shipingTwo];
    paymentRequest.shippingMethods = self.shipingMethod;
    

    NSDecimalNumber *priceOne = [NSDecimalNumber decimalNumberWithMantissa:123456 exponent:-2 isNegative:NO];
    PKPaymentSummaryItem *item1 = [PKPaymentSummaryItem summaryItemWithLabel:@"item1价格" amount:priceOne];
    
    NSDecimalNumber *priceTwo = [NSDecimalNumber decimalNumberWithMantissa:123456 exponent:-4 isNegative:YES];
    PKPaymentSummaryItem *item2 = [PKPaymentSummaryItem summaryItemWithLabel:@"item2价格" amount:priceTwo];

    NSDecimalNumber *totalPrice = [NSDecimalNumber zero];
    totalPrice = [totalPrice decimalNumberByAdding:priceOne];
    totalPrice = [totalPrice decimalNumberByAdding:priceTwo];
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"蒋海" amount:totalPrice];//最后这个是支付给谁。哈哈，快支付给我
    
    self.summaryItems = [NSMutableArray arrayWithObjects:item1,item2,total, nil];
    //summaryItems为账单列表，类型是 NSMutableArray，这里设置成成员变量，在后续的代理回调中可以进行支付金额的调整。
    paymentRequest.paymentSummaryItems = self.summaryItems;
    
    //ApplePay控件
    PKPaymentAuthorizationViewController *view = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:paymentRequest];
    view.delegate = self;
    [self presentViewController:view animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
