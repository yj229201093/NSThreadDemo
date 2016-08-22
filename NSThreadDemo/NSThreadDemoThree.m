//
//  NSThreadDemoThree.m
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

#import "NSThreadDemoThree.h"
#import "ImageData.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10
#define IMAGE_COUNT 15




@interface NSThreadDemoThree () {
    NSMutableArray *_imageViews;
    NSMutableArray *_imageNames;
    NSMutableArray *_threads;
}

@end

@implementation NSThreadDemoThree

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutUI];

}

/**
 *  创建布局
 */
-(void)layoutUI{
    //创建多个图片空间用于显示图片
    _imageViews=[NSMutableArray array];
    for (int r=0; r<ROW_COUNT; r++) {
        for (int c=0; c<COLUMN_COUNT; c++) {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING                           ), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];

        }
    }

    //加载按钮
    UIButton *buttonStart=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStart.frame=CGRectMake(50, 500, 100, 25);
    [buttonStart setTitle:@"加载图片" forState:UIControlStateNormal];
    [buttonStart addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonStart];

    //停止按钮
    UIButton *buttonStop=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStop.frame=CGRectMake(160, 500, 100, 25);
    [buttonStop setTitle:@"停止加载" forState:UIControlStateNormal];
    [buttonStop addTarget:self action:@selector(stopLoadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonStop];

    //创建图片链接
    _imageNames=[NSMutableArray array];
//    [_imageNames addObject:[NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg",1]];
//    [_imageNames addObject:@
     for (int i=0; i<IMAGE_COUNT; i++) {
        [_imageNames addObject:[NSString stringWithFormat:@"http://img2.pconline.com.cn/pconline/0706/19/1038447_34.jpg"]];
    }    
}

#pragma mark 将图片显示到界面
-(void)updateImage:(ImageData *)imageData{
    UIImage *image=[UIImage imageWithData:imageData.data];
    UIImageView *imageView= _imageViews[imageData.index];
    imageView.image=image;
}

#pragma mark 请求图片数据
-(NSData *)requestData:(int )index{
    NSURL *url=[NSURL URLWithString:_imageNames[index]];
    NSData *data=[NSData dataWithContentsOfURL:url];

    return data;
}



#pragma mark 加载图片
-(void)loadImage:(NSNumber *)index{
    int i=[index intValue];

    NSData *data= [self requestData:i];


    NSThread *currentThread=[NSThread currentThread];

    //    如果当前线程处于取消状态，则退出当前线程
    if (currentThread.isCancelled) {
        NSLog(@"thread(%@) will be cancelled!",currentThread);
        [NSThread exit];//取消当前线程
    }

    ImageData *imageData=[[ImageData alloc]init];
    imageData.index=i;
    imageData.data=data;
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];
}


/**
 *  加载图片
 */
- (void)loadImageWithMultiThread {
    int count=ROW_COUNT*COLUMN_COUNT;
    _threads=[NSMutableArray arrayWithCapacity:count];

    //创建多个线程用于填充图片
    for (int i=0; i<count; ++i) {
        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInt:i]];
        thread.name=[NSString stringWithFormat:@"myThread%i",i];//设置线程名称
        [_threads addObject:thread];
    }
    //循环启动线程
    for (int i=0; i<count; ++i) {
        NSThread *thread= _threads[i];
        [thread start];
    }
}

/**
 *  停止线程
 */
- (void)stopLoadImage {
    for (int i=0; i<ROW_COUNT*COLUMN_COUNT; i++) {
        NSThread *thread= _threads[i];
        //判断线程是否完成，如果没有完成则设置为取消状态
        //注意设置为取消状态仅仅是改变了线程状态而言，并不能终止线程
        if (!thread.isFinished) {
            [thread cancel];

        }
    }
}


@end
