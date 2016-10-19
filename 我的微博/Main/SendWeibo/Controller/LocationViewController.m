//
//  LocationViewController.m
//  我的微博
//
//  Created by Macx on 16/10/18.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Appdelegate.h"

#define KPlaceNearbyAPI (@"place/nearby/pois.json")
@interface LocationViewController ()<CLLocationManagerDelegate,SinaWeiboRequestDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CLLocationManager *_locationManager;
    NSArray *_locationArr;
    UITableView *_tableView;
}
@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近";
    
    [self startLocation];
    [self createTableView];
}
-(void)startLocation{
    _locationManager = [[CLLocationManager alloc]init];
    
    if (KSystemVersion >= 8.0) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //设置定位精准度
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    _locationManager.delegate = self;
    
    //开始刷新定位信息
    [_locationManager startUpdatingLocation];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //回传
    if (_block) {
        _block(_locationArr[indexPath.row]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    //定位结束后停止定位
    [manager stopUpdatingLocation];
    
    //获取当前经纬度
    CLLocation *location = [locations firstObject];
    
    //经度
    double lon = location.coordinate.longitude;
    //维度
    double lat = location.coordinate.latitude;
    
    //获取当前位置附近地点
    //经纬度反编码
    
    //网络请求数据
    SinaWeibo *weibo = KSinaWeiboOBJ;
    NSDictionary *params = @{@"lat": [NSString stringWithFormat:@"%f",lat],
                             @"long":[NSString stringWithFormat:@"%f",lon]};
    [weibo requestWithURL:KPlaceNearbyAPI
                   params:[params mutableCopy]
               httpMethod:@"GET"
                 delegate:self];
    
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    _locationArr = result[@"pois"];
//    NSLog(@"pois : %@",_locationArr);
    [_tableView reloadData];
}

#pragma mark - 表示图创建
-(void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _locationArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    //信息填充
    NSDictionary *dic = _locationArr[indexPath.row];
    
    if (dic[@"title"]) {
        cell.textLabel.text = dic[@"title"];
    }
    if (![dic[@"address"] isKindOfClass:[NSNull class]]) {
        cell.detailTextLabel.text = dic[@"address"];
    }
    if (dic[@"icon"]) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]]];
    }else{
        cell.detailTextLabel.text = nil;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(void)addLocationResultBlock:(LocationResultBlock)block{
    _block = block;
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
