//
//  Bank.h
//  KVO&&Block
//
//  Created by fenglin on 6/29/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Bank;

@interface BankObserver : NSObject

@property (nonatomic, copy) void (^notifyBlock)(Bank * bank);

- (void)addBank:(Bank *)bank;

+ (instancetype)observerForBank:(Bank *)bank;;

@end

@protocol BankObserverProtocol <NSObject>

- (void)bankChanged:(Bank *)bank;

@end

@interface BankManager : NSObject

+ (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (instancetype)defalutManager;

- (void)addObserver:(id<BankObserverProtocol>)observer;

- (void)removeObserver:(id<BankObserverProtocol>)observer;

- (void)addBankObserverWithBank:(Bank*)bank;

@end

@interface Bank : NSObject

@property(nonatomic, assign) CGFloat amount;

@end
