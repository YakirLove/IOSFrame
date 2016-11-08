//
//  NDPhotoFilterView.m
//  NDUIToolKit
//
//  Created by zhangx on 15/7/31.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDPhotoFilterView.h"
#import "EasyTableView.h"
#import "NDPhotoFilterCellView.h"
#import "LLARingSpinnerView.h"
#import "NDPhotoData.h"

@implementation NDFilterData

#pragma mark 初始化
-(id)initWithName:(NSString *)filterName filterType:(NDUIFilterType)filterType
{
    self = [super init];
    if (self) {
        self.filterName = filterName;
        self.filterType = filterType;
    }
    return self;
}

@end


@interface NDPhotoFilterView()<EasyTableViewDelegate,NDPhotoFilterCellViewDelegate>{
    NSMutableArray *filterArray;   ///< 数据列表
    EasyTableView *filterTableView;   ///< view表格
    LLARingSpinnerView *loadingView; ///< 等待图
    NDPhotoData *tempData; ///< 缓存图片信息
    NSInteger selectedFilterIndex; ///< 当前选中的滤镜的index
}

@end

@implementation NDPhotoFilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initData];
        
        [self initTableView];
    }
    return self;
}

#pragma mark 初始化滤镜数据
-(void)initData
{
    filterArray = [[NSMutableArray alloc] init];
    [filterArray addObject:[[NDFilterData alloc] initWithName:@"无" filterType:NDUI_FILTER_TYPE_WU]];
//    [filterArray addObject:[[NDFilterData alloc] initWithName:@"现代" filterType:NDUI_FILTER_TYPE_XIANDAI]];
    [filterArray addObject:[[NDFilterData alloc] initWithName:@"奶昔色" filterType:NDUI_FILTER_TYPE_NAIXISE]];
//    [filterArray addObject:[[NDFilterData alloc] initWithName:@"柔和" filterType:NDUI_FILTER_TYPE_ROUHE]];
    [filterArray addObject:[[NDFilterData alloc] initWithName:@"翡翠绿" filterType:NDUI_FILTER_TYPE_FEICUILV]];
    [filterArray addObject:[[NDFilterData alloc] initWithName:@"复古" filterType:NDUI_FILTER_TYPE_FUGU]];
//    [filterArray addObject:[[NDFilterData alloc] initWithName:@"炫丽" filterType:NDUI_FILTER_TYPE_XUANLI]];
    [filterArray addObject:[[NDFilterData alloc] initWithName:@"增强" filterType:NDUI_FILTER_TYPE_ZENGQIANG]];
    [filterArray addObject:[[NDFilterData alloc] initWithName:@"金色" filterType:NDUI_FILTER_TYPE_JINSE]];
    [filterArray addObject:[[NDFilterData alloc] initWithName:@"艳阳" filterType:NDUI_FILTER_TYPE_YANYANG]];
    [filterArray addObject:[[NDFilterData alloc] initWithName:@"米黄" filterType:NDUI_FILTER_TYPE_MIHUANG]];
    [filterArray addObject:[[NDFilterData alloc] initWithName:@"灯光" filterType:NDUI_FILTER_TYPE_DENGGUANG]];
    [filterArray addObject:[[NDFilterData alloc] initWithName:@"对比" filterType:NDUI_FILTER_TYPE_DUIBI]];
    [filterArray addObject:[[NDFilterData alloc] initWithName:@"铜色" filterType:NDUI_FILTER_TYPE_TONGSE]];
    [filterArray addObject:[[NDFilterData alloc] initWithName:@"淡雅" filterType:NDUI_FILTER_TYPE_DANYA]];
    [filterArray addObject:[[NDFilterData alloc] initWithName:@"高亮" filterType:NDUI_FILTER_TYPE_GAOLIANG]];
//    [filterArray addObject:[[NDFilterData alloc] initWithName:@"冷色" filterType:NDUI_FILTER_TYPE_LENGSE]];
    [filterArray addObject:[[NDFilterData alloc] initWithName:@"黑白" filterType:NDUI_FILTER_TYPE_HEIBAI]];
}

