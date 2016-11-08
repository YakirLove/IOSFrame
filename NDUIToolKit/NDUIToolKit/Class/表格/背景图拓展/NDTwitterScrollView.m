//
//  MBTwitterScroll.m
//  TwitterScroll
//
//  Created by Martin Blampied on 07/02/2015.
//  Copyright (c) 2015 MartinBlampied. All rights reserved.
//

#import "NDTwitterScrollView.h"
#import "MJRefreshHeader+NDHeaderAnimation.h"


CGFloat const offset_HeaderStop = 40.0;


@implementation NDTwitterScrollView

- (NDTwitterScrollView *)initScrollViewFrame:(CGRect)frame headerView:(UIView *)headerView contentHeight:(CGFloat)height
{
    
    self = [[NDTwitterScrollView alloc] initWithFrame:frame];
    [self setupViewType:NDTwitterScrollTypeScroll scrollHeight:height headerView:nil];
        
    return self;
}


- (NDTwitterScrollView *)initTableViewWithFrame:(CGRect)frame headerView:(UIView *)headerView
{
    self = [[NDTwitterScrollView alloc] initWithFrame:frame];
    
    [self setupViewType:NDTwitterScrollTypeTable scrollHeight:0 headerView:headerView];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    return self;
    
}

- (void)disableRefresh
{
    self.tableView.enableRefresh = NO;
    [self.headerImageView removeFromSuperview];
    self.headerImageView = nil;
}

- (void) setupViewType:(NDTwitterScrollType)type scrollHeight:(CGFloat)height headerView:(UIView *)headerView{
    
    // Header
    self.header = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, headerView.height)];
    headerView.tag = 999;
    [self.header addSubview:headerView];
    
    
    if (type == NDTwitterScrollTypeTable) {
        // TableView
        self.tableView = [[NDHeaderViewTableView alloc] initWithFrame:self.frame];
//        [self.tableView ndHeader].alpha = 0;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.arrowImage.center = headerView.center;
        
        self.orgHeight = headerView.height;
        
        // TableView Header
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.header.frame.size.height)];
        [self addSubview:self.tableView];
        
        [self.tableView addSubview:self.header];
        
        [self.tableView bringSubviewToFront:self.tableView.indicatorView];
        [self.tableView bringSubviewToFront:self.tableView.arrowImage];
        
    } else {
        
        // Scroll
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        CGSize newSize = CGSizeMake(self.frame.size.width, height);
        self.scrollView.contentSize = newSize;
        self.scrollView.delegate = self;
        
        [self addSubview:self.header];
    }
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:self.header.bounds];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.header addSubview:self.headerImageView];
    self.header.clipsToBounds = YES;
    
    self.blurImages = [[NSMutableArray alloc] init];
    
    
    [self prepareForBlurImages];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    [self animationForScroll:offset];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGFloat offset = self.tableView.contentOffset.y;
    [self animationForScroll:offset];
}


- (void) animationForScroll:(CGFloat) offset {
    
    CATransform3D headerTransform = CATransform3DIdentity;
    
    // DOWN -----------------
    if (offset < 0) {
        CGFloat headerScaleFactor = -(offset) / self.header.bounds.size.height;
        CGFloat headerSizevariation = ((self.header.bounds.size.height * (1.0 + headerScaleFactor)) - self.header.bounds.size.height)/2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, -headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        self.header.layer.transform = headerTransform;
        
        if (self.tableView.isRefreshing == NO) {
            self.tableView.arrowImage.hidden = NO;
            self.headerImageView.hidden = NO;
        }
        
        
        if(offset <= -54){
            [UIView animateWithDuration:0.2 animations:^{
                self.tableView.arrowImage.transform = CGAffineTransformMakeRotation(0);
            }];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                self.tableView.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        }
        
    } // SCROLL UP/DOWN ------------
    else {
        // Header -----------
        self.tableView.arrowImage.hidden = YES;
        self.headerImageView.hidden = YES;
//        headerTransform = CATransform3DTranslate(headerTransform, 0, MAX(-offset_HeaderStop, -offset), 0);
    }
    
    self.header.layer.transform = headerTransform;
    
    self.tableView.headerView.frame = self.header.frame;
    
    self.tableView.arrowImage.frame = CGRectMake(self.tableView.arrowImage.left, (self.orgHeight +  offset - self.tableView.arrowImage.height)/2.0, self.tableView.arrowImage.height, self.tableView.arrowImage.height);
    self.tableView.indicatorView.center = self.tableView.arrowImage.center;
    
    if (self.headerImageView.image != nil) {
        [self blurWithOffset:-offset];
    }
}
        
-(void)headerViewShow
{
    self.tableView.headerView.hidden = NO;
}

- (void)prepareForBlurImages
{
    self.headerImageView.image = [[self.header viewWithTag:999] shot];
    [self.blurImages removeAllObjects];
    CGFloat factor = 0.1;
    [self.blurImages addObject:self.headerImageView.image];
    for (NSUInteger i = 0; i < self.headerImageView.frame.size.height/10; i++) {
        [self.blurImages addObject:[self.headerImageView.image boxblurImageWithBlur:factor]];
        factor += 0.04;
    }
}


- (void) blurWithOffset:(float)offset {
    NSInteger index = offset / 10;
    if (index < 0) {
        index = 0;
    }
    else if(index >= self.blurImages.count) {
        index = self.blurImages.count - 1;
    }
    UIImage *image = self.blurImages[index];
    if (self.headerImageView.image != image) {
        [self.headerImageView setImage:image];
    }
}

@end