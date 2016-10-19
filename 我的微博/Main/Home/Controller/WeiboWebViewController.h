//
//  WeiboWebViewController.h
//  我的微博
//
//  Created by Macx on 16/10/15.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "BaseViewController.h"

@interface WeiboWebViewController : BaseViewController

@property(nonatomic,strong) NSURL   *url;

-(instancetype)initWithUrl:(NSURL *)url;
@end
