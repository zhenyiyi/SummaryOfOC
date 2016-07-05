//
//  SecondViewController.m
//  KVO&&Block
//
//  Created by fenglin on 6/29/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import "SecondViewController.h"
#import "Bank.h"



@interface SecondViewController ()<BankObserverProtocol>

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[BankManager defalutManager] addObserver:self];
    
    NSArray *arr = [UIApplication sharedApplication].windows;
    NSLog(@"windows0: %@",arr.firstObject);
}

-(void)bankChanged:(Bank *)bank{
    NSLog(@"bankChanged ：%f",bank.amount);
}

-(void)dealloc{
    [[BankManager defalutManager] removeObserver:self];
}


@end
