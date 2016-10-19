//
//  BaseViewController.m
//  我的微博
//
//  Created by Macx on 16/9/29.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景
    [self setBackground];
    
    //设置返回按钮
    [self createBackButton];
    
}
-(void)createBackButton{
    if (self.navigationController.viewControllers.count >= 2) {
        ThemeButton *button = [[ThemeButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
        button.bgImageName = @"titlebar_button_back_9";
        [button setTitle:@" 更多" forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        self.navigationItem.leftBarButtonItem = btnItem;
    }
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setBackground{
    //利用imageView设置主题背景
    ThemeImageView *bgImageView = [[ThemeImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.imageName = @"bg_home.jpg";
    
    [self.view insertSubview:bgImageView atIndex:0];
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
