//
//  UIImage+Filter.m
//  NDUIToolKit
//
//  Created by zhangx on 15/8/5.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "UIImage+Filter.h"
#import "GPUImagePicture.h"

@implementation UIImage (Filter)

#pragma mark 黑白滤镜图
+ (UIImage *)heibaiImage : (UIImage *)oriImage
{
    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
    
    NDHeibaiFilter *filter = [[NDHeibaiFilter alloc] init];
    
    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"heibai.png"]];
    
    [sourceImage addTarget:filter];
    [sourceImage processImage];
    
    [internalSourcePicture addTarget:filter];
    [filter useNextFrameForImageCapture];
    [internalSourcePicture processImage];
    
    return [filter imageFromCurrentFramebuffer];
}


#pragma mark 对比滤镜图
+ (UIImage *)duibiImage : (UIImage *)oriImage
{
    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
    
    NDDuibiFilter *filter = [[NDDuibiFilter alloc] init];
    
    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"duibi.png"]];
    GPUImagePicture *internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"c3.png"]];
    
    [sourceImage addTarget:filter];
    [sourceImage processImage];
    
    [internalSourcePicture addTarget:filter];
    [internalSourcePicture processImage];
    
    [internalSourcePicture1 addTarget:filter];
    [filter useNextFrameForImageCapture];
    [internalSourcePicture1 processImage];
    
    return [filter imageFromCurrentFramebuffer];
}

#pragma mark 翡翠绿滤镜图
+ (UIImage *)feicuilvImage : (UIImage *)oriImage
{
    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
    
    NDFeicuilvFilter *filter = [[NDFeicuilvFilter alloc] init];
    
    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"c1.png"]];
    GPUImagePicture *internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"c2.png"]];
    GPUImagePicture *internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"feicuilv.png"]];
    
    [sourceImage addTarget:filter];
    [sourceImage processImage];
    
    [internalSourcePicture addTarget:filter];
    [internalSourcePicture processImage];
    
    [internalSourcePicture1 addTarget:filter];
    [internalSourcePicture1 processImage];
    
    [internalSourcePicture2 addTarget:filter];
    [filter useNextFrameForImageCapture];
    [internalSourcePicture2 processImage];
    
    return [filter imageFromCurrentFramebuffer];
}

//#pragma mark 冷色滤镜图
//+ (UIImage *)lengseImage : (UIImage *)oriImage
//{
//    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
//    
//    NDLengSeFilter *filter = [[NDLengSeFilter alloc] init];
//    
//    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"c3.png"]];
//    GPUImagePicture *internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"lengse1.png"]];
//    GPUImagePicture *internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"c4.png"]];
//    GPUImagePicture *internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"lengse2.png"]];
//    GPUImagePicture *internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"lengse3.png"]];
//    
//    [sourceImage addTarget:filter];
//    [sourceImage processImage];
//    
//    [internalSourcePicture addTarget:filter];
//    [internalSourcePicture processImage];
//    
//    [internalSourcePicture1 addTarget:filter];
//    [internalSourcePicture1 processImage];
//    
//    [internalSourcePicture2 addTarget:filter];
//    [internalSourcePicture2 processImage];
//    
//    [internalSourcePicture3 addTarget:filter];
//    [internalSourcePicture3 processImage];
//    
//    [internalSourcePicture4 addTarget:filter];
//    [filter useNextFrameForImageCapture];
//    [internalSourcePicture4 processImage];
//    
//    return [filter imageFromCurrentFramebuffer];
//}

#pragma mark 米黄滤镜图
+ (UIImage *)mihuangImage : (UIImage *)oriImage
{
    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
    
    NDMihuangFilter *filter = [[NDMihuangFilter alloc] init];
    
    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"c1.png"]];
    GPUImagePicture *internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"c2.png"]];
    GPUImagePicture *internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"mihuang.png"]];
    
    [sourceImage addTarget:filter];
    [sourceImage processImage];
    
    [internalSourcePicture addTarget:filter];
    [internalSourcePicture processImage];
    
    [internalSourcePicture1 addTarget:filter];
    [internalSourcePicture1 processImage];
    
    [internalSourcePicture2 addTarget:filter];
    [filter useNextFrameForImageCapture];
    [internalSourcePicture2 processImage];
    
    return [filter imageFromCurrentFramebuffer];
}

