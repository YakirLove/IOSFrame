//
//  NDTDInputFacePictureView.m
//  NDTDChat
//
//  Created by 林 on 8/3/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import "NDTDInputFacePictureView.h"

@interface NDTDInputFacePictureView ()<UIScrollViewDelegate>
{
    NSDictionary *menuDic;
    NSMutableArray *emojiArray;
    NSMutableArray *plistArray;
    NSInteger pageCount;
    NSInteger rowNumber;
    NSInteger verticaNumber;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
}

@end

@implementation NDTDInputFacePictureView
@synthesize imageSize;
@synthesize delegate;

-(instancetype)initWithFrame:(CGRect)frame emojisDic:(NSDictionary *)emojisDics
{
    self = [super initWithFrame:frame];
    if (self) {
        menuDic = emojisDics;
        [self initData];
        [self setConfigurationInformation];
        [self initSubviews];
    }
    return self;
}

-(void)initData
{
    emojiArray = [[NSMutableArray alloc]init];
    plistArray = [[NSMutableArray alloc]init];
    if (self.frame.size.width>320) {
        rowNumber = 8;
    }
    else
    {
        rowNumber = 7;
    }
    verticaNumber = 3;
}

-(void)setConfigurationInformation
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[menuDic objectForKey:@"path"]]) {
        NSArray *array = [fileManager contentsOfDirectoryAtPath:[menuDic objectForKey:@"path"] error:nil];
        for (int i=0; i<array.count; i++) {
            NSString *string = [array objectAtIndex:i];
            if ([string rangeOfString:@".png"].length>0 || [string rangeOfString:@".jpg"].length
                || [string rangeOfString:@".tiff"].length) {
                if ([string rangeOfString:@"标志"].length==0 && [string rangeOfString:@"删除"].length==0) {
                    [emojiArray addObject:string];
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
    NSInteger pageItemCount = rowNumber*verticaNumber-1;
    pageCount = emojiArray.count%pageItemCount == 0? emojiArray.count/pageItemCount:emojiArray.count/pageItemCount+1;
    if (emojiArray.count!=0) {
        UIImage *image = [UIImage imageWithContentsOfFile:[[menuDic objectForKey:@"path"] stringByAppendingPathComponent:[emojiArray objectAtIndex:0]]];
        [self adjustImageSize:image.size];
     }
}

-(void)setImageSize:(CGSize)imageSizes;
{
    [self adjustImageSize:imageSizes];
    [self refreshView];
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
                                   .height-30, 120, 20);
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
    
    NSInteger pageItemCount = rowNumber*verticaNumber-1;
    float verticalInterval = (self.frame.size.width-imageSize.width*rowNumber)/(rowNumber+1);
    float HorizontalInterval = (self.frame.size.height-30-imageSize.height*verticaNumber-12)/verticaNumber-1;
    for (int i=0; i<pageCount; i++) {
        NSMutableArray *pageItemArray = [[NSMutableArray alloc]init];
        if (i != pageCount-1) {
            [pageItemArray addObjectsFromArray:[emojiArray subarrayWithRange:NSMakeRange(i*pageItemCount,pageItemCount)]];
        }
        else
        {
            [pageItemArray addObjectsFromArray:[emojiArray subarrayWithRange:NSMakeRange(i*pageItemCount,emojiArray.count-i*pageItemCount)]];
        }
        [pageItemArray addObject:@"删除.png"];
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
            itemBtn.frame = CGRectMake(i*scrollView.frame.size.width+verticalInterval+(imageSize.width+verticalInterval)*column,12+(imageSize.height+HorizontalInterval)*line, imageSize.width, imageSize.height);
            [scrollView addSubview:itemBtn];
        }
    }

    
}

-(void)itemAction:(UIButton *)send
{
    NSInteger index = send.tag+1;
    if (index%(rowNumber*verticaNumber)==0 || index==emojiArray.count+pageCount) {
        //点击删除按钮
        NSLog(@"点击的删除按钮");
        if (delegate && [delegate respondsToSelector:@selector(didClickDelete:)]) {
            [delegate didClickDelete:self];
        }
    }
    else
    {
        NSInteger offset = send.tag/(rowNumber*verticaNumber);
        NSString *imageName = [emojiArray objectAtIndex:send.tag-offset];
        NSString *regex_emoji = Regex_emoji;//表情的正则表达式
        if ([regex_emoji isEqualToString:@""]) {
            if (delegate && [delegate respondsToSelector:@selector(didClickPictureface:imagePath:imageName:)]) {
                NSArray *array=[imageName componentsSeparatedByString:@"."];
                [delegate didClickPictureface:self imagePath:[[menuDic objectForKey:@"path"] stringByAppendingPathComponent:imageName] imageName:[NSString stringWithFormat:@"[/%@]",[array objectAtIndex:0]]];
            }

        }
        else
        {
            NSRange range = [imageName rangeOfString:regex_emoji options:NSRegularExpressionSearch];
            if (range.location != NSNotFound) {
                if (delegate && [delegate respondsToSelector:@selector(didClickPictureface:imagePath:imageName:)]) {
                    [delegate didClickPictureface:self imagePath:[[menuDic objectForKey:@"path"] stringByAppendingPathComponent:imageName] imageName:[imageName substringWithRange:range]];
                }
            }

        }
    }
}

-(void)adjustImageSize:(CGSize)size
{
    float with = size.width;
    float height = size.height;
    
    if (with<ImageMinwith) {
        with = ImageMinwith;
    }
    else if (with>ImageMaxWith)
    {
        with = ImageMaxWith;
    }
    if (height<ImageMinHeight) {
        height= ImageMinHeight;
    }
    else if (height>ImageMaxHeight)
    {
        height= ImageMaxHeight;
    }
    imageSize = CGSizeMake(with, height);
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    NSInteger page = _scrollView.contentOffset.x/_scrollView.frame.size.width;
    pageControl.currentPage = page;
}

@end
