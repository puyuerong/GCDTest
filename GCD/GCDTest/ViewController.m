//
//  ViewController.m
//  GCDTest
//
//  Created by 蒲悦蓉 on 2020/8/17.
//  Copyright © 2020 蒲悦蓉. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()
@property NSInteger ticketSurplusCount;
@end

@implementation ViewController

static dispatch_semaphore_t semaphoreLock;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //这里的参数为1 大于1时也会错乱，因为为0时等待，如果这里的参数是1，线程1执行时减1，仍然不为0，则另一个线程也可以进入。
    semaphoreLock = dispatch_semaphore_create(1);

//    [self aboutSiSuo];
//    [self aboutRunloop];
//    [self changePriority];
//    [self aboutDispatchGroup];
//    [self aboutDispatchBarrierAsync];
//    [self aboutDispatchApply];
//    [self aboutSemaphore];
//    [self aboutQuestionOne];
    [self initTicket];
    
}


- (void)aboutSiSuo {
    //1
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"123");
//    });
    
    //2
//    dispatch_queue_t sisuoQueue = dispatch_queue_create("sisuoQueue", NULL);
//    dispatch_async(sisuoQueue, ^{
//        dispatch_sync(sisuoQueue, ^{
//            NSLog(@"1");
//        });
//    });
}

- (void)aboutRunloop {
    
    //子线程默认不开启runloop 所以不会执行say方法
//    dispatch_queue_t serialQueue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(serialQueue, ^{
//         Person *person = [[Person alloc] init];
//         [person performSelector:@selector(say) withObject:nil afterDelay:0];
//    });
    
    //添加到主线程时，主线程的runloop被唤醒，会执行say方法
//    dispatch_async(dispatch_get_main_queue(), ^{
//         Person *person = [[Person alloc] init];
//         [person performSelector:@selector(say) withObject:nil afterDelay:0];
//    });
//
//    手动添加runloop
//    dispatch_queue_t serialQueue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(serialQueue, ^{
//        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
//        Person *person = [[Person alloc] init];
//        [person performSelector:@selector(say) withObject:nil afterDelay:0];
//        [[NSRunLoop currentRunLoop] run];
//    });
}

- (void)aboutSerialAndConcurrent {
    dispatch_queue_t serialDispatchQueue = dispatch_queue_create("serialDispatchQueue", DISPATCH_QUEUE_SERIAL);
    NSMutableArray *array = [NSMutableArray array];
    __block int a;
    for (int i = 0; i < 100; i++) {
        
        dispatch_async(serialDispatchQueue, ^{
            [array addObject:[NSNumber numberWithInt:a]];
        });

    };
    sleep(10);
    NSLog(@"%@", array);
}
- (void)changePriority {
    //首先创建5个串行队列
    dispatch_queue_t serialQueue1 = dispatch_queue_create("com.gcd.setTargetQueue2.serialQueue1", NULL);
    dispatch_queue_t serialQueue2 = dispatch_queue_create("com.gcd.setTargetQueue2.serialQueue2", NULL);
    dispatch_queue_t serialQueue3 = dispatch_queue_create("com.gcd.setTargetQueue2.serialQueue3", NULL);
    dispatch_queue_t serialQueue4 = dispatch_queue_create("com.gcd.setTargetQueue2.serialQueue4", NULL);
    dispatch_queue_t serialQueue5 = dispatch_queue_create("com.gcd.setTargetQueue2.serialQueue5", NULL);

//    每个队列上输出一个数字
    dispatch_async(serialQueue1, ^{
        NSLog(@"1");
    });
    dispatch_async(serialQueue2, ^{
        NSLog(@"2");
    });
    dispatch_async(serialQueue3, ^{
        NSLog(@"3");
    });
    dispatch_async(serialQueue4, ^{
        NSLog(@"4");
    });
    dispatch_async(serialQueue5, ^{
        NSLog(@"5");
    });

 
    //创建目标串行队列
    dispatch_queue_t targetSerialQueue = dispatch_queue_create("com.gcd.setTargetQueue2.targetSerialQueue", NULL);

    //设置执行阶层
    dispatch_set_target_queue(serialQueue1, targetSerialQueue);
    dispatch_set_target_queue(serialQueue2, targetSerialQueue);
    dispatch_set_target_queue(serialQueue3, targetSerialQueue);
    dispatch_set_target_queue(serialQueue4, targetSerialQueue);
    dispatch_set_target_queue(serialQueue5, targetSerialQueue);

    //执行操作
    dispatch_async(serialQueue1, ^{
        NSLog(@"1");
    });
    dispatch_async(serialQueue2, ^{
        NSLog(@"2");
    });
    dispatch_async(serialQueue3, ^{
        NSLog(@"3");
    });
    dispatch_async(serialQueue4, ^{
        NSLog(@"4");
    });
    dispatch_async(serialQueue5, ^{
        NSLog(@"5");
    });
}

