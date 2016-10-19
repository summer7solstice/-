//
//  LeftViewController.m
//  我的微博
//
//  Created by Macx on 16/10/11.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSInteger _selectIndex;
}
@property(nonatomic,strong) UIImage *iconImg;
@property(nonatomic,strong) UIColor *textColor;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setbackground];
    
    [self createTableView];
    _selectIndex = 0;
    //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:KThemeChangedNotiName object:nil];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)themeChange{
    ThemeManager *manager = [ThemeManager shareManager];
    _iconImg = [manager changeThemeWithImageName:@"detail_button_fav_1"];
    _textColor = [manager colorWithKeyInConfig:@"Background_Compose_color"];
    
    [_tableView reloadData];
}
-(void)createTableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 180, KScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_tableView];
    }
    [_tableView reloadData];
}
-(void)setbackground{
    //利用imageView设置主题背景
    ThemeImageView *bgImageView = [[ThemeImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.imageName = @"mask_bg.jpg";
    
    [self.view insertSubview:bgImageView atIndex:0];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        _selectIndex = indexPath.row;
        [_tableView reloadData];
    
    //获取manager
    MMExampleDrawerVisualStateManager *mmdManager = [MMExampleDrawerVisualStateManager sharedManager];
    mmdManager.leftDrawerAnimationType = indexPath.row;
    mmdManager.rightDrawerAnimationType = indexPath.row;
}
#pragma mark - 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"无";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"滑动";
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"滑动&缩放";
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"3D旋转";
    }else if (indexPath.row == 4){
        cell.textLabel.text = @"视差滑动";
    }
    
    ThemeManager *manager = [ThemeManager shareManager];
    _iconImg = [manager changeThemeWithImageName:@"detail_button_fav_1"];
    _textColor = [manager colorWithKeyInConfig:@"Background_Compose_color"];

    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.imageView.image = _iconImg;
    cell.textLabel.textColor = _textColor;
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == _selectIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
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
