//
//  Stop+CoreDataProperties.m
//  ConcurrentProgramming
//
//  Created by fenglin on 7/5/16.
//  Copyright © 2016 fenglin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Stop+CoreDataProperties.h"

@implementation Stop (CoreDataProperties)

@dynamic identifier;
@dynamic latitude;
@dynamic longitude;
@dynamic name;

+ (NSManagedObject *)findManagedObjectWithIdentify:(NSString *)identify managedObjectContext:(NSManagedObjectContext *)context{
    NSString *className = NSStringFromClass(self);
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:className];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@",identify];
    request.predicate = predicate;
    request.fetchLimit = 1;
    NSManagedObject *managedObj = [[context executeFetchRequest:request error:NULL] lastObject];
    if (managedObj == nil) {
        managedObj = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:context];
    }
    return managedObj;
}

+ (void)importCompents:(NSArray *)compents managedObjectContext:(NSManagedObjectContext *)context{

    Stop *stop = (Stop *)[self findManagedObjectWithIdentify:compents[0] managedObjectContext:context];
    stop.identifier = compents[0];
    stop.name = compents[2];
    stop.latitude = [NSNumber numberWithDouble:[compents[4] doubleValue]];
    stop.longitude = [NSNumber numberWithDouble:[compents[5] doubleValue]];
}

@end
