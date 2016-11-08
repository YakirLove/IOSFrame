//
//  NDKeyBoardPhotoPicker.m
//  NDUIToolKit
//
//  Created by zhangx on 15/7/10.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import "NDKeyBoardPhotoPicker.h"
#import "EasyTableView.h"
#import "NDKeyBoardPhoto.h"
#import "NDPhotoBrowseViewController.h"
#import "NDPhotoEditViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface NDKeyBoardPhotoPicker()<EasyTableViewDelegate,NDKeyBoardPhotoDelegate,NDAssetsLibraryRequestDelegate,NDPhotoBrowseViewControllerDelegate,NDPhotoEditViewControllerDelegate>
{
    EasyTableView *photoTable;
    NSMutableArray *photos;
    NDAssetsLibraryRequest *request;
    UIButton *moreBtn;
    
    NDPhotoBrowseViewController *brower;
}

@end

@implementation NDKeyBoardPhotoPicker


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _maxImageCnt = 12; //默认最多12张
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumsPhotoChanged:) name:ALBUMS_PHOTO_CHANGED object:nil];
        
        CGRect frameRect = CGRectMake(0, 0, self.width, self.height);
        photoTable = [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns:0 ofWidth:self.height];
        photoTable.delegate = self;
        photoTable.tableView.backgroundColor = [UIColor clearColor];
        photoTable.tableView.allowsSelection = YES;
        photoTable.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        photoTable.autoresizingMask	= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
       
        [self addSubview:photoTable];
        
        request = [[NDAssetsLibraryRequest alloc] init];
        request.delegate = self;
        [request startRequestAllPhoto];
        
        moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake(10, self.height - 45 - 10, 45, 45);
        [moreBtn setImage:[UIImage imageInUIToolKitProject:@"musicPreviewButtonBackground"] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(moreImageClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *moreImg = [[UIImageView alloc] initWithFrame:CGRectMake((45- 20)/2.0, (45- 20)/2.0, 20, 20)];
        moreImg.image = [UIImage imageInUIToolKitProject:@"photoGridIcon"];
        [moreBtn addSubview:moreImg];
        [self addSubview:moreBtn];
        
    }
    return self;
}

/**
 *  相册图片修改
 *
 *  @param sender 通知
 */
- (void)albumsPhotoChanged:(id)sender
{
    [request startRequestAllPhoto];
}

/**
 *  更多按钮点击
 *
 *  @param btn 按钮
 */
-(void)moreImageClick:(UIButton *)btn
{
    brower = [[NDPhotoBrowseViewController alloc] init];
    brower.defaultStatusBar = YES;
    brower.maxPhotoCnt = _maxImageCnt;
    brower.photoColCnt = 3;
    brower.isCameraEnable = YES;
    brower.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:brower];
    [self.viewController presentViewController:navc animated:YES completion:^{
        
    }];
}

-(void)changeViewController:(UIViewController *)cameraVC browseViewController:(NDPhotoBrowseViewController *)browseViewController
{
    [browseViewController.navigationController dismissViewControllerAnimated:YES completion:^{
        [self.viewController presentViewController:cameraVC animated:YES completion:^{
            
        }];
    }];
    
    
    
}

/**
 *  相册图片加载完毕
 *
 *  @param photoData 相册图片
 */
-(void)allPhotoDidLoad:(NSArray *)photoData
{
    photos = [[NSMutableArray alloc] initWithArray:[[photoData reverseObjectEnumerator] allObjects]];
    photoTable.numberOfCells = photos.count;
    [photoTable reloadData];
    photoTable.contentOffset = CGPointMake(0, 0);
}

-(void)loadPhotoFail:(NSString *)errorMsg
{
    
}

/**
 *  样式
 *
 *  @param easyTableView 表格
 *  @param rect          位置信息
 *
 *  @return cell
 */
- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect {
    NDKeyBoardPhoto *photo = [[NDKeyBoardPhoto alloc] initWithFrame:CGRectMake(1, 0, rect.size.width - 2, rect.size.height)];
    photo.delegate = self;
    return photo;
}

