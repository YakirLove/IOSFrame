//
//  ALAssetsLibraryRequest.m
//  NDSDK
//
//  Created by zhangx on 15/7/10.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDAssetsLibraryRequest.h"

@interface NDAssetsLibraryRequest(){
    NSMutableArray *photos;  ///< 取出的相片
    ALAssetsLibrary *assetsLibrary; ///< 相册库  如果被释放掉，将无法取photos、albums里面的数据
    NSMutableArray *albums;   ///< 取出的相册
}

@end

@implementation NDAssetsLibraryRequest

-(id)init
{
    self = [super init];
    if (self) {
        assetsLibrary = [[ALAssetsLibrary alloc]  init];
    }
    return self;
}

/**
 *  开始请求照片
 */
-(void)startRequestAllPhoto
{
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
                if (group!=nil) {
                    
                    if([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos){
                        
                        ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                            @autoreleasepool {
                                if (result) {
                                    [photos addObject:[[NDAsset alloc] initWithAsset:result]];
                                }else{
                                    if ([self.delegate respondsToSelector:@selector(allPhotoDidLoad:)]) {
                                        [self.delegate allPhotoDidLoad:photos];
                                    }
                                }
                            }
                        };
                        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
                        [group setAssetsFilter:onlyPhotosFilter];
                        [group  enumerateAssetsUsingBlock:assetsEnumerationBlock];
                        
                    }
                }
            };
            
            ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){
                NSString *errorMessage = nil;
                switch ([error code]) {
                    case ALAssetsLibraryAccessUserDeniedError:
                    case ALAssetsLibraryAccessGloballyDeniedError:
                        errorMessage = @"The user has declined access to it.";
                        break;
                    default:
                        errorMessage = @"Reason unknown.";
                        break;
                }
                
                if ([self.delegate respondsToSelector:@selector(loadPhotoFail:)]) {
                    [self.delegate loadPhotoFail:errorMessage];
                }
                
            };
            
            photos = [[NSMutableArray alloc] init];
            NSUInteger groupTypes = ALAssetsGroupAll;
            [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
        }
        
    });
}



/**
 *  请求所有相册
 */
-(void)startRequestAllAlbum
{
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
                if (group!=nil) {
                    [albums addObject:[[NDAssetsGroup alloc] initWithAssetsGroup:group]];
                }else{
                    
                    //排序规则 图片多的在前  如果图片量相同时 按相簿名称来
                    [albums sortUsingComparator:^NSComparisonResult(id  __nonnull obj1, id  __nonnull obj2) {
                        NDAssetsGroup *g1 = (NDAssetsGroup *)obj1;
                        NDAssetsGroup *g2 = (NDAssetsGroup *)obj2;
                        if (g1.numberOfAssets == g2.numberOfAssets) {
                            return [g1.groupName compare:g2.groupName];
                        }else{
                            if (g1.numberOfAssets > g2.numberOfAssets) {
                                return NSOrderedAscending;
                            }else{
                                return NSOrderedDescending;
                            }
                        }
                    }];
                    
                    if ([self.delegate respondsToSelector:@selector(allAlbumDidLoad:)]) {
                        [self.delegate allAlbumDidLoad:albums];
                    }
                }
            };
            
            ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){
                NSString *errorMessage = nil;
                switch ([error code]) {
                    case ALAssetsLibraryAccessUserDeniedError:
                    case ALAssetsLibraryAccessGloballyDeniedError:
                        errorMessage = @"The user has declined access to it.";
                        break;
                    default:
                        errorMessage = @"Reason unknown.";
                        break;
                }
                
                if ([self.delegate respondsToSelector:@selector(loadPhotoFail:)]) {
                    [self.delegate loadPhotoFail:errorMessage];
                }
                
            };
            
            albums = [[NSMutableArray alloc] init];
            NSUInteger groupTypes = ALAssetsGroupAll;
            [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
        }
        
    });


}

-(void)startRequestPhotoInGroup:(NDAssetsGroup *)ndGroup
{
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                @autoreleasepool {
                    if (result) {
                        [photos addObject:[[NDAsset alloc] initWithAsset:result]];
                    }else{
                        if ([self.delegate respondsToSelector:@selector(photoInGroupDidLoad:)]) {
                            [self.delegate photoInGroupDidLoad:photos];
                        }
                    }
                }
            };
            
            photos = [[NSMutableArray alloc] init];
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [ndGroup.group setAssetsFilter:onlyPhotosFilter];
            [ndGroup.group  enumerateAssetsUsingBlock:assetsEnumerationBlock];
        }
    });
}


@end
