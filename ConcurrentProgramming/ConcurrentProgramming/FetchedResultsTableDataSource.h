//
//  FetchedResultsTableDataSource.h
//  ConcurrentProgramming
//
//  Created by fenglin on 16/7/5.
//  Copyright © 2016年 fenglin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class Stop;

typedef void (^ConfigureBlock)(id cell, id item);

@interface FetchedResultsTableDataSource : NSObject <UITableViewDataSource>

@property(nonatomic, copy) ConfigureBlock configure;

-(id)initWithTableView:(UITableView *)tableView fetchResultsController:(NSFetchedResultsController *)fetchResultsController;

-(void)changePrediate:(NSPredicate *)predicate;

-(id)selectedItem;

@end
