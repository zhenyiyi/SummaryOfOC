//
//  ImprotOperation.h
//  ConcurrentProgramming
//
//  Created by fenglin on 7/5/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"


@interface ImprotOperation : NSOperation

-(id)initWithStore:(Store *)store fileName:(NSString *)fileName;

@end
