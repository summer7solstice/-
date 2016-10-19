//
//  WeiboCell.m
//  我的微博
//
//  Created by Macx on 16/10/11.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "WeiboCell.h"
#import "WeiboCellLayout.h"
#import "WXLabel.h"
#import "RegexKitLite.h"
#import "WeiboWebViewController.h"
#import "WXPhotoBrowser.h"

@class WeiboCellLayout;
@interface WeiboCell ()<WXLabelDelegate,PhotoBrowerDelegate>

@end
@implementation WeiboCell
{
    
    __weak IBOutlet UIImageView *_userIcon;
    
    __weak IBOutlet ThemeLabel *_userNameLabel;
    __weak IBOutlet ThemeLabel *_sourceLabel;
    __weak IBOutlet ThemeLabel *_timeLabel;
}
-(void)setWeibo:(WeiboModel *)weibo{
    _weibo = weibo;
    //user名字
    _userNameLabel.text = _weibo.user.name;

    //user头像
    [_userIcon sd_setImageWithURL:_weibo.user.profile_image_url];
    
    //微博来源source
    [self showSource];
    
    //时间显示
    [self showTime];
    
    
    //----------创建布局对象------------//
    WeiboCellLayout *layout = [WeiboCellLayout layoutWithWeiboModel:_weibo];

    //----------原创微博-----------//
    //正文
    self.weiboTextLabel.text = _weibo.text;
    self.weiboTextLabel.frame = layout.weiboTextFrame;
    //图片
    if (_weibo.pic_urls.count > 0) {
        for (NSInteger i = 0; i < 9; i ++) {
            UIImageView *imv = self.imageViewArr[i];
            NSValue *value = layout.imageFrameArr[i];
            CGRect frame = [value CGRectValue];
            imv.frame = frame;
            if (i < _weibo.pic_urls.count) {
                //设置图片
                NSURL *url = [_weibo.pic_urls[i] objectForKey:@"thumbnail_pic"];
                [imv sd_setImageWithURL:url];
            }
        }
    }else{
        for (UIImageView *imv in _imageViewArr) {
            imv.frame = CGRectZero;
        }
    }
    
    //----------转发微博------------//
    //正文
    self.repostWeiboTextLabel.text = [NSString stringWithFormat:@"@%@ %@", _weibo.retweeted_status.user.name,_weibo.retweeted_status.text];
    self.repostWeiboTextLabel.frame = layout.repostWeiboTextFrame;
    //图片
    if (_weibo.retweeted_status.pic_urls.count > 0) {
        for (NSInteger i = 0; i < 9; i ++) {
            UIImageView *imv = self.imageViewArr[i];
            NSValue *value = layout.imageFrameArr[i];
            CGRect frame = [value CGRectValue];
            imv.frame = frame;
            if (i < _weibo.retweeted_status.pic_urls.count) {
                //设置图片
                NSURL *url = [_weibo.retweeted_status.pic_urls[i] objectForKey:@"thumbnail_pic"];
                [imv sd_setImageWithURL:url];
            }
        }
    }
    

    //背景
    self.repostWeiboBGImageView.frame = layout.repostWeiboBGImageFrame;
    
    
    //label颜色可切换
//    _userNameLabel.colorName = KHomeNameLabelColor;
//    _timeLabel.colorName = KHomeTimeLabelColor;
//    _sourceLabel.colorName = KHomeTimeLabelColor;
//    _weiboTextLabel.colorName = KHomeTextLabelColor;
   
}

//-----------------微博来源--------------------//
-(void)showSource{
    //<a href="http://weibo.com" rel="nofollow">新浪微博</a>
    if (_weibo.source.length != 0) {
        NSArray *arr1 = [_weibo.source componentsSeparatedByString:@">"];
        NSString *str = [arr1 objectAtIndex:1];
        NSArray *arr2 = [str componentsSeparatedByString:@"<"];
        
        NSString *sourceStr = [arr2 firstObject];
        _sourceLabel.text = [NSString stringWithFormat:@"来源:%@",sourceStr];
        
        _sourceLabel.hidden = NO;
    }else{
        _sourceLabel.hidden = YES;
    }
    

    
}
//-----------------时间显示--------------------//
-(void)showTime{
    //1.使用时间格式化符转化时间字符喜欢  --->NSDate  查找时间格式化,对照
    NSString *foratterStr = @"E M d HH:mm:ss Z yyyy";
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    //设置时间格式
    [formatter setDateFormat:foratterStr];
    //设置语言类型/地区
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    
    //时间格式化
    NSDate *date = [formatter dateFromString:_weibo.created_at];
    
    //计算时间差值
    NSTimeInterval second = -[date timeIntervalSinceNow];
    NSTimeInterval minute = second / 60;
    NSTimeInterval hour = minute / 60;
    NSTimeInterval day = hour / 24;
    
    NSString *timeStr = nil;
    
    if (second < 60) {
        timeStr = @"刚刚";
    }else if (minute < 60){
        timeStr = [NSString stringWithFormat:@"%li分钟之前",(NSInteger)minute];
    }else if (hour < 24){
        timeStr = [NSString stringWithFormat:@"%li小时之前",(NSInteger)hour];
    }else if (day < 7){
        timeStr = [NSString stringWithFormat:@"%li天之前",(NSInteger)day];
    }else{
        //具体时间
        [formatter setDateFormat:@"M月d日 HH:mm"];
        //所在地区
        [formatter setLocale:[NSLocale currentLocale]];
        
        timeStr = [formatter stringFromDate:date];
    }
    
    _timeLabel.text = timeStr;
}

