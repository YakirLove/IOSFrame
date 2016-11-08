//
//  NDPhotoBrowseViewController.m
//  NDUIToolKit 相册图片浏览
//
//  Created by zhangx on 15/7/22.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDPhotoBrowseViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NDPhotoBrowseTableView.h"
#import "NDAlbumsTableView.h"
#import "NDPhotoPreview.h"
#import "DXPopover.h"
#import "NDPhotoBrowseToolbar.h"
#import "NDPhotoFilterView.h"
#import "NDPhotoData.h"
#import "NDPhotoBrowseTableCell.h"
#import "TOCropViewController.h"
#import "UIImage+CropRotate.h"

@interface NDPhotoBrowseViewController()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,NDAssetsLibraryRequestDelegate,NDAlbumsTableViewDelegate,NDPhotoBrowseTableViewDelegate,NDPhotoBrowseToolbarDelegate,NDPhotoFilterViewDelegate,NDPhotoPreviewDelegate,TOCropViewControllerDelegate>{
    UIButton *backBtn; ///< 导航栏 返回的按钮
    UIButton *sendBtn; ///< 导航栏 发送的按钮
    
    UIButton *chooseBtn; ///< 导航栏 选择按钮
    UIButton *cancelBtn; ///< 导航栏 取消按钮按钮
    
    
    DXPopover *albumsPopView; ///< 相册目录弹出框
    UILabel *navTitle; ///< 导航条标题
    UILabel *navTitlePreview; ///< 导航条标题  预览
    
    NDAssetsLibraryRequest *assetRequest; ///< 相册请求类
    
    NDPhotoBrowseTableView *photoTable; ///< 图片表格
    
    NSInteger selectedAlbumIndex; ///< 选中的相册索引
    
    NSMutableArray *albums; ///< 相册数据
    UIImageView *arrowView; ///< 向下箭头 表示有更多相册
    
    NDAlbumsTableView *contentView; ///< 弹出框内容视图
    
    CGPoint offsetBak; ///< 备份初始位移
    
    NDPhotoPreview *previewSC; ///< 放大之后的预览视图
    
    NDPhotoBrowseToolbar *toolBar; ///< 图片编辑的工具栏
    
    BOOL inCropMode; ///< 裁剪模式
    
    UIImagePickerController *cameraVC; ///< 系统拍照视图
}

@end

@implementation NDPhotoBrowseViewController

-(id)init
{
    self = [super init];
    if (self) {
        _maxPhotoCnt = NDUI_MAX_PHOTOS_PICKED;
        _isCameraEnable = YES;
        _photoColCnt = NDUI_ROW_PHOTO_CNT;
        self.doneTitle = @"发送";
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavBar];
    
    sendBtn.enabled = NO;
    selectedAlbumIndex = 0;
    
    [self requestAssetData];
    
    [self createPhotoTable];
    [self createPreview];
    [self createPhotoToolbar];
}

/**
 *  创建工具栏
 */
- (void)createPhotoToolbar
{
    toolBar = [[NDPhotoBrowseToolbar alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, NDUI_TOOL_BAR_HEIGHT) funcFlag:@"1|1|1"];
    toolBar.delegate = self;
    [self.view addSubview:toolBar];
}

/**
 *  创建预览视图
 */
-(void)createPreview
{
    previewSC = [[NDPhotoPreview alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64 - NDUI_TOOL_BAR_HEIGHT)];
    previewSC.viewDelegate = self;
    [self.view addSubview:previewSC];
    previewSC.alpha = 0;
}

/**
 *  创建图片表格
 */
