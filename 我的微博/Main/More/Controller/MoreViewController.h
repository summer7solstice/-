//
//  MoreViewController.h
//  我的微博
//
//  Created by Macx on 16/9/29.
//  Copyright © 2016年 无限. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreViewController : UITableViewController{
    
    __weak IBOutlet ThemeImageView *icon0;
    
    __weak IBOutlet ThemeImageView *icon1;
    
    __weak IBOutlet ThemeImageView *icon2;
    
    __weak IBOutlet ThemeImageView *icon3;
    
    __weak IBOutlet ThemeLabel *_themeNameLabel;
    
    __weak IBOutlet ThemeLabel *themeChangeLabel;
    
    __weak IBOutlet ThemeLabel *feedbackLabel;
    
    __weak IBOutlet ThemeLabel *draftLabel;
    
    __weak IBOutlet ThemeLabel *aboutLabel;
    
    __weak IBOutlet ThemeLabel *cacheLabel;
}


@end
