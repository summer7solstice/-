//
//  ThemeButton.m
//  我的微博
//
//  Created by Macx on 16/10/10.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "ThemeButton.h"

@implementation ThemeButton

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //接受通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImageAction) name:KThemeChangedNotiName object:nil];
    }
    return self;
}
-(void)awakeFromNib{
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImageAction) name:KThemeChangedNotiName object:nil];
    
}
//移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)changeImageAction{
    //获取到manager
    ThemeManager *manager = [ThemeManager shareManager];
    
    UIImage *image = [manager changeThemeWithImageName:_imageName];
    UIImage *bgImage = [manager changeThemeWithImageName:_bgImageName];
    
    //设置image
    [self setImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:bgImage forState:UIControlStateNormal];
    
}

-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [self changeImageAction];
}

-(void)setBgImageName:(NSString *)bgImageName{
    _bgImageName = bgImageName;
    [self changeImageAction];
}
@end
