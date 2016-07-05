//
//  ViewController.m
//  KVO&&Block
//
//  Created by fenglin on 6/29/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "Bank.h"


@interface ViewController ()<BankObserverProtocol ,UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = [UIApplication sharedApplication].windows;
    NSLog(@"windows0: %@",arr.firstObject);
    
    // 1.当键盘弹出的时候 有3个window； {1.UIWindow（0） 2.UITextEffectsWindow（1） 3.UIRemoteKeyboardWindow（10000000）}
    
    /*
     
     iOS 6/7:
     UITextEffectsWindow
     UIPeripheralHostView << keyboard
     
     iOS 8:
     UITextEffectsWindow
     UIInputSetContainerView
     UIInputSetHostView << keyboard
     
     iOS 9:
     UIRemoteKeyboardWindow
     UIInputSetContainerView
     UIInputSetHostView << keyboard

     */

    Bank *bank = [[Bank alloc] init];
    
    [[BankManager defalutManager] addObserver:self];
    
    [[BankManager defalutManager] addBankObserverWithBank:bank];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        bank.amount = 30;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          bank.amount = 0;
    });
    
  
    
    
}

-(void)dealloc{
    [[BankManager defalutManager] removeObserver:self];
}

-(void)bankChanged:(Bank *)bank{
    NSLog(@"bank : %.2f",bank.amount);
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSArray *arr = [UIApplication sharedApplication].windows;
    
    for (UIWindow *window in arr) {
        NSLog(@"windows1: %@ level : %.0f",window,window.windowLevel);
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSArray *arr = [UIApplication sharedApplication].windows;
    for (UIWindow *window in arr) {
        NSLog(@"windows2: %@ level : %.0f",window,window.windowLevel);
    }
    return YES;
}

@end
