//
//  ViewController.m
//  ApplePayDemo
//
//  Created by jianghai on 16/4/18.
//  Copyright © 2016年 jianghai. All rights reserved.
//

#import "ViewController.h"
#import "ApplePayManager.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)payment:(id)sender {
    
//    [[ApplePayManager sharedManager] presentPayVCFrom:self withOrdersInfo:nil];
}

- (IBAction)payWithUPA:(id)sender {
   [[ApplePayManager sharedManager] presentUPAPayVC:self withOrdersInfo:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
