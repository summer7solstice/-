//
//  BaseNavigationController.m
//  我的微博
//
//  Created by Macx on 16/10/6.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏背景
    [self setNaviBack];
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNaviBack) name:KThemeChangedNotiName object:nil];
    
    //设置字体大小和颜色
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:22]};
    
    //导航栏占位置,不透明
    self.navigationBar.translucent = NO;
    
}
//移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)setNaviBack{
    //判断系统版本
    CGFloat systemVersion = KSystemVersion;
    
    NSString *imageName;
    //mask_titlebar64@2x  mask_titlebar@2x
    if (systemVersion > 7.0) {
        imageName = @"mask_titlebar64";
    }else{
        imageName = @"mask_titlebar";
    }
    UIImage *image = [[ThemeManager shareManager] changeThemeWithImageName:imageName];
    
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

//状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
