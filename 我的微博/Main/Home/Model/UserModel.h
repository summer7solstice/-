//
//  UserModel.h
//  我的微博
//
//  Created by Macx on 16/10/11.
//  Copyright © 2016年 无限. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property(nonatomic,copy) NSString  *idstr;                //str类型的用户id
@property(nonatomic,copy) NSString  *screen_name;          //用户昵称
@property(nonatomic,copy) NSString  *name;                 //用户微博名
@property(nonatomic,copy) NSString  *location;             //所在地
@property(nonatomic,copy) NSString  *myDescription;        //用户描述

@property(nonatomic,copy) NSURL     *url;                  //用户微博地址
@property(nonatomic,copy) NSURL     *profile_image_url;    //用户头像地址
@property(nonatomic,copy) NSURL     *avatar_large;         //用户大头像地址
@property(nonatomic,copy) NSString  *gender;               //用户性别:m男 f女


@property(nonatomic,strong) NSNumber *followers_count;     //粉丝数目
@property(nonatomic,strong) NSNumber *friends_count;       //关注数目
@property(nonatomic,strong) NSNumber *statuses_count;      //微博数
@property(nonatomic,strong) NSNumber *favourites_count;    //收藏数
@property(nonatomic,strong) NSNumber *verified;            //是否为认证用户

@end
