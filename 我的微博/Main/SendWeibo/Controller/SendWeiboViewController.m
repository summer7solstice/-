//
//  SendWeiboViewController.m
//  我的微博
//
//  Created by Macx on 16/10/18.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "SendWeiboViewController.h"
#import "Appdelegate.h"
#import "LocationViewController.h"
#import "HomeViewController.h"

#define KToolViewHeight 40
#define KLocationViewHeight 18
#define KSendWeiboAPI (@"statuses/update.json")
#define KSendWeiboWithImageAPI (@"statuses/upload.json")

@class MBProgressHUD;
@interface SendWeiboViewController ()<SinaWeiboRequestDelegate>{
    UITextView *_inputTextView;    //输入框
    UIView *_toolView;             //工具栏
    
    //定位相关
    UIView *_locationView;
    UIImageView *_locationIcon;
    ThemeLabel *_locationLabel;
    ThemeButton *_locationCancelBtn;
}
@property(nonatomic,strong)NSDictionary *locationData;

@end

@implementation SendWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发微博";
    [self setBackground];
    
    [self createNaviButton];
    [self createInputView];
    [self createToolView];
    [self createLocationView];
}

-(void)createInputView{
        _inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - KToolViewHeight)];
        _inputTextView.backgroundColor = [UIColor clearColor];
        _inputTextView.font = [UIFont systemFontOfSize:18 ];
        _inputTextView.keyboardType = UIKeyboardTypeNamePhonePad;
    
    [self.view addSubview:_inputTextView];
    
    //监听键盘的弹出/收回通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
}
-(void)keyboardShow:(NSNotification*)noti{
    NSValue *value = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];
    [UIView animateWithDuration:.1 animations:^{
        _inputTextView.height = KScreenHeight - 64 - KToolViewHeight - keyboardFrame.size.height;
        _toolView.top = _inputTextView.bottom;
        _locationView.bottom = _toolView.top;

    }];
}
-(void)keyboardHide:(NSNotification*)noti{
    [UIView animateWithDuration:.1 animations:^{
        _inputTextView.height = KScreenHeight - 64 - KToolViewHeight;
        _toolView.top = _inputTextView.bottom;
        _locationView.bottom = _toolView.top;

    }];
}

