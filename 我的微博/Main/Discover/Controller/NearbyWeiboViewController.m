//
//  NearbyWeiboViewController.m
//  我的微博
//
//  Created by Macx on 16/10/19.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "NearbyWeiboViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Appdelegate.h"
#import "YYModel.h"
#import "Annotation.h"
#import "MyAnnoView.h"

#define KNearbyWeiboAPI (@"place/nearby_timeline.json")
@interface NearbyWeiboViewController ()<SinaWeiboRequestDelegate,MKMapViewDelegate>{
    MKMapView *_mapView;
    BOOL _isLocated;
    
    NSArray *_nearbyWeiboArr;
}

@end

@implementation NearbyWeiboViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    _isLocated = NO;
    [self createMapView];
}
-(void)createMapView{
    //iOS8.0之后 需要获取权限
    if (KSystemVersion >= 8.0) {
        [[[CLLocationManager alloc]init] requestWhenInUseAuthorization];
    }
    
    _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    //显示当前用户定位
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    _mapView.delegate = self;
}
//刷新用户信息
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //获取位置信息
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    
    //获取经纬度
    double lon = coordinate.longitude;
    double lat = coordinate.latitude;
    
    MKCoordinateSpan span =  MKCoordinateSpanMake(.05, .05);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [_mapView setRegion:region animated:YES];
    
    if (_isLocated == NO) {
        _isLocated = YES;
        
        //发送请求
        SinaWeibo *weibo = KSinaWeiboOBJ;
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:[NSString stringWithFormat:@"%lf",lat] forKey:@"lat"];
        [params setObject:[NSString stringWithFormat:@"%lf",lon] forKey:@"long"];

        
        [weibo requestWithURL:KNearbyWeiboAPI
                       params:params
                   httpMethod:@"GET"
                     delegate:self];
    }
    _isLocated = NO;
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    NSArray *weiboArr = result[@"statuses"];
    //遍历
    for (NSDictionary *dic in weiboArr) {
        WeiboModel *model = [WeiboModel yy_modelWithDictionary:dic];
        
        //创建标注点
        Annotation *anno = [[Annotation alloc]init];
        anno.weiboModel = model;
        //在地图上添加标注点
        [_mapView addAnnotation:anno];
    }
}
//自定义
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MyAnnoView *view = (MyAnnoView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MyAnnoView"];
    if (view == nil) {
        view = [[MyAnnoView alloc]initWithAnnotation:annotation reuseIdentifier:@"MyAnnoView"];
    }
    return view;
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
