//
//  NDPhotoPreview.m
//  NDUIToolKit
//
//  Created by zhangx on 15/7/30.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDPhotoPreview.h"
#import "NDPhotoFilterView.h"
#import "NDPhotoData.h"

@interface NDPhotoPreview()<UIScrollViewDelegate>{
    CGFloat imageScale;  ///< 图片缩放的尺寸
    UIPanGestureRecognizer *dragGesture; ///< 拖拽手势
}

@end

@implementation NDPhotoPreview

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self ) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        self.pagingEnabled = YES;
        
        self.preImage = [[UIImageView alloc] init];
        self.preImage.clipsToBounds = YES;
        self.preImage.contentMode = UIViewContentModeScaleAspectFill;
        self.indexOffset = 0;
        dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageDrag:)];
        imageScale = 1;
    }
    return self;
}

/**
 *  设置数据
 *
 *  @param dataArray 数据
 */
-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    self.contentSize = CGSizeMake((_dataArray.count - self.indexOffset) * self.width, self.height);
}

#pragma mark 显示在某个位置上的图片
- (void)showPhotoAtIndex:(NSInteger)index
{
    _nowIndex = index + self.indexOffset;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSInteger i = 0; i < 3; i++) {
        [self addImageAtIndex:index + i - 1];
    }
    
    self.contentOffset = CGPointMake(self.width * index, 0);
}

#pragma mark 显示某个位置上的图片
- (void)addImageAtIndex : (NSInteger)index
{
    if ([self viewWithTag:index + 100] != nil) {  //已存在就不增加
        return;
    }
    
    if (index >= 0 && index < _dataArray.count - self.indexOffset) {
        UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(index * self.width, 0, self.width, self.height)];
        NDPhotoData *photoData = _dataArray[index + self.indexOffset];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[photoData imageToShow]];
        imageView.userInteractionEnabled = YES;
        imageView.multipleTouchEnabled = YES;
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDoubleTap:)];  ///< 双击放大还原
        doubleTapGesture.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:doubleTapGesture];
        imageView.tag = 250;
        [imageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(imageZoom:)]];
        
        //计算宽高比
        if (panel.width / panel.height > imageView.image.size.width / imageView.image.size.height) {
            CGFloat newWidth = imageView.image.size.width * panel.height / imageView.image.size.height;
            imageView.frame = CGRectMake((panel.width - newWidth)/2.0, 0, newWidth, panel.height);
        }else{
            CGFloat newHeight = imageView.image.size.height * panel.width/ imageView.image.size.width ;
            imageView.frame = CGRectMake(0, (panel.height - newHeight)/2.0, panel.width, newHeight);
        }
        
        [panel addSubview:imageView];
        panel.tag = index + 100;
        [self addSubview:panel];
    }
}

#pragma mark 图片缩放
-(void)imageZoom:(UIPinchGestureRecognizer *)gesture
{
    CGFloat scale = gesture.scale;
    scale = scale * imageScale;
    // 如果捏合手势刚刚开始
    UIImageView * view = (UIImageView *)gesture.view;
    view.transform = CGAffineTransformMakeScale(scale,scale);
    
    if (gesture.state == UIGestureRecognizerStateBegan){
        
        
    }else if(gesture.state == UIGestureRecognizerStateEnded){
        imageScale = scale;
        if (imageScale <= 1) {
            imageScale = 1;
            
            [UIView animateWithDuration:NDUI_ANIMATE_TIME animations:^{
                 view.transform = CGAffineTransformMakeScale(imageScale,imageScale);
            }];
            
            [view removeGestureRecognizer:dragGesture];
            self.scrollEnabled = YES;
        }else {
            if (imageScale > 2) {
                imageScale = 2;
                [UIView animateWithDuration:NDUI_ANIMATE_TIME animations:^{
                    view.transform = CGAffineTransformMakeScale(imageScale,imageScale);
                }];
            }
            
            [view addGestureRecognizer:dragGesture];
            self.scrollEnabled = NO;
        }
        
        [self resetViewPosition:view frame:view.frame];
        
    }
}

