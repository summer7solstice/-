//
//  WeiboModel.h
//  我的微博
//
//  Created by Macx on 16/10/11.
//  Copyright © 2016年 无限. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@interface WeiboModel : NSObject
@property(nonatomic,copy) NSString *created_at;       //发布时间
@property(nonatomic,copy) NSString *idstr;            //微博id
@property(nonatomic,copy) NSString *text;             //微博文本内容
@property(nonatomic,copy) NSString *source;           //微博来源

@property(nonatomic,copy) NSURL    *thumbnail_pic;    //缩略图
@property(nonatomic,copy) NSURL    *bmiddle_pic;      //中等尺寸缩略图
@property(nonatomic,copy) NSURL    *original_pic;     //原图(大图)
@property(nonatomic,copy) NSArray  *pic_urls;         //缩略图数组地址
@property(nonatomic,copy) NSDictionary *geo;          //位置信息

@property(nonatomic,assign) NSInteger reposts_count;  //转发数
@property(nonatomic,assign) NSInteger comments_count; //评论数
@property(nonatomic,assign) NSInteger attitudes_count;//点赞数

@property(nonatomic,strong) UserModel *user;          //发微博的用户
@property(nonatomic,strong) WeiboModel *retweeted_status; //被转发的微博



@end
