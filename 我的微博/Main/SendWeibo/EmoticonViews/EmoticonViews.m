//
//  EmoticonViews.m
//  我的微博
//
//  Created by Macx on 16/10/22.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "EmoticonViews.h"
#import "EmoticonModel.h"
#import "YYModel.h"
#import "EmoView.h"


@class EmoticonModel;
@implementation EmoticonViews
-(instancetype)initWithFrame:(CGRect)frame{
    frame.size.height = KScrollViewHeight + KPageCtrHeight;
    frame.size.width = KScreenWidth;
    self = [super initWithFrame:frame];
    if (self) {
        [self loadEmoticonData];
        
        [self createScrollView];
    }
    return self;
}
-(void)loadEmoticonData{
    //读取文件
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:filepath];
    NSMutableArray *emoArr = [NSMutableArray array];
    
    for (NSDictionary *dic in arr) {
        EmoticonModel *model = [EmoticonModel yy_modelWithJSON:dic];
        [emoArr addObject:model];
    }
    _emoticonModelArr = [emoArr mutableCopy];
}

-(void)createScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScrollViewHeight)];
    [self addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    //创建内容视图
    NSInteger pages = (_emoticonModelArr.count - 1) / 32 + 1;
    for (int i = 0; i < pages; i ++) {
        CGRect frame = CGRectMake(i * KScreenWidth, 0, KScreenWidth, KScrollViewHeight);
        EmoView *view = [[EmoView alloc]initWithFrame:frame];
        view.backgroundColor = [UIColor clearColor];
        [scrollView addSubview:view];
        
        NSRange range = NSMakeRange(i * 32, 32);
        if (i == pages - 1) {
            //最后一页
            range.length = _emoticonModelArr.count - 32 * (pages - 1);
            
        }
        //每一页的数据数组
        NSArray *arr = [_emoticonModelArr subarrayWithRange:range];
        view.emoticonArr = [arr copy];
    }
    
    scrollView.contentSize = CGSizeMake(pages * KScreenWidth, KScrollViewHeight);
    
    //页码显示器
    
    _pageCtr = [[UIPageControl alloc]initWithFrame:CGRectMake(0, KScrollViewHeight, KScreenWidth, KPageCtrHeight)];
    _pageCtr.numberOfPages = pages;
    _pageCtr.currentPage = 0;
    
    [self addSubview:_pageCtr];
    scrollView.delegate = self;
}

//监听滑动
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGFloat x = targetContentOffset->x;
    NSInteger pageNumber = x / KScreenWidth;
    
    _pageCtr.currentPage = pageNumber;
}
@end
