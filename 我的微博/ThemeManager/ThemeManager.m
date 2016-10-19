//
//  ThemeManager.m
//  我的微博
//
//  Created by Macx on 16/10/7.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "ThemeManager.h"

#define KCurrentThemeNameKey @"KCurrentThemeNameKey"

@implementation ThemeManager

#pragma mark - 管理者单例创建
+(ThemeManager*)shareManager{
    static ThemeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[super allocWithZone:nil]init];
            
        }
    });
    return manager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self shareManager];
}

-(id)copy{
    return self;
}
-(instancetype)init{
    //读取theme.plist文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
    _themeDic = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    
    //读取保存的主题
    NSString *savedThemeName = [[NSUserDefaults standardUserDefaults] objectForKey:KCurrentThemeNameKey];
    if (savedThemeName) {
        _currentThemeName = savedThemeName;
    }else{
    //默认主题名
    _currentThemeName = _themeDic.allKeys[0];
    }
    
    //加载字体颜色配置
    [self loadColorConfig];
    
    return self;
}
#pragma mark - 主题切换实现
-(void)setCurrentThemeName:(NSString *)currentThemeName{
    if (![_currentThemeName isEqualToString:currentThemeName]) {
        _currentThemeName = [currentThemeName copy];
        
        //保存当前主题名
        NSString *savedThemeName = _currentThemeName;
        [[NSUserDefaults standardUserDefaults] setObject:savedThemeName forKey:KCurrentThemeNameKey];
        
        //刷新字体颜色配置
        [self loadColorConfig];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KThemeChangedNotiName object:nil];
    }
}
#pragma mark - 获取图片
-(UIImage *)changeThemeWithImageName:(NSString *)imageName{
    NSString *imagePathName = [NSString stringWithFormat:@"%@/%@",_themeDic[_currentThemeName],imageName];
    
    UIImage *image = [UIImage imageNamed:imagePathName];
    
    return image;

}


#pragma mark - 字体颜色设置
//加载配置文件config
-(void)loadColorConfig{
    //包的文件目录
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    //config的文件目录
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/config.plist",bundlePath,_themeDic[_currentThemeName]];
    
    //取到config中的dic
    _colorConfigDic = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    
}

//从configDic中获取颜色
-(UIColor *)colorWithKeyInConfig:(NSString *)keyName{
    NSDictionary *rgbDic = [_colorConfigDic objectForKey:keyName];
    
    CGFloat red = [[rgbDic objectForKey:@"R"] doubleValue];
    CGFloat green = [[rgbDic objectForKey:@"G"] doubleValue];
    CGFloat blue = [[rgbDic objectForKey:@"B"] doubleValue];
    
    UIColor *myColor = [[UIColor alloc]initWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
    
    return myColor;
}
@end
