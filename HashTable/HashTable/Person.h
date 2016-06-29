//
//  Person.h
//  HashTable
//
//  Created by fenglin on 6/29/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic ,strong, readonly) NSString *name;
@property (nonatomic ,strong, readonly) NSMutableArray *family;


@property (nonatomic ,strong, readonly) NSHashTable *hashTable; ///<不会修改HashTable容器内对象元素的引用计数，并且对象释放后，会被自动移除

+ (instancetype)personWithName:(NSString *)name;



@end
