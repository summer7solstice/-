//
//  LocationViewController.h
//  我的微博
//
//  Created by Macx on 16/10/18.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^LocationResultBlock)(NSDictionary *result);

@interface LocationViewController : BaseViewController

@property(nonatomic,copy) LocationResultBlock block;

-(void)addLocationResultBlock:(LocationResultBlock)block;
@end
