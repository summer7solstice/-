//
//  DiscoverViewController.m
//  我的微博
//
//  Created by Macx on 16/9/29.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearbyWeiboViewController.h"

@class NearbyWeiboViewController;
@interface DiscoverViewController ()

@end

@implementation DiscoverViewController
- (IBAction)nearbyWeibo:(UIButton *)sender {
    NearbyWeiboViewController *nearbyVc = [[NearbyWeiboViewController alloc]init];
    
    nearbyVc.hidesBottomBarWhenPushed = YES; 
    [self.navigationController pushViewController:nearbyVc animated:YES];
}

- (IBAction)nearbyUsers:(UIButton *)sender {
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