/**
 *  数据填充
 *
 *  @param easyTableView 表格
 *  @param view          cell
 *  @param indexPath     行列
 */
- (void)easyTableView:(EasyTableView *)easyTableView setDataForView:(UIView *)view forIndexPath:(NSIndexPath *)indexPath {
    NDKeyBoardPhoto *photo = (NDKeyBoardPhoto *)view;
    photo.index = indexPath.row;
    NDAsset *asset = photos[indexPath.row];
    photo.image = asset.thumbnailImage;
}


/**
 *  滚动时候去掉选中状态
 *
 *  @param easyTableView 表格
 *  @param contentOffset 位置
 */
- (void)easyTableView:(EasyTableView *)easyTableView scrolledToOffset:(CGPoint)contentOffset
{
    for (NDKeyBoardPhoto *photo in easyTableView.visibleViews) {
        [photo removeEditView];
    }
}


/**
 *  同时只有一直图片在编辑状态
 *
 *  @param photo 当前选中的图片
 */
-(void)didBecomeEditStatus:(NDKeyBoardPhoto *)photo
{
    for (NDKeyBoardPhoto *photoItem in photoTable.visibleViews) {
        if (photoItem != photo) {
            [photoItem removeEditView];
        }
    }
}


#pragma mark - photo delegate
-(void)didEditBtnClick:(NDKeyBoardPhoto *)photo
{
    [photo removeEditViewWithBlock:^{
        NDPhotoEditViewController *edvc = [[NDPhotoEditViewController alloc] initWithOriImage:[photo backgroundImage]];
        edvc.defaultStatusBar = YES;
        edvc.delegate = self;
        [self.viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:edvc] animated:YES completion:^{
            
        }];
    }];
}


#pragma mark 发送按钮点击
-(void)didSendBtnClick:(NDKeyBoardPhoto *)photo
{
    if ([self.delegate respondsToSelector:@selector(didPickedImages:pickerView:)]) {
        NDAsset *asset = photos[photo.index];
        NDPhotoData *photoData = [[NDPhotoData alloc] init];
        photoData.asset = asset;
        [self.delegate didPickedImages:@[photoData] pickerView:self];
    }
    [photo removeEditView];
}

#pragma mark - NDPhotoBrowseViewControllerDelegate
/**
 *  发送图片
 *
 *  @param imagesArray 图片数组 NDPhotoData对象 请使用 imageToShow 方法获取照片
 *  @param browseViewController 图片浏览控制器
 */
-(void)didSendImages:(NSArray *)imagesArray browseViewController:(UIViewController *)browseViewController
{
    
    if ([self.delegate respondsToSelector:@selector(didPickedImages:pickerView:)]) {
        [self.delegate didPickedImages:imagesArray pickerView:self];
    }
    
    if ([browseViewController isKindOfClass:[NDPhotoBrowseViewController class]]) {  ///如果是图片选择控件
        [browseViewController.navigationController dismissViewControllerAnimated:YES completion:^{
            brower = nil;
        }];
    }else{  ///如果是摄像头
        [browseViewController dismissViewControllerAnimated:YES completion:^{
            brower = nil;
        }];
    }
    
    
}

#pragma mark - NDPhotoEditViewControllerDelegate
/**
 *  编辑图片完成
 *
 *  @param editedImage 图片编辑完成
 *  @param editViewController 编辑图片的控制器
 */
-(void)didFinishedEdit:(UIImage *)editedImage editViewController:(NDPhotoEditViewController *)editViewController
{
    
    if ([self.delegate respondsToSelector:@selector(didPickedImages:pickerView:)]) {
        NDPhotoData *photoData = [[NDPhotoData alloc] init];
        photoData.orgImage = editedImage;
        [self.delegate didPickedImages:@[photoData] pickerView:self];
    }
    
    [editViewController.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALBUMS_PHOTO_CHANGED object:nil];
}

@end
