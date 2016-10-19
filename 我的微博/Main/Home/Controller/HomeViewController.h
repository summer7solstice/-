//
//  HomeViewController.h
//  我的微博
//
//  Created by Macx on 16/9/29.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController

@property(nonatomic,strong) UITableView *tableView;

-(void)reloadNewWeibo;
-(void)loadWeiboData;
@end
