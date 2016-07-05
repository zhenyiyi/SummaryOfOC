//
//  ViewController.m
//  ProgressHUD
//
//  Created by fenglin on 6/30/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"




@interface ViewController ()
{
    MBProgressHUD * _hud;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hud.dimBackground = YES;
//    _hud.color = [UIColor greenColor];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    
    [_hud showAnimated:YES whileExecutingBlock:^{
        
    } completionBlock:^{
        
    }];
  
}



@end
