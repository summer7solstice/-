//
//  UserModel.m
//  我的微博
//
//  Created by Macx on 16/10/11.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"myDescription":@"description"};
}

@end
