//
//  WeiboModel.m
//  我的微博
//
//  Created by Macx on 16/10/11.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"
@implementation WeiboModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    //获取字符text
    NSString *weiboText = [self.text copy];
    
    //用表情字符串替换
    /*
     注意：[兔子]  -> <image url = '001.png'>
     默认表达式@"<image url = '[a-zA-Z0-9_\\.@%&\\S]*'>"
     可以通过代理方法修改正则表达式，不过本地图片地址的左右（＊＊＊一定要用单引号引起来）
     */
    NSString *regex = @"\\[\\w+\\]";
    NSArray *emoticonArr = [weiboText componentsMatchedByRegex:regex];
    
    //获取plist文件
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:plistPath];
    //遍历匹配
    for (NSString *str in emoticonArr) {
        for (NSDictionary *emoDic in plistArr) {
            NSString *emoticonStr = [emoDic objectForKey:@"chs"];
            
            if ([str isEqualToString:emoticonStr]) {
                //图片str
                NSString *imgName = [emoDic objectForKey:@"png"];
                NSString *newStr = [NSString stringWithFormat:@"<image url = '%@'>",imgName];
                //将原本的text中的str替换
                weiboText = [weiboText stringByReplacingOccurrencesOfString:str withString:newStr];
            }
        }
    }
    //重新设置text
    self.text = weiboText;
    
    return YES;
}

@end
