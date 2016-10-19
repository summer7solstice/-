//
//  Annotation.m
//  我的微博
//
//  Created by Macx on 16/10/19.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

-(void)setWeiboModel:(WeiboModel *)weiboModel{
    _weiboModel = weiboModel;
    
    NSDictionary *geo = _weiboModel.geo;
    NSArray *coordinates = geo[@"coordinates"];
    if (coordinates.count == 2) {
        //纬度
        double lat = [[coordinates firstObject] doubleValue];
        //经度
        double lon = [[coordinates lastObject] doubleValue];
        
        _coordinate = CLLocationCoordinate2DMake(lat, lon);
    }
}
@end
