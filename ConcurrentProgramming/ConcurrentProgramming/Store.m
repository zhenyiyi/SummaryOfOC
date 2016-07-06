//
//  Store.m
//  ConcurrentProgramming
//
//  Created by fenglin on 7/5/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import "Store.h"



@interface Store()


@property (nonatomic, strong) NSManagedObjectModel  *managedObjectModel;

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong, readwrite) NSManagedObjectContext *mainManagedObjectContext;

@end

@implementation Store

#pragma mark -- life style

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            NSManagedObjectContext *moc = self.mainManagedObjectContext;
            if (moc != note.object) {
                [moc performBlock:^{
                    [moc mergeChangesFromContextDidSaveNotification:note];
                }];
            }
        }];
    }
    return self;
}

-(NSManagedObjectModel *)managedObjectModel{
    
    if (_managedObjectModel == nil) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (_persistentStoreCoordinator == nil) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSURL *url = [[self applicationDocumentPath] URLByAppendingPathComponent:@"DataModel.sqlite"];
        NSError *error = nil;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
            NSLog(@"%@",error);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

-(NSManagedObjectContext *)mainManagedObjectContext{
    if (!_mainManagedObjectContext) {
        _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _mainManagedObjectContext;
}

#pragma mark -- public mrthod

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.mainManagedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"%@",error);
            abort();
        }
    }
}

- (NSManagedObjectContext*)newPrivateContext{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    return context;
}


#pragma mark - private method
- (NSURL *)applicationDocumentPath{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