#pragma mark 灯光滤镜图
+ (UIImage *)dengguangImage : (UIImage *)oriImage
{
    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
    
    NDDengguangFilter *filter = [[NDDengguangFilter alloc] init];
    
    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"dengguang.png"]];
    GPUImagePicture *internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"c3.png"]];
    
    [sourceImage addTarget:filter];
    [sourceImage processImage];
    
    [internalSourcePicture addTarget:filter];
    [internalSourcePicture processImage];
    
    [internalSourcePicture1 addTarget:filter];
    [filter useNextFrameForImageCapture];
    [internalSourcePicture1 processImage];
    
    return [filter imageFromCurrentFramebuffer];
}

#pragma mark 淡雅滤镜图
+ (UIImage *)danyaImage : (UIImage *)oriImage
{
    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
    
    NDDanyaFilter *filter = [[NDDanyaFilter alloc] init];
    
    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"danya1.png"]];
    GPUImagePicture *internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"danya2.png"]];
    
    [sourceImage addTarget:filter];
    [sourceImage processImage];
    
    [internalSourcePicture addTarget:filter];
    [internalSourcePicture processImage];
    
    [internalSourcePicture1 addTarget:filter];
    [filter useNextFrameForImageCapture];
    [internalSourcePicture1 processImage];
    
    return [filter imageFromCurrentFramebuffer];
}

#pragma mark 金色滤镜图
+ (UIImage *)jinseImage : (UIImage *)oriImage
{
    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
    
    NDJinseFilter *filter = [[NDJinseFilter alloc] init];
    
    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"jinse1.png"]];
    GPUImagePicture *internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"jinse2.png"]];
    GPUImagePicture *internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"jinse3.png"]];
    GPUImagePicture *internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"jinse4.png"]];
    GPUImagePicture *internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"jinse5.png"]];
    
    [sourceImage addTarget:filter];
    [sourceImage processImage];
    
    [internalSourcePicture addTarget:filter];
    [internalSourcePicture processImage];
    
    [internalSourcePicture1 addTarget:filter];
    [internalSourcePicture1 processImage];
    
    [internalSourcePicture2 addTarget:filter];
    [internalSourcePicture2 processImage];
    
    [internalSourcePicture3 addTarget:filter];
    [internalSourcePicture3 processImage];
    
    [internalSourcePicture4 addTarget:filter];
    [filter useNextFrameForImageCapture];
    [internalSourcePicture4 processImage];
    
    return [filter imageFromCurrentFramebuffer];
}

#pragma mark 增强滤镜图
+ (UIImage *)zengqiangImage : (UIImage *)oriImage
{
    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
    
    NDZengqiangFilter *filter = [[NDZengqiangFilter alloc] init];
    
    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"zengqiang.png"]];
    GPUImagePicture *internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"c3.png"]];
    
    [sourceImage addTarget:filter];
    [sourceImage processImage];
    
    [internalSourcePicture addTarget:filter];
    [internalSourcePicture processImage];
    
    [internalSourcePicture1 addTarget:filter];
    [filter useNextFrameForImageCapture];
    [internalSourcePicture1 processImage];
    
    return [filter imageFromCurrentFramebuffer];
}

//#pragma mark 炫丽滤镜图
//+ (UIImage *)xuanliImage : (UIImage *)oriImage
//{
//    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
//    
//    NDXuanliFilter *filter = [[NDXuanliFilter alloc] init];
//    
//    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"c5.png"]];
//    GPUImagePicture *internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"xuanli1.png"]];
//    GPUImagePicture *internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"xuanli2.png"]];
//    GPUImagePicture *internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"xuanli3.png"]];
//    GPUImagePicture *internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"xuanli4.png"]];
//    
//    [sourceImage addTarget:filter];
//    [sourceImage processImage];
//    
//    [internalSourcePicture addTarget:filter];
//    [internalSourcePicture processImage];
//    
//    [internalSourcePicture1 addTarget:filter];
//    [internalSourcePicture1 processImage];
//    
//    [internalSourcePicture2 addTarget:filter];
//    [internalSourcePicture2 processImage];
//    
//    [internalSourcePicture3 addTarget:filter];
//    [internalSourcePicture3 processImage];
//    
//    [internalSourcePicture4 addTarget:filter];
//    [filter useNextFrameForImageCapture];
//    [internalSourcePicture4 processImage];
//    
//    return [filter imageFromCurrentFramebuffer];
//}

