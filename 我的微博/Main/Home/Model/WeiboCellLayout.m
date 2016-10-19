//
//  WeiboCellLayout.m
//  我的微博
//
//  Created by Macx on 16/10/13.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "WeiboCellLayout.h"
#import "WXLabel.h"

@class WXLabel;
@implementation WeiboCellLayout
+(instancetype)layoutWithWeiboModel:(WeiboModel *)weibo{
    WeiboCellLayout *layout = [[WeiboCellLayout alloc]init];
    if (layout) {
        layout.weibo = weibo;
    }
    return layout;
}

-(void)setWeibo:(WeiboModel *)weibo{
    if (_weibo == weibo) {
        return;
    }
    _weibo = weibo;
    
    //初始化cellHeight
    _cellHeight = 0;
    //top高度
    _cellHeight += CellTopHeight;
    //间隙
    _cellHeight += GapHeightOrWidth;
    
    //计算frame
    //----------------------原创微博------------------------
        //1.微博text
    CGFloat textHeight = [WXLabel getTextHeight:KWeiboTextFont.pointSize
                                          width:KScreenWidth - 2*GapHeightOrWidth
                                           text:_weibo.text
                                      linespace:KLineSpace];
    textHeight += 2;
    
    _weiboTextFrame = CGRectMake(GapHeightOrWidth, CellTopHeight + GapHeightOrWidth,KScreenWidth - 2*GapHeightOrWidth, textHeight);
    //正文高度
    _cellHeight += textHeight;
    //间隙
    _cellHeight += GapHeightOrWidth;
    
        //2.微博Image
    if (_weibo.pic_urls.count > 0) {
        CGFloat imgHeight = [self layoutNineImageFrameWithImageCount:_weibo.pic_urls.count totalWith:(KScreenWidth - 2 * GapHeightOrWidth) topY:CGRectGetMaxY(_weiboTextFrame) + GapHeightOrWidth];
        
        //图片高度
        _cellHeight += imgHeight;
        //间隙
        _cellHeight += GapHeightOrWidth;
    }else{
        _imageFrameArr = nil;
    }
    
    
    //----------------------转发微博------------------------
    if (_weibo.retweeted_status ) {
        //1.微博text
        CGFloat reTextHeight = [WXLabel getTextHeight:KRepostWeiboTextFont.pointSize
                                                width:KScreenWidth - 4*GapHeightOrWidth
                                                 text:_weibo.retweeted_status.text
                                            linespace:KLineSpace];
        reTextHeight += 2;
    _repostWeiboTextFrame = CGRectMake(2 * GapHeightOrWidth, _cellHeight, KScreenWidth - 4 * GapHeightOrWidth, reTextHeight);

    _cellHeight += reTextHeight;
    _cellHeight += GapHeightOrWidth;
    
        //2.微博图片
        CGFloat repostImgHeight;
        if (_weibo.retweeted_status.pic_urls.count > 0) {
            repostImgHeight = [self layoutNineImageFrameWithImageCount:_weibo.retweeted_status.pic_urls.count totalWith:(_repostWeiboTextFrame.size.width - 2 * GapHeightOrWidth) topY:CGRectGetMaxY(_repostWeiboTextFrame) + GapHeightOrWidth];
            //高度
            _cellHeight += repostImgHeight;
            //间隙
            _cellHeight += GapHeightOrWidth + 1.5 * GapHeightOrWidth;
            
            //3-1 有微博图片时背景图片图片高度
            _repostWeiboBGImageFrame = CGRectMake(GapHeightOrWidth, _repostWeiboTextFrame.origin.y - GapHeightOrWidth, KScreenWidth - 2 * GapHeightOrWidth, _repostWeiboTextFrame.size.height + repostImgHeight + 2 * GapHeightOrWidth + 1.5 * GapHeightOrWidth);
        }else{

            _imageFrameArr = nil;
            //3-2 无微博图片时背景图片高度 相对于上面不加
            _repostWeiboBGImageFrame = CGRectMake(GapHeightOrWidth, _repostWeiboTextFrame.origin.y - GapHeightOrWidth, KScreenWidth - 2 * GapHeightOrWidth, _repostWeiboTextFrame.size.height + repostImgHeight + 1.5 * GapHeightOrWidth );
        }
        
    }else{
        _repostWeiboTextFrame = CGRectZero;
        _repostWeiboBGImageFrame = CGRectZero;
    }
    
    
}


-(CGFloat)cellHeight{
    return _cellHeight;
}


#pragma mark - 九宫格布局
-(CGFloat)layoutNineImageFrameWithImageCount:(NSInteger)imageCount
                                   totalWith:(CGFloat)totalWith
                                        topY:(CGFloat)topY
//                                       weibo:(WeiboModel*)weibo
{
    //数量是否合法
    if (imageCount >= 9 || imageCount <= 0) {
        _imageFrameArr = nil;
        return 0;
    }
    
    //image宽高
    CGFloat imageWith;
    CGFloat totalHeight;
    //列数/每行有几个
    NSInteger numberOfColum;
    
    
    //一行
    if (imageCount == 1) {              //一列
        numberOfColum = 1;
        imageWith = totalWith * 0.6;
        totalHeight = imageWith;
    }else if (imageCount == 2){         //两列
        numberOfColum = 2;
        imageWith = (totalWith - GapBetweenImage) / 2;
        totalHeight = imageWith;
    }else if (imageCount == 3){         //三列
        numberOfColum = 3;
        imageWith = (totalWith - 2 * GapBetweenImage) / 3;
        totalHeight = imageWith;
    }
    //两行
    else if (imageCount == 4){          //两列
        numberOfColum = 2;
        imageWith = (totalWith - GapBetweenImage) / 2;
        totalHeight = totalWith;
    }else if (imageCount == 5 || imageCount == 6){         //三列
        numberOfColum = 3;
        imageWith = (totalWith - 2 * GapBetweenImage) / 3;
        totalHeight = 2 * imageWith + GapBetweenImage;
    }
    //三行
    else {                              //三列 7,8,9
        numberOfColum = 3;
        imageWith = (totalWith - 2 * GapBetweenImage) / 3;
        totalHeight = totalWith;
    }
    
    
    //循环生成每个Image的frame
    NSMutableArray *frameArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 9; i ++) {
        //图片不足9个时
        if (i >= imageCount) {
            CGRect voidFrame = CGRectZero;
            [frameArr addObject:[NSValue valueWithCGRect:voidFrame]];
        }else{
            //创建frame
            NSInteger row = i / numberOfColum;
            NSInteger colum = i % numberOfColum;
            CGFloat left = (KScreenWidth - totalWith) / 2;
            
            
            CGRect frame = CGRectMake(colum * (imageWith + GapBetweenImage) + left, row * (imageWith + GapBetweenImage) + topY, imageWith, imageWith);
            
            [frameArr addObject:[NSValue valueWithCGRect:frame]];
        }
        
        
    }
    _imageFrameArr = [frameArr copy];
    
    return totalHeight;
}

@end
