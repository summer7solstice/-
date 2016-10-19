//
//  ThemeSelViewController.m
//  我的微博
//
//  Created by Macx on 16/10/10.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "ThemeSelViewController.h"

#define KTextColor (@"textColor")
@interface ThemeSelViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    
    UIColor *_textColor;
}

@end

@implementation ThemeSelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
}

-(void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    
    [self.view addSubview:_tableView];
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange) name:KThemeChangedNotiName object:nil];
}
//移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)themeChange{
    ThemeManager *manager = [ThemeManager shareManager];
    
    _textColor = [manager colorWithKeyInConfig:KMoreItemTextColor];
    
    //刷新数据
    [_tableView reloadData];
    
}
//单元格选中方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    
    //拿到选中的key
    NSString *keyStr = thisCell.textLabel.text;
    ThemeManager *manager = [ThemeManager shareManager];
    
    //由key取到主题string 设置给manager
    manager.currentThemeName = keyStr;
    
    //cell尾部打钩标记
    thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    //刷新表示图
    [tableView reloadData];
    //pop出当前vc
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ThemeManager shareManager].themeDic.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //复用
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    //获取manager
    ThemeManager *manager = [ThemeManager shareManager];
    NSArray *allKeys = manager.themeDic.allKeys;

    NSString *keyName = allKeys[indexPath.row];
    cell.textLabel.text = keyName;
    
    _textColor = [manager colorWithKeyInConfig:KMoreItemTextColor];
    //单元格字体颜色
    cell.textLabel.textColor = _textColor;
    
    //more_icon_theme.png
    //图片路径
    NSString *valueName = manager.themeDic[keyName];
    //小图标
    UIImage *iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@/more_icon_theme.png",valueName]];
    
    cell.imageView.image = iconImage;
    cell.backgroundColor = [UIColor clearColor];
    
    //打钩
    if ([cell.textLabel.text isEqualToString:manager.currentThemeName]) {
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