#pragma mark 高亮滤镜图
+ (UIImage *)gaoliangImage : (UIImage *)oriImage
{
    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
    
    NDGaoliangFilter *filter = [[NDGaoliangFilter alloc] init];
    
    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"gaoliang.png"]];
    
    [sourceImage addTarget:filter];
    [sourceImage processImage];
    
    [internalSourcePicture addTarget:filter];
    [filter useNextFrameForImageCapture];
    [internalSourcePicture processImage];
    
    return [filter imageFromCurrentFramebuffer];
}

#pragma mark 铜色滤镜图
+ (UIImage *)tongseImage : (UIImage *)oriImage
{
    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
    
    NDTongseFilter *filter = [[NDTongseFilter alloc] init];
    
    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"tongse1.png"]];
    GPUImagePicture *internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"tongse2.png"]];
    GPUImagePicture *internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"c3.png"]];
    GPUImagePicture *internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"tongse3.png"]];
    GPUImagePicture *internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"tongse4.png"]];
    
    [sourceImage addTarget:filter];
    [sourceImage processImage];
    
    [internalSourcePicture addTarget:filter];
    [internalSourcePicture processImage];
    
    [internalSourcePicture1 addTarget:filter];
    [internalSourcePicture1 processImage];
    
    [internalSourcePicture2 addTarget:filter];
    [internalSourcePicture2 processImage];
    
    [internalSourcePicture3 addTarget:filter];
    [internalSourcePicture3 processImage];
    
    [internalSourcePicture4 addTarget:filter];
    [filter useNextFrameForImageCapture];
    [internalSourcePicture4 processImage];
    
    return [filter imageFromCurrentFramebuffer];
}

#pragma mark 艳阳滤镜图
+ (UIImage *)yanyangImage : (UIImage *)oriImage
{
    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
    
    NDYanyangFilter *filter = [[NDYanyangFilter alloc] init];
    
    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"yanyang1.png"]];
    GPUImagePicture *internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"yanyang2.png"]];
    GPUImagePicture *internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"yanyang3.png"]];
    GPUImagePicture *internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"yanyang4.png"]];
    GPUImagePicture *internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"yanyang5.png"]];
    
    [sourceImage addTarget:filter];
    [sourceImage processImage];
    
    [internalSourcePicture addTarget:filter];
    [internalSourcePicture processImage];
    
    [internalSourcePicture1 addTarget:filter];
    [internalSourcePicture1 processImage];
    
    [internalSourcePicture2 addTarget:filter];
    [internalSourcePicture2 processImage];
    
    [internalSourcePicture3 addTarget:filter];
    [internalSourcePicture3 processImage];
    
    [internalSourcePicture4 addTarget:filter];
    [filter useNextFrameForImageCapture];
    [internalSourcePicture4 processImage];
    
    return [filter imageFromCurrentFramebuffer];
}


#pragma mark 复古滤镜图
+ (UIImage *)fuguImage : (UIImage *)oriImage
{
    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
    
    NDFuguFilter *filter = [[NDFuguFilter alloc] init];
    
    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"fugu1.png"]];
    GPUImagePicture *internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"fugu2.png"]];
    
    [sourceImage addTarget:filter];
    [sourceImage processImage];
    
    [internalSourcePicture addTarget:filter];
    [internalSourcePicture processImage];
    
    [internalSourcePicture1 addTarget:filter];
    [filter useNextFrameForImageCapture];
    [internalSourcePicture1 processImage];
    
    return [filter imageFromCurrentFramebuffer];
}

#pragma mark 奶昔色滤镜图
+ (UIImage *)naixiseImage : (UIImage *)oriImage
{
    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
    
    NDNaixiseFilter *filter = [[NDNaixiseFilter alloc] init];
    
    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"naixise.png"]];
    
    [sourceImage addTarget:filter];
    [sourceImage processImage];
    
    [internalSourcePicture addTarget:filter];
    [filter useNextFrameForImageCapture];
    [internalSourcePicture processImage];
    
    return [filter imageFromCurrentFramebuffer];
}


