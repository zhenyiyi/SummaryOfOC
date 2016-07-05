//
//  ImprotOperation.h
//  ConcurrentProgramming
//
//  Created by fenglin on 7/5/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Store.h"


typedef void (^ProgressBlock)(CGFloat progress);

@interface ImprotOperation : NSOperation

@property (nonatomic, copy) ProgressBlock progress;

-(id)initWithStore:(Store *)store fileName:(NSString *)fileName;

@end
