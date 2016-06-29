//
//  Person.m
//  HashTable
//
//  Created by fenglin on 6/29/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import "Person.h"

@interface Person ()
@property (nonatomic ,strong, readwrite) NSString *name;
@property (nonatomic ,strong, readwrite) NSMutableArray *family;
@property (nonatomic ,strong, readwrite) NSHashTable *hashTable;

@end

@implementation Person

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self testWeakMemory];

        NSLog(@"hash table [2] : %@",_hashTable);
    }
    return self;
}


+ (instancetype)personWithName:(NSString *)name{
    Person * p = [[Person alloc] init];
    NSLog(@"retainCount 1 ： %lu",(unsigned long)p.retainCount);
    p.name = name;
//    p.family = [NSMutableArray new];
//    [p.family addObject:p];
    
    
    p.hashTable = [NSHashTable hashTableWithOptions:NSMapTableWeakMemory];
    [p.hashTable addObject:p];
   
    NSLog(@"retainCount 3 ： %lu",(unsigned long)p.retainCount);
    return [p autorelease];
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@'s retainCount is %lu>",self.name,[self retainCount]];
}

- (void)dealloc
{
    [super dealloc];
    _name = nil;
    _family = nil;
    _hashTable = nil;
}

- (void)testWeakMemory {
    if (!_hashTable) {
        _hashTable = [NSHashTable weakObjectsHashTable];
    }
    NSObject *obj = [[NSObject alloc] init];
    [_hashTable addObject:obj];
    NSLog(@"hash table [1] : %@", _hashTable);
    
    [obj release];
}

@end
