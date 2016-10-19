//
//  MoreViewController.m
//  我的微博
//
//  Created by Macx on 16/9/29.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "MoreViewController.h"
#import "AppDelegate.h"

@interface MoreViewController (){
    
    IBOutlet UITableView *_tableView;
}

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置图标图片名
    icon0.imageName = @"more_icon_theme.png";
    icon1.imageName = @"more_icon_feedback.png";
    icon2.imageName = @"more_icon_draft.png";
    icon3.imageName = @"more_icon_about.png";
    
    //设置字体颜色
    _themeNameLabel.colorName = KMoreItemTextColor;
    themeChangeLabel.colorName = KMoreItemTextColor;
    feedbackLabel.colorName = KMoreItemTextColor;
    draftLabel.colorName = KMoreItemTextColor;
    aboutLabel.colorName = KMoreItemTextColor;
    cacheLabel.colorName = KMoreItemTextColor;
    
    [self setBackground];
    [self countCacheSize];
    
    ThemeManager *manager = [ThemeManager shareManager];
    _themeNameLabel.text = manager.currentThemeName;

    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeThameName) name:KThemeChangedNotiName object:nil];
}
//移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)changeThameName{
    ThemeManager *manager = [ThemeManager shareManager];
    
    _themeNameLabel.text = manager.currentThemeName;
}

//设置背景
-(void)setBackground{
    //利用imageView设置主题背景
    ThemeImageView *bgImageView = [[ThemeImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.imageName = @"bg_home.jpg";
    
    [self.view insertSubview:bgImageView atIndex:0];
}

#pragma mark - 缓存清理
-(void)countCacheSize{
    //byte kb MB GB TB
    NSUInteger fileSize = [[SDImageCache sharedImageCache]getSize];
    
    cacheLabel.text = [NSString stringWithFormat:@"%.1f MB",fileSize / 1024 / 1024.0];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //清除缓存
    if (cell.tag == 102) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"清理缓存"
                                        message:nil
                                        delegate:self
                                cancelButtonTitle:@"取消"
                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    //登出微博
    if (cell.tag == 104) {
        //登出微博
//        UIApplication *app = [UIApplication sharedApplication];
//        AppDelegate *delegate = (AppDelegate *)app.delegate;
//        NSLog(@"登出");
//        [delegate.sinaWeibo logOut];
        SinaWeibo *weibo = KSinaWeiboOBJ;
        [weibo logOut];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[SDImageCache sharedImageCache]clearDisk];
        
        [self countCacheSize];
    }
}

#pragma mark -
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
