//
//  main.m
//  HashTable
//
//  Created by fenglin on 6/29/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"


static void SimpleObjectExample(){
    
    Person *p  = [Person personWithName:@"fenglin"];
    
    NSLog(@"p -- retainCount ： %lu",(unsigned long)p.retainCount);
    
    p = nil;
    
    NSLog(@"p -- retainCount ： %lu",(unsigned long)p.retainCount);
}


static void testWeakMemory() {
   
    Person * p = [[Person alloc] init];
    
    [p release];
    
    NSLog(@"hash table [3] : %@",p.hashTable);
}


/*
 * 改项目采用mrc ，测试 NSHashtable 。
 *
 * NSHashTable效仿了NSSet(NSMutableSet)，但提供了比NSSet更多的操作选项，尤其是在对弱引用关系的支持上，NSHashTable在对象/内存处理时更加的灵活。相较于NSSet，NSHashTable具有以下特性：
 
    NSSet(NSMutableSet)持有其元素的强引用，同时这些元素是使用hash值及isEqual:方法来做hash检测及判断是否相等的。
 
    NSHashTable是可变的，它没有不可变版本。
 
    它可以持有元素的弱引用，而且在对象被销毁后能正确地将其移除。而这一点在NSSet是做不到的。
 
    它的成员可以在添加时被拷贝。
 
    它的成员可以使用指针来标识是否相等及做hash检测。
 
    它可以包含任意指针，其成员没有限制为对象。我们可以配置一个NSHashTable实例来操作任意的指针，而不仅仅是对象。
 *
 *
 * 个人认为NSHashTable吸引人的地方在于可以持有元素的弱引用，而且在对象被销毁后能正确地将其移除。
 *   As always, it's important to remember that programming is not about being clever: always approach a problem from the highest viable level of abstraction. NSSet and NSDictionary are great classes. For 99% of problems, they are undoubtedly the correct tool for the job. If, however, your problem has any of the particular memory management constraints described above, then NSHashTable & NSMapTable may be worth a look.
 */
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
//        SimpleObjectExample();

        testWeakMemory();
    }
    return 0;
}


