//
//  StateContext.m
//  StateMachine
//
//  Created by fenglin on 7/1/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import "StateContext.h"

@interface StateContext ()
{
    OrderStatus _orderStatus;
    
}
@end

@implementation StateContext


+ (id)defalutContext{
    static StateContext * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[StateContext alloc] init];
    });
    return instance;
}

- (void)addState:(OrderStatus )status{
    _orderStatus = status;
}


@end
