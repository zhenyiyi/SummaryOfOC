//
//  ImprotOperation.m
//  ConcurrentProgramming
//
//  Created by fenglin on 7/5/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import "ImprotOperation.h"
#import "NSString+ParseCSV.h"
#import "Stop.h"



static const NSInteger kSavedCount = 250;

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
        [self import];
    }];
}

- (void)import{
    NSString *file = [NSString stringWithContentsOfFile:self.fileName encoding:NSUTF8StringEncoding error:NULL];
//    NSLog(@"%@",file);
    
    NSArray * array = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSInteger totalCount = array.count;
    
    NSInteger OnePercentCount = totalCount / 100 ;
    
    __block NSInteger index = -1;
    
//    __weak typeof(self) _self = self;
    
    [file enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        
        
//        NSLog(@"line = = %@",line);
//        sleep(1);
        index ++;
        
        if (index == 0) return ;
        
        if (self.isCancelled) {
            *stop = YES;
            return;
        }
        
        NSArray *compents = [line csvComponents];
        
        if (compents.count < 5) {
            return;
        }
        
        if (index % OnePercentCount == 0) {
            if (self.progress)  self.progress((CGFloat)index/totalCount);
        }
        
        [Stop importCompents:compents managedObjectContext:self.managedObjectContext];
        
        if (index % kSavedCount == 0) {
            [self.managedObjectContext save:NULL];
        }
        
    }];
     if (self.progress) self.progress(1);
     [self.managedObjectContext save:NULL];
}


@end