-(void)createPhotoTable
{
    photoTable = [[NDPhotoBrowseTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    photoTable.cellDelegate = self;
    
    [self.view addSubview:photoTable];
}

/**
 *  请求相册数据
 */
-(void)requestAssetData
{
    assetRequest = [[NDAssetsLibraryRequest alloc] init];
    assetRequest.delegate  = self;
    [assetRequest startRequestAllAlbum];
}

#pragma mark 重新加载图片数据
-(void)reloadPictureData
{
    [assetRequest startRequestAllAlbum];
}


#pragma mark - NDAssetsLibraryRequestDelegate
#pragma mark 请求失败回调
-(void)loadPhotoFail:(NSString *)errorMsg
{
    
}

#pragma mark 请求相册成功回调
-(void)allAlbumDidLoad:(NSArray *)albumData
{
    
    albums = [[NSMutableArray alloc] init];
    for (NDAssetsGroup *group in albumData) {  //只显示有相片的相簿
        if (group.numberOfAssets > 0) {
            [albums addObject:group];
        }
    }
    
    //加载弹出框内容
    contentView = [[NDAlbumsTableView alloc] initWithFrame:CGRectZero];
    contentView.albumsDelegate = self;
    CGFloat tableHeight = albums.count * contentView.rowHeight;
    tableHeight = tableHeight > self.view.height - 200 ? self.view.height - 200 : tableHeight; //最大高度只能是self.view.height - 200
    contentView.frame = CGRectMake(2, 70, self.view.width - 4, tableHeight);
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 5.0f;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.selectedIndex = 0;
    contentView.dataArray = albums;
    [contentView reloadData];
    
    [self loadPhotoData];
    
    offsetBak = photoTable.contentOffset;
}

#pragma mark 请求某个相册照片成功回调
-(void)photoInGroupDidLoad:(NSArray *)photoData
{
    [photoTable.dataArray removeAllObjects],photoTable.dataArray = nil;
//    [photoTable.selectedArray removeAllObjects];
    
    photoTable.dataArray = [[NSMutableArray alloc] init];
    NDPhotoData *itemData;
    for (NSInteger i = photoData.count - 1; i >= 0 && photoData.count > 0; i--) {
        itemData = [[NDPhotoData alloc] init];
        itemData.asset = photoData[i];
        [photoTable.dataArray addObject:itemData];
    }
    
    if (_isCameraEnable && selectedAlbumIndex == 0) {
        [photoTable.dataArray insertObject:[[NDAsset alloc] initWithAsset:nil] atIndex:0];
        previewSC.indexOffset = 1;
    }else{
        previewSC.indexOffset = 0;
    }
    photoTable.colCnt = self.photoColCnt;
    [photoTable reloadData];
    photoTable.contentOffset = offsetBak;
    
    previewSC.dataArray = photoTable.dataArray;
    
}

#pragma mark -

/**
 *  加载图片数据
 */
-(void)loadPhotoData
{
    
    if(albums.count == 0){
        [self setNavTitle:@"相机胶卷"];
        navTitle.userInteractionEnabled = NO;
        arrowView.hidden = YES;
        [self photoInGroupDidLoad:@[]];
        [photoTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }else{
        NDAssetsGroup *group = albums[selectedAlbumIndex];
        [self setNavTitle:group.groupName];
        [assetRequest startRequestPhotoInGroup:group];
    }
    
    
}

/**
 *  设置当前相册标题
 *
 *  @param title 标题
 */
-(void)setNavTitle:(NSString *)title
{
    navTitle.text = title;
    CGFloat textWidth = [title getStringWidth:[UIFont systemFontOfSize:NDUI_LABEL_DEFUALT_FONT_SIZE] maxSize:CGSizeMake(NDUI_SCREEN_WIDTH, navTitle.height)];
    arrowView.frame = CGRectMake(( arrowView.superview.width + textWidth ) / 2.0 + 10, (arrowView.superview.height - 3 ) / 2.0, 10, 5);
}

/**
 *  创建导航条
 */
-(void)createNavBar
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 49, NDUI_NAV_BAR_HEIGHT)];
    cancelBtn = [self createNavBarBtn];
    cancelBtn.frame = leftView.bounds;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = leftView.bounds;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 0, 7, 4);
    [backBtn setImage:[UIImage imageInUIToolKitProject:@"icon-back-to-grid"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [leftView addSubview:cancelBtn];
    [leftView addSubview:backBtn];
    
    backBtn.alpha = 0;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 49, NDUI_NAV_BAR_HEIGHT)];
    
    sendBtn = [self createNavBarBtn];
    sendBtn.frame = CGRectMake(0, 0, 49, NDUI_NAV_BAR_HEIGHT);
    [sendBtn setTitle:self.doneTitle forState:UIControlStateNormal];
    sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight ;
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:sendBtn];
    
    chooseBtn = [self createNavBarBtn];
    chooseBtn.frame = sendBtn.frame;
    [chooseBtn setTitle:@"选中" forState:UIControlStateNormal];
    chooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight ;
    [chooseBtn addTarget:self action:@selector(chooseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:chooseBtn];
    
    chooseBtn.alpha = 0;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    [self createNavBarTitle];
}

