//
//  ViewController.m
//  ConcurrentProgramming
//
//  Created by fenglin on 7/5/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import "ViewController.h"
#import "ImprotOperation.h"
#import "FetchedResultsTableDataSource.h"
#import "Stop.h"




/**
 *      1.我们将会看看如何并发地使用 Core Data ，如何并行绘制 UI ，如何做异步网络请求等。最后我们将研究如何异步处理大型文件，以保持较低的内存占用。因为在异步编程中非常容易犯错误，所以，本文中的例子都将使用很简单的方式。因为使用简单的结构可以帮助我们看透代码，抓住问题本质。如果你最后把代码写成了复杂的嵌套回调的话，那么你很可能应该重新考虑自己当初的设计选择了。
 
 *      2.操作队列提供了在 GCD 中不那么容易复制的有用特性。其中最重要的一个就是可以取消在任务处理队列中的任务，在稍后的例子中我们会看到这个。而且操作队列在管理操作间的依赖关系方面也容易一些。另一面，GCD 给予你更多的控制权力以及操作队列中所不能使用的底层函数。
 
 *      3.比如绝对不要在线程间传递 managed objects等。这并不单是说你绝不应该在另一个线程中去更改某个其他线程的 managed object ，甚至是读取其中的属性都是不能做的。要想传递这样的对象，正确做法是通过传递它的 object ID ，然后从其他对应线程所绑定的 context 中去获取这个对象。
 */

/**
 *  Core Data 介绍。
        1.NSManagedObjectContext：（托管对象的上下文）负责应用和数据库之间的交互。
        2.NSPersitentStroeCoordinator:  添加持续数据库，（比如SQLite数据库）。
        3.NSManagedObjectModel  : 代表Core Data的模型文件。
          .entities  NSEntityDescription 用来描述实体。
        
        1.初始化NSManagedObjectModel对象，加载模型文件，读取app中的所有实体信息
        2.初始化NSPersistentStoreCoordinator对象，添加持久化库(这里采取SQLite数据库)
        3.初始化NSManagedObjectContext对象，拿到这个上下文对象操作实体，进行CRUD操作
 
 */
@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (nonatomic, strong)Store *myStore;
@property (nonatomic, strong)FetchedResultsTableDataSource *dataSource;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.operationQueue = [[NSOperationQueue alloc] init];

    self.myStore = [[Store alloc] init];
    
//    __weak typeof(self) _self = self;
    
//    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
//        [_self.myStore  saveContext];
//    }];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Stop"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSFetchedResultsController *fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.myStore.mainManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    
    self.dataSource = [[FetchedResultsTableDataSource alloc] initWithTableView:self.tableView fetchResultsController:fetchResultsController];
    
    self.tableView.dataSource = self.dataSource;
    
    self.dataSource.configure = ^(UITableViewCell *cell, Stop *stop){
        cell.textLabel.text = stop.name;
    };
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
//
//    NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:store.mainManagedObjectContext];
//    [person setValue:@"fenglin" forKey:@"name"];
//    [person setValue:@27 forKey:@"age"];
//    
//    NSManagedObject *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:store.mainManagedObjectContext];
//    [card setValue:@"4103221990" forKey:@"no"];
//    
//    [person setValue:card forKey:@"card"];
//    
//    [store saveContext];
    
//    
//    NSFetchRequest *requeset = [[NSFetchRequest alloc] init];
//    requeset.entity = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:store.mainManagedObjectContext];
//    
//    NSError *error = nil;
//    
//    NSAsynchronousFetchResult *res = [store.mainManagedObjectContext executeRequest:requeset error:&error];
//    if (error) {
//        NSLog(@"%@",error);
//    }
////    NSLog(@"res : %@",res.finalResult);
//    
//    for (NSManagedObject *obj in res.finalResult) {
//        NSLog(@"%@",[obj valueForKey:@"no"]);
//    }
    
    
}

- (IBAction)beginLoad:(id)sender{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"stops" ofType:@"txt"];
    ImprotOperation *operation = [[ImprotOperation alloc] initWithStore:self.myStore fileName:fileName];
    operation.progress = ^(CGFloat progress){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.progressView.progress = progress;
            NSLog(@"%f",progress);
        }];
    };
    [self.operationQueue addOperation:operation];
}

- (IBAction)cancelLoad:(id)sender{
    
}

@end
