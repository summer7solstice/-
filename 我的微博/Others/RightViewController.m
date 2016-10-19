//
//  RightViewController.m
//  我的微博
//
//  Created by Macx on 16/10/11.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "RightViewController.h"
#import "SendWeiboViewController.h"
#import "BaseNavigationController.h"
#import "UIViewController+MMDrawerController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setbackground];
    
    [self createButtons];
}
-(void)createButtons{
    CGFloat buttonWidth = 50;
    CGFloat gap = 15;
    for (NSInteger i = 0; i < 5; i ++) {
        ThemeButton *button = [[ThemeButton alloc]init];
        CGRect frame = CGRectMake(gap, i * (buttonWidth + gap) + gap, buttonWidth, buttonWidth);
        button.frame = frame;
        button.imageName = [NSString stringWithFormat:@"newbar_icon_%li",i+1];
        button.tag = 100 + i;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    //下面两个按钮
    UIButton *qrButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qrButton.frame = CGRectMake(gap, KScreenHeight - 64 - (gap + buttonWidth), buttonWidth, buttonWidth);
    [qrButton setImage:[UIImage imageNamed:@"qr_btn.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:qrButton];
    
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = CGRectMake(gap, KScreenHeight - 64 - (gap + buttonWidth) * 2, buttonWidth, buttonWidth);
    [mapBtn setImage:[UIImage imageNamed:@"btn_map_location.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:mapBtn];

    
}

-(void)buttonAction:(ThemeButton *)btn{
    if (btn.tag == 100) {
        SendWeiboViewController *sendVc = [[SendWeiboViewController alloc]init];
        BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:sendVc];
        [self presentViewController:navi animated:YES completion:^{
            MMDrawerController *mmd = self.mm_drawerController;
            //关闭侧边栏
            [mmd closeDrawerAnimated:YES completion:nil];
        }];
    }
}
-(void)setbackground{
    //利用imageView设置主题背景
    ThemeImageView *bgImageView = [[ThemeImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.imageName = @"mask_bg.jpg";
    
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
