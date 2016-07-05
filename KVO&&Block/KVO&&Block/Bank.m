//
//  Bank.m
//  KVO&&Block
//
//  Created by fenglin on 6/29/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import "Bank.h"
#import <objc/runtime.h>


static int kBankObserverKey ;

@implementation BankObserver{
    __unsafe_unretained Bank *_bank;
    /**
     *  if use '__weak'
     *  'An instance 0x7f9f7ae21510 of class Bank was deallocated while key value observers were still registered with it
     */
}

-(void)dealloc{
    NSLog(@"BankObserver dealloc");
    [self remoberAllObserver];
}

- (void)addBank:(Bank *)bank{
    if (_bank == bank) return;
    if (_bank) {
        [self remoberAllObserver];
        objc_setAssociatedObject(_bank, &kBankObserverKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    _bank = bank;
    if (_bank) {
        [self  addObserver];
    }
    objc_setAssociatedObject(bank, &kBankObserverKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)remoberAllObserver{
    [_bank removeObserver:self forKeyPath:@"amount"];
}

- (void)addObserver{
    [_bank addObserver:self forKeyPath:@"amount" options:kNilOptions context:nil];
}

+ (instancetype)observerForBank:(Bank *)bank{
    if (!bank) return  nil;
    return objc_getAssociatedObject(bank, &kBankObserverKey);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"keyPath : %@",keyPath);
    NSLog(@"object : %@",object);
    NSLog(@"change : %@",change);
    
    if (_notifyBlock) {
        _notifyBlock(_bank);
    }
}
@end



@interface BankManager (){
    
}
@property (strong ,nonatomic)NSHashTable *hashTable;
@end

@implementation BankManager

-(void)dealloc{
    NSLog(@"BankManager dealloc");
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"BankManager init error" reason:@"<use 'defalutManager' init>" userInfo:nil];
    return [super init];
}

+ (instancetype)defalutManager{
    static BankManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BankManager alloc] _init];
    });
    return instance;
}

-(instancetype)_init{
    self = [super init];
    _hashTable = [NSHashTable hashTableWithOptions:NSMapTableWeakMemory];
    return self;
}

- (void)addObserver:(id<BankObserverProtocol>)observer{
    if (!observer) return;
    [_hashTable addObject:observer];
}

- (void)removeObserver:(id<BankObserverProtocol>)observer{
    if (!observer) return;
    [_hashTable removeObject:observer];
}

- (void)addBankObserverWithBank:(Bank*)bank{
    
    BankObserver *observer = [BankObserver observerForBank:bank];
    if (!observer) {
        observer = [[BankObserver alloc] init];
        __weak typeof(self) _self = self;
        observer.notifyBlock = ^(Bank * bank){
//            NSLog(@"amount: %f",bank.amount);
            for (id <BankObserverProtocol> obser in _self.hashTable) {
                if ([obser respondsToSelector:@selector(bankChanged:)]) {
                    [obser bankChanged:bank];
                }
            }
        };
        [observer addBank:bank];
    }
}

@end



@implementation Bank

@end