/**
 *  设置完成标题
 *
 *  @param doneTitle 完成标题
 */
- (void)setDoneTitle:(NSString *)doneTitle
{
    _doneTitle = [doneTitle copy];
    [sendBtn setTitle:self.doneTitle forState:UIControlStateNormal];
}

/**
 *  创建导航栏title
 */
-(void)createNavBarTitle
{
    UIView *titlePanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NDUI_SCREEN_WIDTH - ( 49 + 22 )* 2, NDUI_NAV_BAR_HEIGHT)];
    navTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, titlePanel.width - 40, titlePanel.height)];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.font = [UIFont boldSystemFontOfSize:NDUI_LABEL_DEFUALT_FONT_SIZE];
    navTitle.userInteractionEnabled = YES;
    [navTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)]];
    [titlePanel addSubview:navTitle];
    
    navTitlePreview = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titlePanel.width, titlePanel.height)];
    navTitlePreview.textAlignment = NSTextAlignmentCenter;
    navTitlePreview.font = [UIFont boldSystemFontOfSize:NDUI_LABEL_DEFUALT_FONT_SIZE];
    navTitlePreview.text = @"预览";
    navTitlePreview.alpha = 0;
    [titlePanel addSubview:navTitlePreview];
    
    arrowView = [[UIImageView alloc] initWithImage:[UIImage imageInUIToolKitProject:@"downwardsArrowIcon"]];
    arrowView.frame = CGRectZero;
    [titlePanel addSubview:arrowView];
    
    
    self.navigationItem.titleView = titlePanel;
}

/**
 *  导航栏上按钮
 *
 *  @return 按钮
 */
-(UIButton *)createNavBarBtn
{
    UIButton *barBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    barBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft ;
    barBtn.titleLabel.font = [UIFont systemFontOfSize:NDUI_LABEL_DEFUALT_FONT_SIZE];
    [barBtn setTitleColor:[UIColor colorWithHexString:NDUI_SYSTEM_DEFUALT_FONT_COLOR] forState:UIControlStateNormal];
    [barBtn setTitleColor:[UIColor colorWithHexString:NDUI_SYSTEM_DEFUALT_FONT_DISABLE_COLOR] forState:UIControlStateDisabled];
    [barBtn setTitleColor:[UIColor colorWithHexString:NDUI_SYSTEM_DEFUALT_FONT_HIGHLIGHT_COLOR] forState:UIControlStateHighlighted];
    
    return barBtn;
}

/**
 *  取消按钮点击
 */
