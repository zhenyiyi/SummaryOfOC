//
//  Stop+CoreDataProperties.h
//  ConcurrentProgramming
//
//  Created by fenglin on 7/5/16.
//  Copyright © 2016 fenglin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Stop.h"

NS_ASSUME_NONNULL_BEGIN

@interface Stop (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSString *name;


+ (void)importCompents:(NSArray *)compents managedObjectContext:(NSManagedObjectContext *)context;


@end

NS_ASSUME_NONNULL_END
