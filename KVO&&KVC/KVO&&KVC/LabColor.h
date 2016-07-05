//
//  LabColor.h
//  KVO&&KVC
//
//  Created by fenglin on 6/30/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface LabColor : NSObject

@property (nonatomic, assign) double lComponent;
@property (nonatomic, assign) double aComponent;
@property (nonatomic, assign) double bComponent;


@property (nonatomic, assign, readonly) double redComponent;
@property (nonatomic, assign, readonly) double greenComponent;
@property (nonatomic, assign, readonly) double blueComponent;

@property (nonatomic, strong, readonly) UIColor *color;



@end
