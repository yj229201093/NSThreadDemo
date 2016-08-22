//
//  ViewController.m
//  NSThreadDemo
//
//  Created by GongHui_YJ on 16/8/19.
//  Copyright © 2016年 YangJian. All rights reserved.
//

#import "NSThreadDemoOne.h"

@interface NSThreadDemoOne ()

@property (weak, nonatomic) IBOutlet UIImageView *iconOneimageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconTwoimageView;

@end

@implementation NSThreadDemoOne

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


/**
 *  下载图片1
 *
 *  @param sender
 */
- (IBAction)downloadImageOne:(id)sender {

    // 方法一 使用对象方法
    // 创建一个线程，第一个参数是请求的操作， 第二个参数是操作方法的参数
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImage) object:nil];
//    // 启动一个线程，注意启动一个线程并非就一定立即执行，而是处于就绪状态，当系统调度时才真正执行
//    [thread start];

    // 方法二 使用类对象
//    [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];

    [self performSelectorInBackground:@selector(loadImage) withObject:nil];

    /**
     *  循环次数多一点 模拟单线程卡顿现象 运行那么多次 要三分钟 本段代码只是为了体现多线程的特性。 无任何意义
     */
//    for (int i = 0; i < 100000; i++) {
//        NSLog(@"%d", i);
//    }

    // 上面循环结束后才能下载图片
//    self.iconOneimageView.image = [self getImage:[self requestDataUrl:@"http://b.hiphotos.baidu.com/image/h%3D200/sign=9b711189efc4b7452b94b016fffd1e78/3c6d55fbb2fb4316fc06edda24a4462309f7d371.jpg"]];
}


/**
 *  加载图片
 */
- (void)loadImage {
    // 放在线程中就不会出现卡死的现象
    for (int i = 0; i < 100000; i++) {
        NSLog(@"%d", i);
    }

    // 请求数据
    NSData *data = [self requestDataUrl:@"http://b.hiphotos.baidu.com/image/h%3D200/sign=9b711189efc4b7452b94b016fffd1e78/3c6d55fbb2fb4316fc06edda24a4462309f7d371.jpg"];

    // 不在主线程中刷新UI 会报错
    // This application is modifying the autolayout engine from a background thread, which can lead to engine corruption and weird crashes.  This will cause an exception in a future release.
//    [self updateImage:data];

    // 将数据显示到UI控件，注意只能在主线程中更新UI
    // 另外performSelectorOnMainThread方法是NSObject的分类方法，每个NSObject对象都有此方法
    // 它调用的selector方法是当前调用控件的方法，例如使用UIImageView调用的selector就是UIImageView的方法
    // object 代表调用方法的参数，不过只能传递一个参数（如果有多个参数使用对象进行封装）
    // waitUntiDone 是否线程任务完成执行
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:data waitUntilDone:YES];

}

/**
 *  将图片显示到界面
 *
 *  @param imageData <#imageData description#>
 */
- (void)updateImage:(NSData *)imageData {

    self.iconOneimageView.image = [self getImage:imageData];
}


/**
 *  下载图片2
 *
 *  @param sender
 */
- (IBAction)downloadImageTwo:(id)sender {
    NSLog(@"下载图片2");
    self.iconTwoimageView.image = [self getImage:[self requestDataUrl:@"http://img2.pconline.com.cn/pconline/0706/19/1038447_34.jpg"]];
}


/**
 *  下载图片
 *
 *  @return
 */
- (NSData *)requestDataUrl:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data;
}


/**
 *  获取图片
 *
 *  @param data data
 *
 *  @return UIImage
 */
- (UIImage *)getImage:(NSData *)data {
   return [UIImage imageWithData:data];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
