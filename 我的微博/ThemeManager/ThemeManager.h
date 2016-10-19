//
//  ThemeManager.h
//  我的微博
//
//  Created by Macx on 16/10/7.
//  Copyright © 2016年 无限. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ThemeImageView.h"
#import "ThemeButton.h"
#import "ThemeLabel.h"

@interface ThemeManager : NSObject

@property(nonatomic,copy) NSString *currentThemeName;//当前主题
@property(nonatomic,copy) NSDictionary *themeDic;//存放主题的字典
@property(nonatomic,copy) NSDictionary *colorConfigDic;//字体颜色配置
//单例manager
+(ThemeManager*)shareManager;

-(UIImage *)changeThemeWithImageName:(NSString *)imageName;

-(UIColor *)colorWithKeyInConfig:(NSString *)keyName;

@end