-(void)cancelBtnClick
{
    if (inCropMode) {
        [self outCropMode];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

/**
 *  选中按钮点击
 */
-(void)chooseBtnClick
{
    if (inCropMode) {
        //TODO 保存裁剪成果
        [self outCropMode];
    }else{
        //如果还未选中，那么选中图片
        if ([photoTable.selectedArray containsObject:[NSString stringWithFormat:@"%ld",(long)previewSC.nowIndex]] == NO) {
            if (self.maxPhotoCnt <= photoTable.selectedArray.count) {
                NSString *warnIngStr = [NSString isEmptyString:self.overMaxCntNotice] ? [NSString stringWithFormat:@"一次只能添加%ld张照片",(long)self.maxPhotoCnt] : self.overMaxCntNotice;
                ALERT_MSG(nil,warnIngStr);
            }else{
                [photoTable.selectedArray addObject:[NSString stringWithFormat:@"%ld",(long)previewSC.nowIndex]];
                [photoTable reloadData];
                sendBtn.enabled = photoTable.selectedArray.count != 0;
            }
        }
        [self gotoListPhotoMode];
    }
}

/**
 *  返回按钮点击
 */
-(void)backBtnClick
{
    [self gotoListPhotoMode];
}

/**
 *  发送按钮点击
 */
-(void)sendBtnClick
{
    if ([self.delegate respondsToSelector:@selector(didSendImages:browseViewController:)]) {
        NSMutableArray * selectedImageArray = [[NSMutableArray alloc] init];
        for (NSString *selectIndexStr in photoTable.selectedArray) {
            [selectedImageArray addObject:photoTable.dataArray[[selectIndexStr integerValue]]];
        }
        [self.delegate didSendImages:selectedImageArray browseViewController:self];
    }
}

/**
 *  标题点击
 *
 *  @param gr 标题点击
 */
-(void)titleClick:(id)sender
{
    [contentView reloadData];
    if (albumsPopView == nil) {
        albumsPopView = [[DXPopover alloc] init];
    }
    CGFloat marginLeft = (self.navigationController.view.width - contentView.width)/2.0;
    albumsPopView.contentInset = UIEdgeInsetsMake(0, marginLeft, 0, marginLeft);
    albumsPopView.backgroundColor = [UIColor whiteColor];
    
    UIView *titleView = self.navigationItem.titleView;
    CGPoint startPoint =
    CGPointMake(CGRectGetMidX(titleView.frame), CGRectGetMaxY(titleView.frame) + 10);
    [albumsPopView showAtPoint:startPoint
               popoverPostion:DXPopoverPositionDown
              withContentView:contentView
                       inView:self.navigationController.view];
}

#pragma mark - NDAlbumsTableViewDelegate
#pragma mark 选中某个相簿
- (void)didSelectedAlbum:(NSInteger)index
{
    if(selectedAlbumIndex != index){
        
        selectedAlbumIndex = index;
        [photoTable.selectedArray removeAllObjects];
        [self loadPhotoData];
    }
    
    [albumsPopView dismiss];
}


#pragma mark - NDPhotoBrowseTableViewDelegate
#pragma mark 图片长按
- (void)didImageLongPress : (UIImageView *)imageView
{
    [previewSC turnToPreview:self.view originalView:imageView];
    NDPhotoData *data = previewSC.dataArray[previewSC.nowIndex];
    [toolBar changeLuxStatus:data];
    [self gotoBigPhotoMode];
}

#pragma mark 拍照按钮点击
- (void)didCameraClick: (UIImageView *)imageView
{
    // 拍照
    if ([NDCameraUtils isCameraAvailable] && [NDCameraUtils doesCameraSupportTakingPhotos]) {
        cameraVC = [[UIImagePickerController alloc] init];
        cameraVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([NDCameraUtils isBackCameraAvailable] == NO) {
            cameraVC.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        cameraVC.mediaTypes = mediaTypes;
        cameraVC.delegate = self;
        
        
        if (photoTable.selectedArray.count == 0 && [self.delegate isKindOfClass:[NDKeyBoardPhotoPicker class]]) {
            
            if ([self.delegate respondsToSelector:@selector(changeViewController:browseViewController:)]) {
                [self.delegate changeViewController:cameraVC browseViewController:self];
            }
            
        }else{
            [self presentViewController:cameraVC animated:YES completion:^{
                
            }];
        }
        
        
        
    }else{
//        [NDToast showErrorMsg:@"您的设备不支持拍照！" completionBlock:^{
//            
//        }];
        ALERT_MSG(@"您的设备不支持拍照！", nil);
    }
}

/**
 *  图片点击
 *
 *  @param imageView 图片点击
 */
- (void)didImageClick: (UIImageView *)imageView
{
    sendBtn.enabled = photoTable.selectedArray.count != 0;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImageWriteToSavedPhotosAlbum(portraitImg, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

#pragma mark 保存到相册
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if(error != NULL){
//        [NDToast showBigErrorMsg:@"保存图片失败" completionBlock:^{
//            
//        }];
        ALERT_MSG(@"保存图片失败", nil);
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ALBUMS_PHOTO_CHANGED object:nil];
        
        if (photoTable.selectedArray.count != 0 || [self.delegate isKindOfClass:[NDKeyBoardPhotoPicker class]] == NO ) {
            
            [cameraVC dismissViewControllerAnimated:YES completion:^() {
                [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
                cameraVC = nil;
            }];
            
            NSMutableArray *newSelectedArray = [[NSMutableArray alloc] init];
            for (NSString *index in photoTable.selectedArray) {
                [newSelectedArray addObject:[NSString stringWithFormat:@"%ld",(long)[index integerValue]+1]];
            }
            photoTable.selectedArray = newSelectedArray;
            [self reloadPictureData];
        }else{
            
            if ([self.delegate respondsToSelector:@selector(didSendImages:browseViewController:)]) {
                NSMutableArray * selectedImageArray = [[NSMutableArray alloc] init];
                NDPhotoData *photoData = [[NDPhotoData alloc] init];
                photoData.orgImage = image;
//                photoData.filteredImage = image;
                [selectedImageArray addObject:photoData];
                [self.delegate didSendImages:selectedImageArray browseViewController:cameraVC];
            }
            
        }
    }
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
        
    }];
}


#pragma mark 最多可以选则多少张照片
- (NSInteger)maxPhotosPicked
{
    return _maxPhotoCnt;
}

#pragma mark 是否启用拍照功能
- (BOOL)cameraEnable
{
    return _isCameraEnable && selectedAlbumIndex == 0;
}

#pragma mark -


#pragma mark - NDPhotoBrowseToolbarDelegate
#pragma mark 进到裁剪模式
- (void)gotoCropMode
{
    inCropMode = YES;
    
    NDPhotoData *photoData = previewSC.dataArray[previewSC.nowIndex];
    
    UIImageView *currentImageView = [previewSC currentImageView];
    CGRect viewFrame = [self.view convertRect:currentImageView.frame toView:self.view];
    
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:currentImageView.image];
    cropController.delegate = self;
    if ([NSString isEmptyString:photoData.localUrl] == NO) {
        [cropController setOrginalImage:[photoData imageWithEdit]];
    }
    
    [cropController presentAnimatedFromParentViewController:self fromFrame:CGRectMake(viewFrame.origin.x, viewFrame.origin.y + NDUI_TOP_BAR_HEIGHT, viewFrame.size.width, viewFrame.size.height) completion:^{
        
    }];
    
}


#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropImageToRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
    
    NDPhotoData *photoData = previewSC.dataArray[previewSC.nowIndex];
    
    
    if ([cropViewController hadCroped] == YES) {
        UIImage *image = [[photoData imageWithoutEdit] croppedImageWithFrame:cropViewController.cropFrame angle:cropViewController.angle];
        
        NSData * data = UIImagePNGRepresentation(image);
        
        NSString *path = [[NDTDFileUtility getDocumentPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[photoData.asset imageID]]];
        [data writeToFile:path atomically:true];
        
        photoData.localUrl = path;
        photoData.cropFrame = cropRect;
        photoData.angle = angle;
        
        [previewSC showPhotoAtIndex:previewSC.nowIndex - previewSC.indexOffset];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIImageView *currentImageView = [previewSC currentImageView];
        CGRect viewFrame = [self.view convertRect:currentImageView.frame toView:self.view];
        
        currentImageView.hidden = YES;
        [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:[photoData imageToShow] toFrame:CGRectMake(viewFrame.origin.x, viewFrame.origin.y + NDUI_TOP_BAR_HEIGHT, viewFrame.size.width, viewFrame.size.height) completion:^{
            currentImageView.hidden = NO;
            inCropMode = NO;
        }];
        
        
    });
    
    
    
    
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled
{
    UIImageView *currentImageView = [previewSC currentImageView];
    CGRect viewFrame = [self.view convertRect:currentImageView.frame toView:self.view];
    
    currentImageView.hidden = YES;
    [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:currentImageView.image toFrame:CGRectMake(viewFrame.origin.x, viewFrame.origin.y + NDUI_TOP_BAR_HEIGHT, viewFrame.size.width, viewFrame.size.height) completion:^{
        currentImageView.hidden = NO;
        inCropMode = NO;
    }];
}


