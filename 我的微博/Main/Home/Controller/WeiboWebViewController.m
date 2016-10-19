//
//  WeiboWebViewController.m
//  我的微博
//
//  Created by Macx on 16/10/15.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "WeiboWebViewController.h"

@interface WeiboWebViewController ()

@end

@implementation WeiboWebViewController

-(instancetype)initWithUrl:(NSURL *)url{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}






- (void)viewDidLoad {
    [super viewDidLoad];
    //创建webview
    UIWebView *webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    [self.view addSubview:webView];
    
    //加载数据
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:self.url];
    [webView loadRequest:request];
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