- (void)aboutDispatchGroup {
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//    dispatch_group_t group = dispatch_group_create();
//
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"blk0");
//    });
//
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"blk1");
//    });
//
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"blk2");
//    });
//
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"done");
//    });
    
    
    dispatch_queue_t queue0 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue0, ^{
        NSLog(@"blk0");
    });
    dispatch_async(queue0, ^{
        NSLog(@"blk1");
    });
    dispatch_async(queue0, ^{
        NSLog(@"blk2");
    });
    NSLog(@"done");
}

- (void)aboutDispatchBarrierAsync {
    dispatch_queue_t queue = dispatch_queue_create("com.example.gdc.ForBarrier", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{
        NSLog(@"reading1");
    });

    dispatch_async(queue, ^{
        NSLog(@"reading2");
    });

    dispatch_async(queue, ^{
        NSLog(@"reading3");
    });

//    dispatch_async(queue, ^{
//        NSLog(@"writing");
//    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"writing");
    });

    dispatch_async(queue, ^{
        NSLog(@"reading4");
    });

    dispatch_async(queue, ^{
        NSLog(@"reading5");
    });

}

- (void)aboutDispatchApply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_apply(10, queue, ^(size_t index) {
            NSLog(@"%zu",index);
        });
        NSLog(@"done");
    });
    
}

- (void)aboutSemaphore {
    
    //没有时异步执行 不会等待任务结束，就输出了number，所以为0
       
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        
        number = 100;
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphore---end,number = %d",number);
    
}

- (void)aboutQuestionOne {
    //因为是并发线程，所以可能有两个线程同一时间执行给array添加object
    dispatch_queue_t concurrentDispatchQueue = dispatch_queue_create("concurrentDispatchQueue", DISPATCH_QUEUE_CONCURRENT);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        dispatch_async(concurrentDispatchQueue, ^{
            NSLog(@"%@", [NSThread currentThread]);
            [array addObject:[NSNumber numberWithInt:i]];
        });
    }
}



/**
 * 非线程安全：不使用 semaphore
 * 初始化火车票数量、卖票窗口（非线程安全）、并开始卖票
 */
- (void)initTicket {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
//        [weakSelf saleTicketNotSafe];
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketNotSafe];
//        [weakSelf saleTicketSafe];
    });
}

/**
 * 售卖火车票（非线程安全）
 */
- (void)saleTicketNotSafe {
    while (1) {
        
        if (self.ticketSurplusCount > 0) {  // 如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { // 如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            break;
        }
        
    }
}


- (void)saleTicketSafe {
    while (1) {
        // 相当于加锁
        //因为semaphoreLock， 计数为0时等待，计数为1或大于1时，减去1而不等待
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        
        if (self.ticketSurplusCount > 0) {  // 如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { // 如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            
            // 相当于解锁
            dispatch_semaphore_signal(semaphoreLock);
            break;
        }
        
        // 相当于解锁
        dispatch_semaphore_signal(semaphoreLock);
    }
}
@end
