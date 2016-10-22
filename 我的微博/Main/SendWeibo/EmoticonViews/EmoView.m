//
//  EmoView.m
//  我的微博
//
//  Created by Macx on 16/10/22.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "EmoView.h"
#import "EmoticonViews.h"
#import "EmoticonModel.h"

@class EmoticonModel;
@implementation EmoView


- (void)drawRect:(CGRect)rect {
    if (_emoticonArr.count == 0 || _emoticonArr.count > 32) {
        return;
    }
    
    for (int i = 0; i < 4; i ++) {
        for (int j = 0; j < 8; j ++) {
            CGRect frame = CGRectMake(j * KEmoticonWidth, i * KEmoticonWidth,KEmoticonWidth , KEmoticonWidth);
            //获取图片
            NSInteger index = i * 8 + j;
            if (index >= _emoticonArr.count) {
                return;
            }
            EmoticonModel *emo = _emoticonArr[index];
            UIImage *image = [UIImage imageNamed:emo.png];
            
            [image drawInRect:frame];
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //行数
    NSInteger row = point.y / KEmoticonWidth;
    //列数
    NSInteger column = point.x / KEmoticonWidth;
    NSInteger index = row * 8 + column;
    //获取表情
    EmoticonModel *model = _emoticonArr[index];
    NSDictionary *dic = @{KEmoKey:model};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KEmoNotiName object:nil userInfo:[dic copy]];
}

@end
