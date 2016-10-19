//
//  WeiboCellLayout.h
//  我的微博
//
//  Created by Macx on 16/10/13.
//  Copyright © 2016年 无限. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CellTopHeight (60)
#define GapHeightOrWidth (10)
#define ImageViewHeight (200)
#define ImageViewWidth (200)
#define GapBetweenImage (5)

@interface WeiboCellLayout : NSObject{
    
    CGFloat _cellHeight;
    
    
}

//输入
@property(nonatomic,strong) WeiboModel *weibo;
+(instancetype)layoutWithWeiboModel:(WeiboModel*)weibo;

//输出
@property(nonatomic,assign,readonly) CGRect weiboTextFrame;        //正文text frame

@property(nonatomic,strong,readonly) NSArray *imageFrameArr;         //九个图片的frame数组

//转发微博输出
@property(nonatomic,assign,readonly) CGRect repostWeiboTextFrame;  //转发微博正文
@property(nonatomic,assign,readonly) CGRect repostWeiboImageFrame;  //转发微博图片
@property(nonatomic,assign,readonly) CGRect repostWeiboBGImageFrame; //转发微博背景




//cell总高度
-(CGFloat)cellHeight;
@end
