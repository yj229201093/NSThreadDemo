//
//  ImageData.h
//  NSThreadDemo
//
//  Created by GongHui_YJ on 16/8/19.
//  Copyright © 2016年 YangJian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageData : NSObject

// 索引
@property (assign, nonatomic) int index;

// 图片数据
@property (strong, nonatomic) NSData *data;

@end
