//
//  MyAnnoView.m
//  我的微博
//
//  Created by Macx on 16/10/19.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "MyAnnoView.h"
#import "Annotation.h"
@implementation MyAnnoView

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        //创建标注视图
        [self createIconView];
    }
    return self;
}
-(void)createIconView{
    //背景视图
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    bgImgView.image = [UIImage imageNamed:@"nearby_map_people_bg.png"];
    [self addSubview:bgImgView];
    //头像视图
    UIImageView *iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 50, 50)];
    iconImgView.layer.cornerRadius = 3;
    iconImgView.layer.masksToBounds = YES;
    
    
    [bgImgView addSubview:iconImgView];
    
    //改变地图大小,使标注图片相对不移动
    bgImgView.frame = CGRectMake(-35, -70, 70, 70);
    
    [self addSubview:bgImgView];
    
    //设置用户头像
    Annotation *anno = self.annotation;
    WeiboModel *model = anno.weiboModel;
    NSURL *url = model.user.profile_image_url;
    [iconImgView sd_setImageWithURL:url];
    
}
@end
