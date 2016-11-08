//
//  MBTwitterScroll.h
//  TwitterScroll
//
//  Created by Martin Blampied on 07/02/2015.
//  Copyright (c) 2015 MartinBlampied. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NDTwitterScrollTypeTable,
    NDTwitterScrollTypeScroll,
} NDTwitterScrollType;


@interface NDTwitterScrollView : UIView <UIScrollViewDelegate>


- (NDTwitterScrollView *)initTableViewWithFrame:(CGRect)frame headerView:(UIView *)headerView;

- (NDTwitterScrollView *)initScrollViewFrame:(CGRect)frame headerView:(UIView *)headerView contentHeight:(CGFloat)height;

- (void)prepareForBlurImages;

- (void)disableRefresh;

@property (strong, nonatomic) UIView *header;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NDHeaderViewTableView *tableView;
@property (nonatomic,assign) CGFloat orgHeight;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (nonatomic, strong) NSMutableArray *blurImages;

@end