-(void)setBackground{
    //利用imageView设置主题背景
    ThemeImageView *bgImageView = [[ThemeImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.imageName = @"bg_home.jpg";
    
    [self.view insertSubview:bgImageView atIndex:0];
}

-(void)createToolView{
        _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KToolViewHeight)];
        _toolView.top = _inputTextView.bottom;
        _toolView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_toolView];
    
    //创建toolview上的5个按钮
    CGFloat buttonWidth = KScreenWidth / 5;
    CGFloat buttonHeight = KToolViewHeight;
    for (NSInteger i = 0; i < 5; i ++) {
        ThemeButton *button = [ThemeButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(i * buttonWidth, 0, buttonWidth, buttonHeight);
        button.frame = frame;
        if (i == 0) {
            button.imageName = @"compose_toolbar_1";
        }else{
            button.imageName = [NSString stringWithFormat:@"compose_toolbar_%li",i + 2];
        }
        button.tag = 200 + i;
        [button addTarget:self action:@selector(toolViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:button];
    }
}
//创建定位相关视图
-(void)createLocationView{
    //父视图
    _locationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KLocationViewHeight)];
    
        [self.view addSubview:_locationView];
    _locationView.bottom = _toolView.top;
    _locationView.hidden = YES;
    
    //icon
    _locationIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, KLocationViewHeight, KLocationViewHeight)];
    
    [_locationView addSubview:_locationIcon];
    
    //label
    _locationLabel = [[ThemeLabel alloc]initWithFrame:CGRectMake(30, 0, 200, KLocationViewHeight)];
    
    _locationLabel.text = @"地址";
    [_locationView addSubview:_locationLabel];
    
    //btn
    _locationCancelBtn = [ThemeButton buttonWithType:UIButtonTypeCustom];
    _locationCancelBtn.frame = CGRectMake(0, 0, KLocationViewHeight, KLocationViewHeight);
    
    _locationCancelBtn.imageName = @"compose_toolbar_clear.png";
    _locationCancelBtn.left = _locationLabel.right;
    [_locationView addSubview:_locationCancelBtn];
    
    [_locationCancelBtn addTarget:self action:@selector(locationCancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)locationCancelButtonAction{
    self.locationData = nil;
}
-(void)createNaviButton{
    //取消
    ThemeButton *cancelButton = [ThemeButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 64, 44);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.bgImageName = @"titlebar_button_9.png";
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //发送
    ThemeButton *sendButton = [ThemeButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(0, 0, 64, 44);
    [sendButton setTitle:@"发送 " forState:UIControlStateNormal];
    sendButton.bgImageName = @"titlebar_button_9.png";
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 点击事件
-(void)toolViewBtnAction:(UIButton *)btn{
    if (btn.tag == 203) {
        //定位
        LocationViewController *locationVc = [[LocationViewController alloc]init];
        //设置block回调
        [locationVc addLocationResultBlock:^(NSDictionary *result) {
            //保存地理数据
            self.locationData = result;
        }];
        [self.navigationController pushViewController:locationVc animated:YES];
        
    }
    
}
-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [_inputTextView resignFirstResponder];
}
-(void)sendAction{
    //过滤字符串
    NSString *text = [_inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (text.length <=0) {
        //没有输入
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"警告" message:@"发送内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    //显示HUD
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithWindow:self.view.window];
    [self.view.window addSubview:hud];
    hud.labelText = @"正在发送";
    hud.dimBackground = YES;
    [hud show:YES];
    
    //获取微博对象
    SinaWeibo *weibo = KSinaWeiboOBJ;
    NSMutableDictionary *params = [@{@"status" : text} mutableCopy];
    if (self.locationData) {
        NSString *lon = self.locationData[@"lon"];
        NSString *lat = self.locationData[@"lat"];
        
        [params setObject:lon forKey:@"long"];
        [params setObject:lat forKey:@"lat"];
        
    }
//    [weibo requestWithURL:KSendWeiboAPI
//                   params:params
//               httpMethod:@"POST"
//                 delegate:self];
    
    [weibo sendWeiboWithText:text image:nil params:params success:^(id result) {
        //成功,跳转到home 并进行刷新
        hud.labelText = @"发送成功";
        //收起键盘
        [_inputTextView resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:^{
            
        //刷新微博
        UIApplication *app = [UIApplication sharedApplication];
        AppDelegate *delegate = (AppDelegate *)app.delegate;
        MMDrawerController *mmd = (MMDrawerController *)delegate.window.rootViewController;
        UITabBarController *tabbar = (UITabBarController *)mmd.centerViewController;
        UINavigationController *navi = (UINavigationController *)[tabbar.viewControllers firstObject];
        HomeViewController *home = (HomeViewController *)navi.topViewController;
        
        [home reloadNewWeibo];
            
        }];
        
        [hud hide:YES afterDelay:1];

    } fail:^(NSError *error) {
        //发送失败
        hud.labelText = @"发送失败";
        [hud hide:YES afterDelay:1];
    }];
}

#pragma mark - SinaWeiboRequestDelegate
//-(void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response{
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
//    NSLog(@"状态码:%li",httpResponse.statusCode);
//    
//    if (httpResponse.statusCode == 404){
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"警告" message:@"发送失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//    }
//}

//set方法实时刷新数据
-(void)setLocationData:(NSDictionary *)locationData{
    if (_locationData != locationData) {
        _locationData = locationData;
        if (_locationData == nil) {
            _locationView.hidden = YES;
        }else{
            
        _locationView.hidden = NO;
        //设置数据
        _locationLabel.text = _locationData[@"title"];
        [_locationIcon sd_setImageWithURL:[NSURL URLWithString:_locationData[@"icon"]]];
            
            //改变label宽度
            CGRect rect = [_locationLabel.text boundingRectWithSize:CGSizeMake(KScreenWidth - 15 - KLocationViewHeight * 2, KLocationViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_locationLabel.font} context:nil];
            
            _locationLabel.width = MAX(80, rect.size.width);
            _locationCancelBtn.left = _locationLabel.right;
        }
    }
    
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
