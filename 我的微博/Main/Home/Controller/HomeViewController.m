//
//  HomeViewController.m
//  我的微博
//
//  Created by Macx on 16/9/29.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "YYModel.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "WeiboCell.h"
#import "WeiboCellLayout.h"
#import "WXRefresh.h"
#import <AVFoundation/AVFoundation.h>

@class YYModel;
@class WeiboCell;
@class WeiboCellLayout;

#define KTimelineWeiboAPI (@"statuses/home_timeline.json")

@interface HomeViewController ()<SinaWeiboRequestDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    
    NSMutableArray *_weiboArr;
    ThemeImageView *_numberOfNewWeiboImgView;
    ThemeLabel *_label;
    
    //提示音
    SystemSoundID _msgcomeID;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载微博数据
    [self loadWeiboData];
    
    //创建表视图
    [self createTableView];
    
    
    //获取声音文件路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"msgcome" withExtension:@"wav"];
    //注册系统声音
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &(_msgcomeID));
    
}

-(void)dealloc{
    //注销系统声音id
    AudioServicesRemoveSystemSoundCompletion(_msgcomeID);
}
#pragma mark - 加载微博数据
-(void)loadWeiboData{
    //发起网络请求
    //1.获取微博对象
    SinaWeibo *weibo = KSinaWeiboOBJ;
    //2.判断登录状态
    if (![weibo isAuthValid]) {
        //没有登录,请登录
        return;
    }
    //3.发起网络请求
    NSDictionary *params = @{@"count" :  @"20"};
    SinaWeiboRequest *request = [weibo requestWithURL:KTimelineWeiboAPI
                                               params:[params mutableCopy]
                                           httpMethod:@"GET"
                                             delegate:self];
    
    request.tag = 0;    //表示第一次加载
    //监听数据读取
    [_tableView reloadData];
}

#pragma mark - 数据请求完毕
-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    NSLog(@"请求完毕");
    //获取statuses数组
    NSArray *statuses = result[@"statuses"];
    
    NSMutableArray *weiboArr = [NSMutableArray array];
    
    for (NSDictionary *dic in statuses) {
        WeiboModel *weiboModel = [WeiboModel yy_modelWithDictionary:dic];
        
        [weiboArr addObject:weiboModel];
    }
    
    
    //开始判断加载方式
    if (request.tag == 0) {
        //第一次加载
        _weiboArr = [weiboArr mutableCopy];

    }
    
    //下拉刷新
    else if (request.tag == 1){
        if (weiboArr.count <= 0) {
            [self showNewWeiboNumbers:weiboArr.count];
            //停止动作
            [_tableView.pullToRefreshView stopAnimating];
            return;
        }
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(0, weiboArr.count)];
        [_weiboArr insertObjects:weiboArr atIndexes:indexSet];
        [self showNewWeiboNumbers:weiboArr.count];
        //停止动作
        [_tableView.pullToRefreshView stopAnimating];
    }
    
    //上拉加载更多
    else if (request.tag == 2){
        if (weiboArr.count <= 0) {
            //停止动作
            [_tableView.pullToRefreshView stopAnimating];
            return;
        }
        [_weiboArr addObjectsFromArray:weiboArr];
        //停止动作
        [_tableView.infiniteScrollingView stopAnimating];

    }
    
    //刷新数据
    [_tableView reloadData];
}
#pragma mark - 创建表示图
-(void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49 - 5) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    //单元格注册
    UINib *nib = [UINib nibWithNibName:@"WeiboCell" bundle:[NSBundle mainBundle]];
    [_tableView registerNib:nib forCellReuseIdentifier:@"WeiboCell"];

    //为解决循环引用
    __weak HomeViewController *weakSelf = self;
    //下拉刷新
    [_tableView addPullDownRefreshBlock:^{
        __strong HomeViewController *strongSelf = weakSelf;
        
        [strongSelf pullDownLoadData];
    }];
    
    //上拉加载
    [_tableView addInfiniteScrollingWithActionHandler:^{
        __strong HomeViewController *strongSelf = weakSelf;

        [strongSelf pullUpLoadData];
    }];
    
    
    //创建新微博数量显示图片
    if (_numberOfNewWeiboImgView == nil) {
    
    _numberOfNewWeiboImgView = [[ThemeImageView alloc] initWithFrame:CGRectMake(3, 3, KScreenWidth - 6, 40)];
    _numberOfNewWeiboImgView.transform = CGAffineTransformMakeTranslation(0, -60);
    _numberOfNewWeiboImgView.imageName = @"timeline_notify.png";
    [self.view addSubview:_numberOfNewWeiboImgView];
    //图片上的label
    _label = [[ThemeLabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - 6, 40)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.colorName = KHomeTextLabelColor;
    
    [_numberOfNewWeiboImgView addSubview:_label];
    }
    
}

