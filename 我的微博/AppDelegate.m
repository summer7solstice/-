//
//  AppDelegate.m
//  我的微博
//
//  Created by Macx on 16/9/29.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"

@class MMDrawerController;
@class LeftViewController;
@class RightViewController;
@class BaseNavigationController;

#define KWeiboAuthKey (@"KWeiboAuthKey")

@interface AppDelegate () <SinaWeiboDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //创建window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    //创建标签栏
    BaseTabBarController *tabBar = [[BaseTabBarController alloc]init];
    
    
    //------创建mmdController-----//
    LeftViewController *leftVc = [[LeftViewController alloc]init];
    RightViewController *rightVc = [[RightViewController alloc]init];
    
    BaseNavigationController *leftNavi = [[BaseNavigationController alloc]initWithRootViewController:leftVc];
    BaseNavigationController *rightNavi = [[BaseNavigationController alloc]initWithRootViewController:rightVc];
    
    MMDrawerController *mmd = [[MMDrawerController alloc]initWithCenterViewController:tabBar leftDrawerViewController:leftNavi rightDrawerViewController:rightNavi];
    
    
    //mmd属性设置
    mmd.maximumLeftDrawerWidth = 180;
    mmd.maximumRightDrawerWidth = 80;
    
    [mmd setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmd setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    self.window.rootViewController = mmd;
    
    //左右平移block
    [mmd setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMExampleDrawerVisualStateManager *mmdManager = [MMExampleDrawerVisualStateManager sharedManager];
        
        //获取block
        MMDrawerControllerDrawerVisualStateBlock block = [mmdManager drawerVisualStateBlockForDrawerSide:drawerSide];
        
        if (block) {
            block(drawerController,drawerSide,percentVisible);
        }
    }];
    
    
    
    //初始化SDK
    _sinaWeibo = [[SinaWeibo alloc]initWithAppKey:@"1013983988"
                                    appSecret:@"347a80f5ac111d547dbfbe9c1b48787f"
                                   appRedirectURI:@"http://www.baidu.com"
                                      andDelegate:self];
    
    //1.读取登录信息
    BOOL isLoged = [self readAuthData];
    //2.判断是否已经登录
    if (isLoged == NO) {
        //尚未登录,执行登录操作
        [self.sinaWeibo logIn];
    }
    
    return YES;
}

#pragma mark - 登录/登出
//登录成功
-(void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    NSLog(@"登录成功");
    //保存登录信息
    [self saveAuthData];
    
    //刷新微博
    MMDrawerController *mmd = (MMDrawerController *)self.window.rootViewController;
    UITabBarController *tabbar = (UITabBarController *)mmd.centerViewController;
    UINavigationController *navi = (UINavigationController *)[tabbar.viewControllers firstObject];
    
    HomeViewController *home = (HomeViewController *)navi.topViewController;
    
    [home loadWeiboData];
   
}
//登录失败
-(void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error{
    NSLog(@"登录失败");
}
//登出
-(void)logoutSinaWeibo{
    [_sinaWeibo logOut];
}
//登出之后
-(void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo{
    NSLog(@"微博已经登出");
    //删除本地登录信息
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault removeObjectForKey:KWeiboAuthKey];
    
    [_sinaWeibo logIn];
}

#pragma mark - 保存登录数据
-(void)saveAuthData{
    //token 令牌
    NSString *token = _sinaWeibo.accessToken;
    //uid userid
    NSString *uid = _sinaWeibo.userID;
    //认证过期时间
    NSDate *date = _sinaWeibo.expirationDate;
    
    //保存到本地磁盘
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dataDic = @{@"accessToken":token,
                              @"userID":uid,
                              @"expirationDate":date};
    [userDefault setObject:dataDic forKey:KWeiboAuthKey];
    
    NSLog(@"令牌:%@",token);
    //数据同步
    [userDefault synchronize];
}

//读取登录信息
-(BOOL)readAuthData{
    //拿到本地磁盘的数据
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *homeStr = NSHomeDirectory();
    NSLog(@"登出 : %@",homeStr);

    NSDictionary *dataDic = [userDefault objectForKey:KWeiboAuthKey];
    //读取信息
    if (dataDic == nil) {
        //本地无信息,重新登录
        return NO;
    }else{
        //获取信息
        NSString *token = dataDic[@"accessToken"];
        NSString *uid = dataDic[@"userID"];
        NSDate *date = dataDic[@"expirationDate"];
        
        if (token == nil || uid == nil || date == nil) {
            //本地信息损坏,重新登录
            return NO;
        }else{
            _sinaWeibo.accessToken = token;
            _sinaWeibo.userID = uid;
            _sinaWeibo.expirationDate = date;
            
             NSLog(@"令牌:%@",token);
            return YES;
        }
    }
    
}

#pragma mark -
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
