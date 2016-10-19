//
//  BaseTabBarController.m
//  我的微博
//
//  Created by Macx on 16/9/29.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

#pragma mark - 初始化
-(instancetype)init{
    self = [super init];
    if (self) {
        //创建子控制器
        [self createSubviewControllers];
        
        //自定义标签栏
        [self custumTabBar];
    }
    return self;
}
//创建子控制器
-(void)createSubviewControllers{
    //读取故事板 获取控制器navi(循环添加)
    NSArray *storyboardNames = @[@"Home",
                                 @"Message",
                                 @"Discover",
                                 @"Profile",
                                 @"More"];
    //viewControllers数组
    NSMutableArray *storyboardArr = [NSMutableArray array];
    
    for (NSString *name in storyboardNames) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:[NSBundle mainBundle]];
        //返回入口控制器
        UINavigationController *navi = [storyboard instantiateInitialViewController];
        
        [storyboardArr addObject:navi];
    }
    //将控制器添加进tabBar的viewControllers中
    self.viewControllers = storyboardArr; 
}

//自定义标签栏
-(void)custumTabBar{
    //背景
    ThemeImageView *bgImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, -5, KScreenWidth, 54)];
    bgImageView.imageName = @"mask_navbar@2x";
    
    [self.tabBar insertSubview:bgImageView atIndex:0];
    
     //删除原有的按钮
    for (UIView *view in self.tabBar.subviews) {
        //判断是否为标签栏按钮
        Class tabBarBtn = NSClassFromString(@"UITabBarButton");
        
        if ([view isKindOfClass:tabBarBtn]) {
            [view removeFromSuperview];
        }
    }
    //添加自定义图片
    //图片名称数组
    NSArray *tabIconNames = @[@"home_tab_icon_1@2x",
                              @"home_tab_icon_2@2x",
                              @"home_tab_icon_3@2x",
                              @"home_tab_icon_4@2x",
                              @"home_tab_icon_5@2x",];
    //button宽度
    CGFloat buttonWidth = KScreenWidth / 5;
    
    for (NSInteger i = 0; i < 5; i ++) {
        //创建button
        ThemeButton *button = [ThemeButton buttonWithType:UIButtonTypeCustom];
        //添加tag值
        button.tag = 200 + i;
        CGRect frame = CGRectMake(buttonWidth * i, 0, buttonWidth, 49);
        button.frame = frame;
        
        //设置图片
        button.imageName = tabIconNames[i];
        //添加图片
        [self.tabBar addSubview:button];
        
        //实现点击切换
        [button addTarget:self action:@selector(tabBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    //选中框
    _arrowImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, 49)];
    _arrowImageView.imageName = @"home_bottom_tab_arrow@2x";
    //添加选中框
    [self.tabBar insertSubview:_arrowImageView atIndex:1];
    
    //标签栏阴影
    self.tabBar.shadowImage = [[UIImage alloc]init];
    
}
//切换
-(void)tabBarButtonAction:(UIButton *)btn{
    self.selectedIndex = btn.tag - 200;
    
    //选中框对齐(动画)
    [UIView animateWithDuration:.2 animations:^{
        _arrowImageView.center = btn.center;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
