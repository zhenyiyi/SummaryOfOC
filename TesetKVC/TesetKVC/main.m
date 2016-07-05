//
//  main.m
//  TesetKVC
//
//  Created by fenglin on 7/5/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        
        NSArray *a = @[@4,@82,@2];
        NSLog(@"max = %@",[a  valueForKeyPath:@"@max.self"]);
        NSLog(@"min = %@",[a  valueForKeyPath:@"@min.self"]);
        NSLog(@"avg = %@",[a  valueForKeyPath:@"@avg.self"]);
        NSLog(@"sum = %@",[a  valueForKeyPath:@"@sum.self"]);
        NSLog(@"sum = %@",[a  valueForKeyPath:@"@count.self"]);
    }
    return 0;
}
