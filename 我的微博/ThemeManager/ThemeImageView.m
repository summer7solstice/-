//
//  ThemeImageView.m
//  我的微博
//
//  Created by Macx on 16/10/7.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "ThemeImageView.h"

@implementation ThemeImageView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        self.leftCapWidth = 0; //不拉伸
        self.topCapHeight = 0; //不拉伸
        //监听主题改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange) name:KThemeChangedNotiName object:nil];
    }
    return self;
}
//storyboard上直接画的imageView 如此监听
-(void)awakeFromNib{
    //初始化
    self.leftCapWidth = 0; //不拉伸
    self.topCapHeight = 0; //不拉伸
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange) name:KThemeChangedNotiName object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setImageName:(NSString *)imageName{
    _imageName = [imageName copy];
    
    //进行刷新操作
    [self themeChange];
}

//切换图片时  进行刷新
-(void)themeChange{
    //获取manager对象
    ThemeManager *manager = [ThemeManager shareManager];
    
    UIImage *image = [manager changeThemeWithImageName:_imageName];
    
    //图片拉伸操作
    image = [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    
    self.image = image;
}
//重新设置拉伸点时进行刷新
-(void)setLeftCapWidth:(CGFloat)leftCapWidth{
    _leftCapWidth = leftCapWidth;
    [self themeChange];
}
-(void)setTopCapHeight:(CGFloat)topCapHeight{
    _topCapHeight = topCapHeight;
    [self themeChange];
}

@end
