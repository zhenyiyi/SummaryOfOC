//
//  StateContext.h
//  StateMachine
//
//  Created by fenglin on 7/1/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderState.h"


@interface StateContext : NSObject

+ (id)defalutContext;

- (void)addState:(OrderStatus )status;

@end
