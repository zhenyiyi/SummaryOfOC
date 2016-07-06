//
//  FetchedResultsTableDataSource.m
//  ConcurrentProgramming
//
//  Created by fenglin on 16/7/5.
//  Copyright © 2016年 fenglin. All rights reserved.
//

#import "FetchedResultsTableDataSource.h"

@interface FetchedResultsTableDataSource()<NSFetchedResultsControllerDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong)NSFetchedResultsController *fetchResultsController;
@end

@implementation FetchedResultsTableDataSource

-(id)initWithTableView:(UITableView *)tableView fetchResultsController:(NSFetchedResultsController *)fetchResultsController{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.fetchResultsController = fetchResultsController;
        [self setup];
    }
    return self;
}

- (void)setup{
    self.tableView.dataSource = self;
    self.fetchResultsController.delegate = self;
    [self.fetchResultsController performFetch:NULL];
}

-(void)changePrediate:(NSPredicate *)predicate{
    
}

-(id)selectedItem{
    return [self itemAtPath:[self.tableView indexPathForSelectedRow]];
}

- (id)itemAtPath:(NSIndexPath *)indexPath{
    return [self.fetchResultsController objectAtIndexPath:indexPath];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPth:(NSIndexPath *)indexPath{
    
    id item = [self itemAtPath:indexPath];
    if (self.configure) {
        self.configure(cell,item);
    }
}


#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.fetchResultsController.sections.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.fetchResultsController.sections[section] numberOfObjects];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPth:indexPath];
    return cell;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> fetchedInfo =  self.fetchResultsController.sections[section];
    return fetchedInfo.name;
}



#pragma mark -- NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath{
    NSLog(@"NSFetchedResultsChangeType1 : %lu",(unsigned long)type);
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            if ([self.tableView.indexPathsForVisibleRows indexOfObject:indexPath] != NSNotFound) {
                [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPth:indexPath];
            }
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{

    switch (type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

@end