- (void)didFinishCancelCrop
{
    NDPhotoData *photoData = previewSC.dataArray[previewSC.nowIndex];
    if ([NSString isEmptyString:photoData.localUrl] == NO) {
        [NDTDFileUtility deleteFile:photoData.localUrl];
    }
    photoData.localUrl = nil;
    [previewSC showPhotoAtIndex:previewSC.nowIndex - previewSC.indexOffset];
}


#pragma mark 对比度调节按钮选中状态
- (void)luxSelectedChanged : (BOOL) selected
{
//    if (selected) {
//        [previewSC changeLux:selected];
//    }else{
//        
//    }
    [previewSC changeLux:selected];
}

#pragma mark 滤镜条是否显示
- (void)filterScrollViewDisplayChange:(BOOL)isDisplay view:(NDPhotoFilterView *)view
{
    NDPhotoData *photoData = previewSC.dataArray[previewSC.nowIndex];
    [view showFilterImages:photoData];
}


#pragma mark 退出裁剪模式
- (void)outCropMode
{
    inCropMode = NO;
    [chooseBtn setTitle:@"选中" forState:UIControlStateNormal];
    backBtn.alpha = 1;
    cancelBtn.alpha = 0;
    navTitlePreview.text = @"预览";
}

#pragma mark 滤镜选择
-(void)didFilterSelected : (NDFilterData *)data
{
    [previewSC changeFilter:data];
}