#pragma mark 重新设置视图位置
-(void)resetViewPosition:(UIView *)view frame:(CGRect)newFrame
{
    if (newFrame.size.width < self.width) {  //宽度教小的时候
        newFrame = CGRectMake((self.width - newFrame.size.width)/2.0, newFrame.origin.y, newFrame.size.width, newFrame.size.height);
    }else{
        if(newFrame.origin.x > 0){  //超出左边界
            newFrame = CGRectMake(0, newFrame.origin.y, newFrame.size.width, newFrame.size.height);
        }else if(newFrame.origin.x < self.width - newFrame.size.width){  //超出右边界
            newFrame = CGRectMake(self.width - newFrame.size.width, newFrame.origin.y, newFrame.size.width, newFrame.size.height);
        }
    }
    
    if (newFrame.size.height < self.height) {  //高度教小的时候
        newFrame = CGRectMake(newFrame.origin.x, (self.height - newFrame.size.height)/2.0, newFrame.size.width, newFrame.size.height);
    }else{
        if(newFrame.origin.y > 0){  //超出左边界
            newFrame = CGRectMake(newFrame.origin.x, 0, newFrame.size.width, newFrame.size.height);
        }else if(newFrame.origin.y < self.height - newFrame.size.height){  //超出右边界
            newFrame = CGRectMake(newFrame.origin.x, self.height - newFrame.size.height, newFrame.size.width, newFrame.size.height);
        }
    }
    
    [UIView animateWithDuration:NDUI_ANIMATE_TIME animations:^{
        view.frame = newFrame;
    }];
    
}

#pragma mark 图片双击
-(void)imageDoubleTap:(UITapGestureRecognizer *)gesture
{
    if (imageScale == 1) {  //双击放大
        imageScale = 2;
        [UIView animateWithDuration:NDUI_ANIMATE_TIME animations:^{
            gesture.view.transform = CGAffineTransformMakeScale(imageScale, imageScale);
        }completion:^(BOOL finished) {
            self.scrollEnabled = NO;
            [gesture.view addGestureRecognizer:dragGesture];
        }];
    }else{  //双击还原
        imageScale = 1;
        [UIView animateWithDuration:NDUI_ANIMATE_TIME animations:^{
            gesture.view.transform = CGAffineTransformMakeScale(imageScale, imageScale);
            gesture.view.center = CGPointMake(self.width / 2.0, self.height / 2.0);
        }completion:^(BOOL finished) {
            self.scrollEnabled = YES;
            [gesture.view removeGestureRecognizer:dragGesture];
        }];
    }
}

#pragma mark 图片拖拽
-(void)imageDrag:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:self];
    
    CGRect newFrame = CGRectMake(gesture.view.left + translation.x, gesture.view.top + translation.y, gesture.view.width, gesture.view.height);
    
//    if (newFrame.size.width > self.width) {
//        if (newFrame.origin.x > 50) {
//            newFrame = CGRectMake(50, newFrame.origin.y, newFrame.size.width, newFrame.size.height);
//        }
//        
//        if (newFrame.origin.x < self.width - newFrame.size.width - 50) {
//            newFrame = CGRectMake(self.width - newFrame.size.width - 50, newFrame.origin.y, newFrame.size.width, newFrame.size
//                                  .height);
//        }
//    }
//    
//    if (newFrame.size.width > self.height) {
//        if (newFrame.origin.y > 50) {
//            newFrame = CGRectMake(newFrame.origin.x, 50, newFrame.size.width, newFrame.size.height);
//        }
//        
//        if (newFrame.origin.y < self.height - newFrame.size.height - 50) {
//            newFrame = CGRectMake(self.height - newFrame.size.height - 50, newFrame.origin.y, newFrame.size.width, newFrame.size.height);
//        }
//    }
    
    gesture.view.frame = newFrame;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
    }else if(gesture.state == UIGestureRecognizerStateEnded){
        [self resetViewPosition:gesture.view frame:newFrame];
    }
    
    
    [gesture setTranslation:CGPointZero inView:self];
}