//#pragma mark 柔和滤镜图
//+ (UIImage *)rouheImage : (UIImage *)oriImage
//{
//    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
//    
//    NDRouheFilter *filter = [[NDRouheFilter alloc] init];
//    
//    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"rouhe1.png"]];
//    GPUImagePicture *internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"c2.png"]];
//    GPUImagePicture *internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"rouhe2.png"]];
//    
//    [sourceImage addTarget:filter];
//    [sourceImage processImage];
//    
//    [internalSourcePicture addTarget:filter];
//    [internalSourcePicture processImage];
//    
//    [internalSourcePicture1 addTarget:filter];
//    [internalSourcePicture1 processImage];
//    
//    [internalSourcePicture2 addTarget:filter];
//    [filter useNextFrameForImageCapture];
//    [internalSourcePicture2 processImage];
//    
//    return [filter imageFromCurrentFramebuffer];
//}


//#pragma mark 现代滤镜图
//+ (UIImage *)xiandaiImage : (UIImage *)oriImage
//{
//    GPUImagePicture *sourceImage = [[GPUImagePicture alloc] initWithImage:oriImage];
//    
//    NDXiandaiFilter *filter = [[NDXiandaiFilter alloc] init];
//    
//    GPUImagePicture *internalSourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"xiandai1.png"]];
//    GPUImagePicture *internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"c2.png"]];
//    GPUImagePicture *internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageInUIToolKitProject:@"xiandai2.png"]];
//    
//    [sourceImage addTarget:filter];
//    [sourceImage processImage];
//    
//    [internalSourcePicture addTarget:filter];
//    [internalSourcePicture processImage];
//    
//    [internalSourcePicture1 addTarget:filter];
//    [internalSourcePicture1 processImage];
//    
//    [internalSourcePicture2 addTarget:filter];
//    [filter useNextFrameForImageCapture];
//    [internalSourcePicture2 processImage];
//    
//    return [filter imageFromCurrentFramebuffer];
//}


/**
 *  根据滤镜类型过滤图片
 *
 *  @param filterType 滤镜类型
 *
 *  @return 图片
 */
+ (UIImage *)imageWithFilterType:(NDUIFilterType)filterType oriImage:(UIImage *)oriImage
{
    if (oriImage == nil ) { ///< 原始图为nil的时候 直接返回nil
        return nil;
    }
    
    switch (filterType) {
        case NDUI_FILTER_TYPE_WU:
            return oriImage;
//        case NDUI_FILTER_TYPE_XIANDAI:
//            return [UIImage xiandaiImage:oriImage];
        case NDUI_FILTER_TYPE_NAIXISE:
            return [UIImage naixiseImage:oriImage];
//        case NDUI_FILTER_TYPE_ROUHE:
//            return [UIImage rouheImage:oriImage];
        case NDUI_FILTER_TYPE_FEICUILV:
            return [UIImage feicuilvImage:oriImage];
        case NDUI_FILTER_TYPE_FUGU:
            return [UIImage fuguImage:oriImage];
//        case NDUI_FILTER_TYPE_XUANLI:
//            return [UIImage xuanliImage:oriImage];
        case NDUI_FILTER_TYPE_ZENGQIANG:
            return [UIImage zengqiangImage:oriImage];
        case NDUI_FILTER_TYPE_JINSE:
            return [UIImage jinseImage:oriImage];
        case NDUI_FILTER_TYPE_YANYANG:
            return [UIImage yanyangImage:oriImage];
        case NDUI_FILTER_TYPE_MIHUANG:
            return [UIImage mihuangImage:oriImage];
        case NDUI_FILTER_TYPE_DENGGUANG:
            return [UIImage dengguangImage:oriImage];
        case NDUI_FILTER_TYPE_DUIBI:
            return [UIImage duibiImage:oriImage];
        case NDUI_FILTER_TYPE_TONGSE:
            return [UIImage tongseImage:oriImage];
        case NDUI_FILTER_TYPE_DANYA:
            return [UIImage danyaImage:oriImage];
        case NDUI_FILTER_TYPE_GAOLIANG:
            return [UIImage gaoliangImage:oriImage];
//        case NDUI_FILTER_TYPE_LENGSE:
//            return [UIImage lengseImage:oriImage];
        case NDUI_FILTER_TYPE_HEIBAI:
            return [UIImage heibaiImage:oriImage];
            
        default:
            break;
    }
    
    NSAssert(NO, @"filter not found!");
    
    return nil;
}


@end
