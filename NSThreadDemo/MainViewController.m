//
//  MainViewController.m
//  NSThreadDemo
//
//  Created by GongHui_YJ on 16/8/19.
//  Copyright © 2016年 YangJian. All rights reserved.
//

#import "MainViewController.h"
#import "NSThreadDemoOne.h"
#import "NSThreadDemoTwo.h"
#import "NSThreadDemoThree.h"

/**
    // demo说明
    NSThreadDemoOne: 简单使用多线程，区分有多线程和没有多线的区别
    NSThreadDemoTwo: 因为NSThread只能传一个一个参数,如果咬传递多个参数，使用封装对象 传一个对象然后自己分解； 也可以指定某个线程优先执行
    NSThreadDemoThree：在运行的时候，停止没有完成的线程操作。 线程状态分为isExecuting(正在执行)、 isFinished(已经完成)、isCancelled(已经取消)三种。其中取消状态程序可以干预设置，只要调用线程cancel方法即可。但是需要注意在主线程中仅仅能设置线程状态，并不能真正停止当前线程，如果要终止线程必须在线程中调用exist方法，这是一个静态方法，调用该方法可以退出当前线程。
 */

/**

    iOS多线程开发一 使用NSThread 因为这个在实际开发项目中用的不多，所以会简单使用就好
    
    NSThread(显示创建线程) 有两种方式创建线程，在主线程中更新UI，只能传一个参数，停止线程调用exist方法
    1.类方法 +(void)detachNewThreadSelector:(SEL)selector toTarget:(id)target withObject:(id)argument
        例: [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];

    2.对象方法 -(instancetype)initWithTarget:(id)target selector:(SEL)selector object:(id)argument 此方法需要对象启动线程
        例: NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImage) object:nil];
            // 启动线程，注意 启动项线程并非一定立即执行，而是出于就绪状态，当系统调度时才真正执行
            [thread start];
    
    3、当线程执行完，需要在把数据显示到UI控件时，因为只能在主线程中更新UI 所以需要调用NSObject的分类方法
    [self performSelectorOnMainThread:@select(updateImage:) withObject:data waitUntiDone:Yes];
 
    4、因为NSThread只能传一个参数,如果咬传递多个参数，使用封装对象 传一个对象然后自己分解； 也可以指定某个线程优先执行
 
    5、在运行的时候，停止没有完成的线程操作。 线程状态分为isExecuting(正在执行)、 isFinished(已经完成)、isCancelled(已经取消)三种。其中取消状态程序可以干预设置，只要调用线程cancel方法即可。但是需要注意在主线程中仅仅能设置线程状态，并不能真正停止当前线程，如果要终止线程必须在线程中调用exist方法，这是一个静态方法，调用该方法可以退出当前线程。

    6、NSThread相关属性及方法
 //// 获取/设置线程的名字
 //@property (copy) NSString *name NS_AVAILABLE(10_5, 2_0);
 //

 // *  获取当前线程的线程对象
 // *
 // *  通过这个属性可以查看当前线程是第几条线程，主线程为1。
 // *  可以看到当前线程的序号及名字，主线程的序号为1，依次叠加。
//+ (NSThread *)currentThread;
//
//// 线程休眠（秒）
//+ (void)sleepForTimeInterval:(NSTimeInterval)ti;
//
//// 线程休眠，指定具体什么时间休眠
//+ (void)sleepUntilDate:(NSDate *)date;
//
//// 退出线程
//// 注意：这里会把线程对象销毁！销毁后就不能再次启动线程，否则程序会崩溃。
//+ (void)exit;


    NSObject(隐式创建线程)：苹果官方对NSObject进行分类扩张，为了简化多线程开发过程， 可以直接使用下面的几个方法
    - (void)performSelectorInBackground:(SEL)aSelector withObject:(id)arg 在后台执行一个操作，本质就是重新创建一个线程执行当前的方法
    - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait：在指定的线程上执行一个方法，需要用户创建一个线程对象。
    - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait：在主线程上执行一个方法
 
 

 */



@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    if (indexPath.row == 0) {
        cell.textLabel.text = @"NSThreadOne";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"NSThreadTwo";
    } else {
        cell.textLabel.text = @"NSThreadThree";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NSThreadDemoOne *oneVC = [storyboard instantiateViewControllerWithIdentifier:@"NSThreadDemoOne"];
        [self.navigationController pushViewController:oneVC animated:YES];

    } else if (indexPath.row == 1) {
        NSThreadDemoTwo *two = [[NSThreadDemoTwo alloc] init];
        [self.navigationController pushViewController:two animated:YES];
    } else {
        NSThreadDemoThree *three = [[NSThreadDemoThree alloc] init];
        [self.navigationController pushViewController:three animated:YES];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