#pragma mark scrollview delegate
- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;  //当前页号
    
    if (index + self.indexOffset != _nowIndex) {
        
        for (NSInteger i = 0; i < 3; i++) {
            [self addImageAtIndex:index + i - 1];
        }
        
        for (UIView *subview in self.subviews) {
            if (subview.tag - 100 < index - 1 || subview.tag - 100 > index + 1) {
                [subview removeFromSuperview];
            }
        }
        
        
        _nowIndex = index + self.indexOffset;
    }
}

#pragma mark
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.viewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating)]) {
        [self.viewDelegate scrollViewDidEndDecelerating];
    }
}

#pragma mark 小图转大图动画
- (void)turnToPreview : (UIView *)superview originalView : (UIView *)originalView
{
    NDPhotoData *photoData = _dataArray[originalView.tag];
    self.preImage.image =  [photoData imageToShow];
    
    //转换后的rect
    CGRect convertRect = [originalView.superview convertRect:originalView.frame toView:superview];
    self.preImage.frame = convertRect;
    [superview addSubview:self.preImage];
    
    //计算成功后的位置
    [self showPhotoAtIndex:originalView.tag - self.indexOffset];
    UIView *tempView = [self viewWithTag:100 + originalView.tag - self.indexOffset];
    UIView *subFirstView = tempView.subviews[0];
    CGRect newRect = [tempView convertRect:subFirstView.frame toView:superview];
    
    [UIView animateWithDuration:NDUI_ANIMATE_TIME animations:^{
        self.preImage.frame = newRect;
    } completion:^(BOOL finished) {
        self.alpha = 1;
        [self.preImage removeFromSuperview];
    }];
}

#pragma mark 大图转小图动画
- (void)turnToList:(UIView *)superview originalView:(UIView *)originalView
{
    
    NDPhotoData *photoData = _dataArray[originalView.tag];
    self.preImage.image = [photoData imageToShow];
    
    UIView *tempView = [self viewWithTag:100 + originalView.tag - self.indexOffset];
    UIView *subFirstView = tempView.subviews[0];
    CGRect oldRect = [tempView convertRect:subFirstView.frame toView:superview];
    self.preImage.frame = oldRect;
    [superview addSubview:self.preImage];
    
    self.alpha = 0;
    
    CGRect newRect = [originalView.superview convertRect:originalView.frame toView:superview];
    [UIView animateWithDuration:NDUI_ANIMATE_TIME animations:^{
        self.preImage.frame = newRect;
    } completion:^(BOOL finished) {
        [self.preImage removeFromSuperview];
    }];
}

#pragma mark 调整对比度
- (void)changeLux : (BOOL) enable
{
    NDPhotoData *photoData = _dataArray[_nowIndex];
    photoData.enableLux = enable;
    UIImageView *nowImage = (UIImageView *)([self viewWithTag:100 + _nowIndex - self.indexOffset].subviews[0]);
    nowImage.image = [photoData imageToShow];
}

#pragma mark 调整滤镜
- (void)changeFilter : (NDFilterData *)data
{
    NDPhotoData *photoData = _dataArray[_nowIndex];
    photoData.selecteFilter = data;
//    photoData.filteredImage = [UIImage imageWithFilterType:data.filterType oriImage:[photoData.asset thumbnailImage]];
    UIImageView *nowImage = (UIImageView *)([self viewWithTag:100 + _nowIndex - self.indexOffset].subviews[0]);
    //如果之前已经选中了lux 那么重新绘制lux
    if (photoData.enableLux) {
        photoData.enableLux = NO;
        photoData.enableLux = YES;
    }
    nowImage.image = [photoData imageToShow];
}


#pragma mark 返回当前视图
- (UIImageView *)currentImageView
{
    return (UIImageView *)[[self viewWithTag:_nowIndex - self.indexOffset + 100] viewWithTag:250];
}


@end
