//
//  LabColor.m
//  KVO&&KVC
//
//  Created by fenglin on 6/30/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import "LabColor.h"

@implementation LabColor

-(UIColor *)color{
    return [UIColor colorWithRed:self.redComponent *0.01 green:self.greenComponent * 0.01 blue:self.blueComponent *0.01 alpha:1.0];
}

- (double)greenComponent{
    return 6;
}
@end
