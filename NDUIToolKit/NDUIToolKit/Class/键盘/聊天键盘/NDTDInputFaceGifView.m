//
//  NDTDInputFaceGifView.m
//  NDTDChat
//
//  Created by 林 on 8/3/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import "NDTDInputFaceGifView.h"

@interface NDTDInputFaceGifView ()<UIScrollViewDelegate>
{
    NSDictionary *menuDic;
    NSMutableArray *gifArray;
    NSMutableArray *plistArray;
    NSInteger pageCount;
    NSInteger rowNumber;
    NSInteger verticaNumber;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
}
@end

@implementation NDTDInputFaceGifView
@synthesize gifSize;
@synthesize isShowGifTitle;

-(instancetype)initWithFrame:(CGRect)frame gifsDic:(NSDictionary *)gifsDics
{
    self = [super initWithFrame:frame];
    if (self) {
        menuDic = gifsDics;
        [self initData];
        [self setConfigurationInformation];
        [self initSubviews];
    }
    return self;
}

-(void)initData
{
    gifArray = [[NSMutableArray alloc]init];
    plistArray = [[NSMutableArray alloc]init];
    rowNumber = 4;
    verticaNumber = 2;
    isShowGifTitle = NO;
}

-(void)initSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*pageCount, scrollView.frame.size.height);
    
    pageControl = [[UIPageControl alloc]init];
    pageControl.frame = CGRectMake((self.frame.size.width-120)/2,self.frame.size
                                   .height-20, 120, 20);
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1.0];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1.0];
    [self addSubview:pageControl];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = pageCount;
    [self addSubview:pageControl];
    pageControl.backgroundColor = [UIColor clearColor];
    
    [self refreshView];
}

-(void)refreshView
{
    for (UIView *view in scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger pageItemCount = rowNumber*verticaNumber;
    float verticalInterval = (self.frame.size.width-gifSize.width*rowNumber)/(rowNumber+1);
    float horizontalInterval = (self.frame.size.height-20-gifSize.height*verticaNumber-12)/verticaNumber-1;
    for (int i=0; i<pageCount; i++) {
        NSMutableArray *pageItemArray = [[NSMutableArray alloc]init];
        if (i != pageCount-1) {
            [pageItemArray addObjectsFromArray:[gifArray subarrayWithRange:NSMakeRange(i*pageItemCount,pageItemCount)]];
        }
        else
        {
            [pageItemArray addObjectsFromArray:[gifArray subarrayWithRange:NSMakeRange(i*pageItemCount,gifArray.count-i*pageItemCount)]];
        }
        int line = 0;
        int column = 0;
        for (int j=0; j<pageItemArray.count; j++) {
            line = j/rowNumber;
            column = j%rowNumber;
            UIImage *image = [UIImage imageWithContentsOfFile:[[menuDic objectForKey:@"path"] stringByAppendingPathComponent:[pageItemArray objectAtIndex:j]]];
            UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            itemBtn.backgroundColor = [UIColor clearColor];
            itemBtn.tag = i*(rowNumber*verticaNumber)+j;
            [itemBtn setBackgroundImage:image forState:UIControlStateNormal];
            [itemBtn addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
            itemBtn.frame = CGRectMake(i*scrollView.frame.size.width+verticalInterval+(gifSize.width+verticalInterval)*column,12+(gifSize.height+horizontalInterval)*line, gifSize.width, gifSize.height);
            [scrollView addSubview:itemBtn];
            if (isShowGifTitle==YES) {
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(itemBtn.frame.origin.x-(verticalInterval/2)+5, CGRectGetMaxY(itemBtn.frame), itemBtn.frame.size.width+verticalInterval-10, 15)];
                titleLabel.textColor = [UIColor grayColor];
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.text = [self regularBrackets:[pageItemArray objectAtIndex:j]];
                titleLabel.font = [UIFont systemFontOfSize:12];
                [scrollView addSubview:titleLabel];
            }
        }
    }
}

-(void)setConfigurationInformation
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[menuDic objectForKey:@"path"]]) {
        NSArray *array = [fileManager contentsOfDirectoryAtPath:[menuDic objectForKey:@"path"] error:nil];
        for (int i=0; i<array.count; i++) {
            NSString *string = [array objectAtIndex:i];
            if ([string rangeOfString:@".png"].length>0 || [string rangeOfString:@".jpg"].length) {
                if ([string rangeOfString:@"标志"].length==0) {
                    [gifArray addObject:string];
                }
            }
            else if ([string rangeOfString:@".plist"].length>0)
            {
                [plistArray addObject:string];
            }
            else
            {
                
            }
        }
    }
    /* 分割页面 */
    pageCount = gifArray.count/(rowNumber*verticaNumber);
    if (gifArray.count!=0) {
        UIImage *image = [UIImage imageWithContentsOfFile:[[menuDic objectForKey:@"path"] stringByAppendingPathComponent:[gifArray objectAtIndex:0]]];
        [self adjustGifSize:image.size];
    }
}

-(void)itemAction:(UIButton *)send
{
    NSString *gifName = [gifArray objectAtIndex:send.tag];
    NSLog(@"gifName=%@",gifName);
}

-(NSString *)regularBrackets:(NSString *)originalString
{
    if (originalString!=nil) {
        if ([originalString rangeOfString:@"@2x.png"].length>0) {
            NSString *newString = [originalString stringByReplacingOccurrencesOfString:@"@2x.png" withString:@""];
            return newString;
        }
        else if ([originalString rangeOfString:@".png"].length>0)
        {
            NSString *newString = [originalString stringByReplacingOccurrencesOfString:@"@.png" withString:@""];
            return newString;
        }
        else if ([originalString rangeOfString:@"@2x.jpg"].length>0)
        {
            NSString *newString = [originalString stringByReplacingOccurrencesOfString:@"@2x.jpg" withString:@""];
            return newString;
        }
        else if ([originalString rangeOfString:@".jpg"].length>0)
        {
            NSString *newString = [originalString stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
            return newString;
        }
        else
        {
            return nil;
        }
        
    }
    return nil;
}

-(void)setGifSize:(CGSize)gifSizes
{
    [self adjustGifSize:gifSizes];
    [self refreshView];
}

-(void)setIsShowGifTitle:(BOOL)isShowGifTitles
{
    isShowGifTitle = isShowGifTitles;
    [self refreshView];
}

-(void)adjustGifSize:(CGSize)size
{
    float with = size.width;
    float height = size.height;

    if (with<GifMinwith) {
        with = GifMinwith;
    }
    else if (gifSize.width>GifMaxWith)
    {
        with = GifMaxWith;
    }
    if (gifSize.height<GifMinHeight) {
        height= GifMinHeight;
    }
    else if (gifSize.height>GifMaxHeight)
    {
        height= GifMaxHeight;
    }
    gifSize = CGSizeMake(with, height);

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    NSInteger page = _scrollView.contentOffset.x/_scrollView.frame.size.width;
    pageControl.currentPage = page;
}


@end
