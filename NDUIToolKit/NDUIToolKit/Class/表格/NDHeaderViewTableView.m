//
//  NDBgImageTableView.m
//  NDUIToolKit
//
//  Created by zhangx on 15/10/12.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDHeaderViewTableView.h"
#import "MJRefreshHeader+NDHeaderAnimation.h"

@implementation NDHeaderViewTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultSet];
    }
    return self;
}

- (void)setNDHeaderBeginRefresh
{
    self.arrowImage.hidden = YES;
    [self.indicatorView startAnimating];
    self.indicatorView.hidden = NO;
}


- (void)setNDHeaderEndRefresh
{
    self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
    self.arrowImage.hidden = YES;
    self.indicatorView.hidden = YES;
    self.headerView.hidden = NO;
    [self.indicatorView stopAnimating];
}

-(void)defaultSet
{
    self.refreshType = BigImageRefreshType;
    
    UIImageView *arrowImage = [[UIImageView alloc] init];
    arrowImage.frame = CGRectMake(0, 0, 24, 24);
    arrowImage.image = [UIImage imageInUIToolKitProject:@"icn_arrow_notif_dark.png"];
    arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
    [self addSubview:arrowImage];
    
    self.arrowImage = arrowImage;
    
    UIActivityIndicatorView * indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    [self setNDHeaderEndRefresh];
    
}

-(void)setEnableRefresh:(BOOL)enableRefresh
{
    [super setEnableRefresh:enableRefresh];
    if (enableRefresh == NO) {
        self.arrowImage = nil;
        self.indicatorView = nil;
    }
}

@end
