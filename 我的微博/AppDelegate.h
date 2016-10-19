//
//  AppDelegate.h
//  我的微博
//
//  Created by Macx on 16/9/29.
//  Copyright © 2016年 无限. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) SinaWeibo *sinaWeibo;

-(void)logoutSinaWeibo;
@end