#pragma mark - WXLabeldelegate
//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel{
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;
    
}
//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
    return [[ThemeManager shareManager] colorWithKeyInConfig:KHomeLink];
}
//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel{
    return [UIColor redColor];
}
//手指离开当前超链接文本响应的协议方法
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";

    if ([context isMatchedByRegex:regex1]) {
        //是@某人
    }else if ([context isMatchedByRegex:regex2]){
        //是url连接
        WeiboWebViewController *webVc = [[WeiboWebViewController alloc]initWithUrl:[NSURL URLWithString:context]];
        //通过响应者链找到navigationController
        UIResponder *nextresponder = self.nextResponder;
        
        while (nextresponder) {
            if ([nextresponder isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navi = (UINavigationController *)nextresponder;
                //push操作
                [navi pushViewController:webVc animated:YES];
             
                break;
            }
            nextresponder = nextresponder.nextResponder;
        }
        
    }else if ([context isMatchedByRegex:regex3]){
        //是话题#...#
    }
}


#pragma mark - 原创微博视图
//懒加载:不用到时不加载
-(WXLabel *)weiboTextLabel{
    if (_weiboTextLabel == nil) {
        //创建对象
        _weiboTextLabel = [[WXLabel alloc]initWithFrame:CGRectZero];
        //微博字体
        _weiboTextLabel.font = KWeiboTextFont;
        //正文行数
        _weiboTextLabel.numberOfLines = 0;
        
        //设置行间距
        _weiboTextLabel.linespace = KLineSpace;
        _weiboTextLabel.wxLabelDelegate = self;
        
        //添加视图
        [self.contentView addSubview:_weiboTextLabel];
    }
    return _weiboTextLabel;
}
//懒加载  图片数组
-(NSArray *)imageViewArr{
    if (_imageViewArr == nil) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i < 9; i ++) {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self.contentView addSubview:imgView];
            
            imgView.backgroundColor = [UIColor lightGrayColor];
            
            //增加点击事件
            imgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [imgView addGestureRecognizer:tap];
            
            [arr addObject:imgView];
        }
        _imageViewArr = [arr copy];
    }
    
    return _imageViewArr;
}
#pragma mark - 转发微博视图
-(WXLabel *)repostWeiboTextLabel{
    if (_repostWeiboTextLabel == nil) {
        _repostWeiboTextLabel = [[WXLabel alloc]initWithFrame:CGRectZero];
        _repostWeiboTextLabel.font = KRepostWeiboTextFont;
        _repostWeiboTextLabel.numberOfLines = 0;
        
        //设置行间距
        _repostWeiboTextLabel.linespace = KLineSpace;
        _repostWeiboTextLabel .wxLabelDelegate = self;
        
        [self.contentView addSubview:_repostWeiboTextLabel];
    }
    return _repostWeiboTextLabel;
}

-(ThemeImageView *)repostWeiboBGImageView{
    if (_repostWeiboBGImageView == nil) {
        _repostWeiboBGImageView = [[ThemeImageView alloc]initWithFrame:CGRectZero];
        _repostWeiboBGImageView.imageName = @"timeline_rt_border_9";
        //拉伸点设置
        _repostWeiboBGImageView.topCapHeight = 20;
        _repostWeiboBGImageView.leftCapWidth = 25;
        
        [self.contentView insertSubview:_repostWeiboBGImageView atIndex:0];
    }
    return _repostWeiboBGImageView;
}

#pragma mark - 大图浏览photoBrowser
-(void)tapAction:(UITapGestureRecognizer *)tap{
    //被点击的图片
    UIImageView *imgView = (UIImageView *)tap.view;
    //获取被点击的图片所在数组中的index
    NSInteger imgIndex = [_imageViewArr indexOfObject:imgView];
    
    if (imgIndex == NSNotFound) {
        return;
    }
    [WXPhotoBrowser showImageInView:self.window
                   selectImageIndex:imgIndex
                           delegate:self];
    
}
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser{
    if (self.weibo.retweeted_status.pic_urls.count == 0) {
        //表示是原创微博的图片
        return self.weibo.pic_urls.count;
    }else{
        //转发微博中的图片
        return self.weibo.retweeted_status.pic_urls.count;
    }
    return 0;
}

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    WXPhoto *photo = [[WXPhoto alloc]init];
    
    photo.srcImageView = self.imageViewArr[index];
    
    NSString *urlStr;
    if (self.weibo.retweeted_status.pic_urls.count == 0) {
        //表示是原创微博的图片
        NSDictionary *dic = self.weibo.pic_urls[index];
        urlStr = [dic objectForKey:@"thumbnail_pic"];
        
    }else{
        //转发微博中的图片
        NSDictionary *dic = self.weibo.retweeted_status.pic_urls[index];
        urlStr = [dic objectForKey:@"thumbnail_pic"];
        
    }
    
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];

    //大图的url
    photo.url = [NSURL URLWithString:urlStr];
    return photo;
}


-(void)themeChange{
    ThemeManager *manager = [ThemeManager shareManager];
    UIColor *color = [manager colorWithKeyInConfig:KHomeTextLabelColor];
    
    self.repostWeiboTextLabel.textColor = color;
    self.weiboTextLabel.textColor = color;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //label颜色可切换
    _userNameLabel.colorName = KHomeNameLabelColor;
    _timeLabel.colorName = KHomeTimeLabelColor;
    _sourceLabel.colorName = KHomeTimeLabelColor;
    
    ThemeManager *manager = [ThemeManager shareManager];
    UIColor *color = [manager colorWithKeyInConfig:KHomeTextLabelColor];
    self.repostWeiboTextLabel.textColor = color;
    self.weiboTextLabel.textColor = color;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:KThemeChangedNotiName object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
