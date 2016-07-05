	
	Grand Central Dispatch (GCD) 

    NSOPerationQueue
    
    pthread
    
    NSThread
    
    NSRunLoop
    
    实际上把 run loop 也列在其中是有点奇怪，因为它并不能实现真正的并行，不过因为它与并发编程有莫大的关系，因此值得我们进行一些深入了解
    
    
    
#### 线程

   			
   	线程（thread） 是组成进程的子单元，操作系统的调度器可以对线程进行单独的调度。
   	实际上，所有的并发线程API都是构建与线程之上的---包括CGD&&OperationQueue.
   
   	多线程可以在单核 CPU 上同时（或者至少看作同时）运行。操作系统将小的时间片分配给每一个线程，这样就能够让用户感觉到有多个任务在同时进行。如果 CPU 是多核的，那么线程就可以真正的以并发方式被执行，从而减少了完成某项操作所需要的总时间
   
   
   
####并发编程中面临的挑战
只要一旦你做的事情超过了最基本的情况，对于并发执行的多任务之间的相互影响的不同状态的监视就会变得异常困难。 问题往往发生在一些不确定性（不可预见性）的地方，这使得在调试相关并发代码时更加困难。



####资源共享
并发编程中许多问题的根源就是在多线程中访问共享资源。资源可以是一个属性、一个对象，通用的内存、网络设备或者一个文件等等。在多线程中任何一个共享的资源都可能是一个潜在的冲突点，你必须精心设计以防止这种冲突的发生。


####互斥锁
	
	互斥访问的意思就是同一时刻，只允许一个线程访问某个特定资源。为了保证这一点，每个希望访问共享资源的线程，首先需要获得一个共享资源的互斥锁，一旦某个线程对资源完成了操作，就释放掉这个互斥锁，这样别的线程就有机会访问该共享资源了.
	
	除了解决互斥访问，还需要解决代码无序执行所带来的问题。如果不能确保CPU访问内存的顺序跟编程时的代码指令一样，那么仅仅依靠互斥访问是不够的。为了解决CPU的优化策略引起的副作用，还需要引入内存屏障。通过设置内存屏障，来确保没有无序执行的指令能
	
####死锁
	互斥锁解决了竞态条件的问题，但很不幸的同时引入了一些其它问题，其中一个就是死锁。
	
	
####资源饥饿（Starvation）
当你认为已经足够了解并发编程面临的问题时，又出现了一个新的问题。锁定的共享资源会引起读写问题。大多数情况下，限制资源一次只能有一个线程进行读取访问其实是非常浪费的。因此，在资源上没有写入锁的时候，持有一个读取锁是被允许的。这种情况下，如果一个持有读取锁的线程在等待获取写入锁的时候，其他希望读取资源的线程则因为无法获得这个读取锁而导致资源饥饿的发生。



####优先级反转

优先级反转是指程序在运行时低优先级的任务阻塞了高优先级的任务，有效的反转了任务的优先级。由于 GCD 提供了拥有不同优先级的后台队列，甚至包括一个 I/O 队列，所以我们最好了解一下优先级反转的可能性。

高优先级和低优先级的任务之间共享资源时，就可能发生优先级反转。当低优先级的任务获得了共享资源的锁时，该任务应该迅速完成，并释放掉锁，这样高优先级的任务就可以在没有明显延时的情况下继续执行。然而高优先级任务会在低优先级的任务持有锁的期间被阻塞。如果这时候有一个中优先级的任务(该任务不需要那个共享资源)，那么它就有可能会抢占低优先级任务而被执行，因为此时高优先级任务是被阻塞的，所以中优先级任务是目前所有可运行任务中优先级最高的。此时，中优先级任务就会阻塞着低优先级任务，导致低优先级任务不能释放掉锁，这也就会引起高优先级任务一直在等待锁的释放。


##总结


从主线程中提取出要使用到的数据，并利用一个操作队列在后台处理相关的数据，最后回到主队列中来发送你在后台队列中得到的结果。使用这种方式，你不需要自己做任何锁操作，这也就大大减少了犯错误的几率