#pragma mark -

#pragma mark - NDPhotoPreviewDelegate


- (void)scrollViewDidEndDecelerating
{
    NDPhotoData *photoData = previewSC.dataArray[previewSC.nowIndex];
    [toolBar changeLuxStatus:photoData];
    [toolBar changeFilterImages:photoData];
    
    
    //判断 展示的视图是否已经超出范围
    NSInteger row = previewSC.nowIndex;
    row = (NSInteger)(row / photoTable.colCnt);
    NSArray *visibleRows = [photoTable indexPathsForVisibleRows];
    BOOL flag = NO;
    for (NSIndexPath *path in visibleRows) {
        if (path.row == row) {
            flag = YES;
            break;
        }
    }
    
    if (flag == NO) {  //当前不在所在行内
        [photoTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
}

#pragma mark -

/**
 *  转到大图模式
 */
- (void)gotoBigPhotoMode
{
    [UIView animateWithDuration:NDUI_ANIMATE_TIME animations:^{
        sendBtn.alpha = 0, chooseBtn.alpha = 1, cancelBtn.alpha = 0, backBtn.alpha = 1;
        navTitle.alpha = 0, arrowView.alpha = 0, navTitlePreview.alpha = 1;
        
        photoTable.transform = CGAffineTransformMakeScale(0.3, 0.3);
        photoTable.alpha = 0;
        
        toolBar.frame = CGRectMake(0, self.view.height - toolBar.height, toolBar.width, toolBar.height);
    }];
}

/**
 *  转到小图模式
 */
- (void)gotoListPhotoMode
{
    NSInteger row = previewSC.nowIndex / photoTable.colCnt;
    NDPhotoBrowseTableCell *cell = (NDPhotoBrowseTableCell *)[photoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    photoTable.transform = CGAffineTransformMakeScale(1, 1);
    [previewSC turnToList:self.view originalView:cell.imageArray[previewSC.nowIndex % photoTable.colCnt]];
    [photoTable reloadData];
    photoTable.transform = CGAffineTransformMakeScale(0.3, 0.3);
    [UIView animateWithDuration:NDUI_ANIMATE_TIME animations:^{
        sendBtn.alpha = 1, chooseBtn.alpha = 0, cancelBtn.alpha = 1, backBtn.alpha = 0;
        navTitle.alpha = 1, arrowView.alpha = 1, navTitlePreview.alpha = 0;
        
        photoTable.transform = CGAffineTransformMakeScale(1, 1);
        photoTable.alpha = 1;
        
        previewSC.alpha = 0;
        
        toolBar.frame = CGRectMake(0, self.view.height , toolBar.width, toolBar.height);
        [toolBar closeFilterView];
    }];
}


-(void)dealloc
{
    for (NSObject *obj in photoTable.dataArray) {
        if( [obj isKindOfClass:[NDPhotoData class]]){
            NDPhotoData *photoData = (NDPhotoData *)obj;
            if ([NSString isEmptyString:photoData.localUrl] == NO) {
                [NDTDFileUtility deleteFile:photoData.localUrl];
            }
        
        }
    }
}


@end
