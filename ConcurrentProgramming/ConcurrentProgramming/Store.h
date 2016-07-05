//
//  Store.h
//  ConcurrentProgramming
//
//  Created by fenglin on 7/5/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Store : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainManagedObjectContext;

- (void)saveContext;

- (NSManagedObjectContext*)newPrivateContext;

@end