#pragma mark 初始化表格
- (void)initTableView
{
    filterTableView = [[EasyTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) numberOfColumns:0 ofWidth:self.height - 14];
    filterTableView.tableView.showsVerticalScrollIndicator = NO;
    filterTableView.delegate = self;
    filterTableView.tableView.backgroundColor = [UIColor clearColor];
    filterTableView.tableView.allowsSelection = YES;
    filterTableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    filterTableView.autoresizingMask	= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    [self addSubview:filterTableView];

}

- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect
{
    NDPhotoFilterCellView * filterView= [[NDPhotoFilterCellView alloc] initWithFrame:CGRectMake(3, 0, rect.size.width - 6, rect.size.height)];
    filterView.delegate = self;
    return filterView;
}


- (void)easyTableView:(EasyTableView *)easyTableView setDataForView:(UIView *)view forIndexPath:(NSIndexPath*)indexPath
{
    NDFilterData *filterData = filterArray[indexPath.row];
    NDPhotoFilterCellView * filterView = (NDPhotoFilterCellView *)view;
    [filterView fillData:filterData.filerImage name:filterData.filterName];
    filterView.index = indexPath.row;
    if (indexPath.row == selectedFilterIndex) {
        filterView.isSelected = YES;
    }else{
        filterView.isSelected = NO;
    }
}

#pragma mark - NDPhotoFilterCellViewDelegate
- (void)didClick:(NDPhotoFilterCellView *)cell
{
    if (selectedFilterIndex != cell.index) {
        selectedFilterIndex = cell.index;
        for (NDPhotoFilterCellView *cellView in filterTableView.visibleViews) {
            cellView.isSelected = cellView.index == selectedFilterIndex;
        }
        
        if ([self.delegate respondsToSelector:@selector(didFilterSelected:)]) {
            [self.delegate didFilterSelected:filterArray[selectedFilterIndex]];
        }
        
    }
}

#pragma mark -

#pragma mark 显示滤镜图
- (void)showFilterImages:(NDPhotoData *)photoData
{
    if (tempData == photoData) {  //如果图片没有更改 那么不重新加载滤镜图
        return;
    }
    
    
    UIImage *thumbnailImage = [photoData.asset thumbnailImage];  //缩略图拿来做滤镜图展示
    CGSize oriSize = thumbnailImage.size;
    if (oriSize.width > oriSize.height) {
        oriSize = CGSizeMake(oriSize.width * self.height / oriSize.height, self.height);
    }else{
        oriSize = CGSizeMake(self.height , oriSize.height * self.height / oriSize.width);
    }
    UIImage *oriImage = [UIImage scaleToSize:[photoData.asset thumbnailImage] size:oriSize];
    
    loadingView = [[LLARingSpinnerView alloc] initWithFrame:CGRectMake((self.width - self.height + 30)/2.0, 15, self.height - 30,self.height - 30)];
    [self addSubview:loadingView];
    [loadingView startAnimating]; //等待对话框
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [loadingView stopAnimating], [loadingView removeFromSuperview] ,loadingView = nil; //关闭等待对话框
        for (NDFilterData* data in filterArray) {
            data.filerImage = [UIImage imageWithFilterType:data.filterType oriImage:oriImage];
        }
        filterTableView.numberOfCells = filterArray.count;
        
        selectedFilterIndex = 0;
        if (photoData.selecteFilter != nil) { //回填滤镜
            NSInteger index = [filterArray indexOfObject:photoData.selecteFilter];
            selectedFilterIndex = index;
            [filterTableView selectCellAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES];
        }else{
            [filterTableView selectCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
        }
        
        [filterTableView reloadData];
        
        
    });
    
    tempData = photoData;
}

#pragma mark 删除缓存滤镜图片
- (void)resetData
{
    filterTableView.tableView.contentOffset = CGPointZero;
    
    for (NDPhotoFilterCellView *cellView in filterTableView.visibleViews) {
        cellView.isSelected = NO;
        [cellView fillData:nil name:@""];
    }
    
    for (NDFilterData* data in filterArray) {
        data.filerImage = nil;
    }
    
    tempData = nil;
    
}

#pragma mark 删除缓存滤镜图片、如果已经是同一个图片 那么不删除
- (void)resetDataWithPhotoData:(NDPhotoData *)photoData
{
    if (photoData != tempData) {
        [self resetData];
    }
}

@end
