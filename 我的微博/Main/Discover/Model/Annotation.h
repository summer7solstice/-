//
//  Annotation.h
//  我的微博
//
//  Created by Macx on 16/10/19.
//  Copyright © 2016年 无限. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class WeiboModel;
@interface Annotation : NSObject<MKAnnotation>
//require
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

//optional
@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;

@property(nonatomic,strong,nullable) WeiboModel *weiboModel;
@end
