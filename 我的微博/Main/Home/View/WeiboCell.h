//
//  WeiboCell.h
//  我的微博
//
//  Created by Macx on 16/10/11.
//  Copyright © 2016年 无限. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WXLabel;
@interface WeiboCell : UITableViewCell 

@property(nonatomic,strong) WeiboModel *weibo;

//原创微博
@property(nonatomic,strong) WXLabel             *weiboTextLabel;

//九宫格imageView的存放数组
@property(nonatomic,strong) NSArray             *imageViewArr;
//转发微博
@property(nonatomic,strong) WXLabel             *repostWeiboTextLabel;
@property(nonatomic,strong) ThemeImageView      *repostWeiboBGImageView;

@end
