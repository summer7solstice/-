//
//  EmoticonViews.h
//  我的微博
//
//  Created by Macx on 16/10/22.
//  Copyright © 2016年 无限. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KEmoticonWidth (KScreenWidth / 8)
#define KScrollViewHeight (KEmoticonWidth * 4)
#define KPageCtrHeight (20)


@interface EmoticonViews : UIView<UIScrollViewDelegate>
{
    //模型数组
    NSArray *_emoticonModelArr;
    //页码显示器
    UIPageControl *_pageCtr;
}

@end
