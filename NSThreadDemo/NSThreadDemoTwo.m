//
//  NSThreadDemoTwo.m
//  NSThreadDemo
//
//  Created by GongHui_YJ on 16/8/19.
//  Copyright © 2016年 杨建. All rights reserved.
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖保佑             永无BUG
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？

#import "NSThreadDemoTwo.h"
#import "ImageData.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10

@interface NSThreadDemoTwo() {
    NSMutableArray *_imageViews;
}

@end

@implementation NSThreadDemoTwo

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];

    [self layoutUI];

}

/**
 *  界面布局
 */
- (void)layoutUI {
    _imageViews = [NSMutableArray array];

    for (int r = 0; r < ROW_COUNT; r++) {
        for (int c = 0; c < COLUMN_COUNT; c++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(c * ROW_WIDTH + (c * CELL_SPACING), r * ROW_HEIGHT + (r * CELL_SPACING), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
        }
    }


    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 500, 220, 40);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loadImageWithMuliThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

/**
 *  讲图片显示到界面
 *
 *  @param imageData <#imageData description#>
 */
- (void)updateImage:(ImageData *)imageData {
    UIImage *image = [UIImage imageWithData:imageData.data];
    UIImageView *imageView = _imageViews[imageData.index];
    imageView.image = image;
}


/**
 *  请求图片数据
 *
 *  @param index
 *
 *  @return
 */
- (NSData *)requestData:(int)index {
    // 对非最后一张图片加载线程休眠2秒
    if (index!= ROW_COUNT *COLUMN_COUNT - 1) {
        [NSThread sleepForTimeInterval:2.0];
    }

    NSURL *url = [NSURL URLWithString:@"http://img2.pconline.com.cn/pconline/0706/19/1038447_34.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return  data;
}



/**
 *   加载图片
 *
 *  @param index 
 */
- (void)loadIamge:(NSNumber *)index {
    NSLog(@"current thread%@", [NSThread currentThread]); //取出当前操作线程
    int i = [index intValue];
    NSLog(@"%i", i); // 未必按顺序输出
    NSData *data = [self requestData:i];

    ImageData *imageData = [[ImageData alloc] init];
    imageData.index = i;
    imageData.data = data;

    // 主线程刷新
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];


}

/**
 *  多线程下载图片
 */
- (void)loadImageWithMuliThread {
    for (int i = 0; i < ROW_COUNT * COLUMN_COUNT; i++) {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadIamge:) object:[NSNumber numberWithInt:i]];
        thread.name = [NSString stringWithFormat:@"myThread%i", i]; // 设置线程的名字
        [thread start];
    }
}



@end
