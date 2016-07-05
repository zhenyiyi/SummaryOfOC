//
//  ImprotOperation.m
//  ConcurrentProgramming
//
//  Created by fenglin on 7/5/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import "ImprotOperation.h"

@interface ImprotOperation()
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong)NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong)Store *store;
@end

@implementation ImprotOperation

-(id)initWithStore:(Store *)store fileName:(NSString *)fileName{
    self = [super init];
    if (self) {
        _store = store;
        _fileName = fileName;
    }
    return self;
}

-(void)main{
    self.managedObjectContext = [self.store newPrivateContext];
    self.managedObjectContext.undoManager = nil;
    [self.managedObjectContext performBlockAndWait:^{
        [self improt];
    }];
}

- (void)improt{
    NSString *file = [NSString stringWithContentsOfFile:self.fileName encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",file);
    
    NSArray * array = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}
@end
