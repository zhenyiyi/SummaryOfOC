//
//  Context.h
//  StateMachine
//
//  Created by fenglin on 7/1/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderState.h"



@interface Context : NSObject

+(instancetype)initWithOrderState:(OrderStatus)status;

@end