#pragma mark - 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _weiboArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //复用
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell"];
    
    WeiboModel *weibo = _weiboArr[indexPath.row];
    //将微博对象设置给cell的微博属性
    cell.weibo = weibo;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

//代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboModel *weibo = _weiboArr[indexPath.row];

    //创建布局对象
    WeiboCellLayout *layout = [WeiboCellLayout layoutWithWeiboModel:weibo];
    
    
    return [layout cellHeight];
}


#pragma mark - 上拉下拉刷新数据操作
//下拉刷新
-(void)pullDownLoadData{
    //发起网络请求
    //1.获取微博对象
    SinaWeibo *weibo = KSinaWeiboOBJ;
    //2.判断登录状态
    if (![weibo isAuthValid]) {
        //没有登录,请登录
        [weibo logIn];
        return;
    }
    //拿到当前第一条微博id
    if (_weiboArr != nil) {
        
    WeiboModel *firstWeibo = [_weiboArr firstObject];
    NSString *idstr = firstWeibo.idstr;
    //3.发起网络请求
    NSDictionary *params = @{@"count" :  @"20",
                             @"since_id" : idstr};
    SinaWeiboRequest *request = [weibo requestWithURL:KTimelineWeiboAPI
                                               params:[params mutableCopy]
                                           httpMethod:@"GET"
                                             delegate:self];
    request.tag = 1;    //表示下拉刷新
    }
    
    
}
//上拉加载
-(void)pullUpLoadData{
    //发起网络请求
    //1.获取微博对象
    SinaWeibo *weibo = KSinaWeiboOBJ;
    //2.判断登录状态
    if (![weibo isAuthValid]) {
        //没有登录,请登录
        [weibo logIn];
        return;
    }
    //拿到当前最后一条微博id
    WeiboModel *lastWeibo = [_weiboArr lastObject];
    NSString *idstr = lastWeibo.idstr;
    NSInteger idstrInt = [idstr integerValue];
    //3.发起网络请求
    NSDictionary *params = @{@"count" :  @"20",
                             @"max_id":  [NSString stringWithFormat:@"%li",idstrInt - 1]};
    SinaWeiboRequest *request = [weibo requestWithURL:KTimelineWeiboAPI
                                               params:[params mutableCopy]
                                           httpMethod:@"GET"
                                             delegate:self];
    request.tag = 2;    //表示上拉加载
}

-(void)showNewWeiboNumbers:(NSInteger)count{
    if (count == 0) {
        _label.text = @"没有新微博";
    }else if (count != 0){
        _label.text = [NSString stringWithFormat:@"%li条新微博",(long)count];
    }
    
    [UIView animateWithDuration:.5 animations:^{
        _numberOfNewWeiboImgView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //播放系统声音
        AudioServicesPlaySystemSound(_msgcomeID);
        [UIView animateWithDuration:1 animations:^{
            _numberOfNewWeiboImgView.transform = CGAffineTransformMakeTranslation(0, -60);
        }];
        
    }];
}


-(void)reloadNewWeibo{
    
    [self pullDownLoadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
