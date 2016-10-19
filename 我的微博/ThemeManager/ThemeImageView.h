//
//  ThemeImageView.h
//  我的微博
//
//  Created by Macx on 16/10/7.
//  Copyright © 2016年 无限. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

@property(nonatomic,copy) NSString *imageName;


//拉伸点
@property(nonatomic,assign) CGFloat leftCapWidth;
@property(nonatomic,assign) CGFloat topCapHeight;

@end
