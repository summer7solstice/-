//
//  ThemeLabel.m
//  我的微博
//
//  Created by Macx on 16/10/10.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "ThemeLabel.h"

@implementation ThemeLabel

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //接收通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor) name:KThemeChangedNotiName object:nil];
    }
    return self;
}
-(void)awakeFromNib{
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor) name:KThemeChangedNotiName object:nil];
}
//移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//刷新颜色
-(void)setColorName:(NSString *)colorName{
    _colorName = colorName;
    [self changeColor];
}
-(void)changeColor{
    ThemeManager *manager = [ThemeManager shareManager];
    UIColor *newColor = [manager colorWithKeyInConfig:_colorName];
    
    self.textColor = newColor;
    
}
@end
