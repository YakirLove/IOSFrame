//
//  NDTDInPutMoreView.m
//  NDTDChat
//
//  Created by 林 on 7/27/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import "NDTDInPutMoreView.h"

@interface NDTDInputMoreView ()<NDKeyBoardPhotoPickerDelegate>
{
    
}

@end

@implementation NDTDInputMoreView
@synthesize delegate;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customView];
    }
    return self;
}

-(void)customView
{
    NDKeyBoardPhotoPicker *photoPickerView = [[NDKeyBoardPhotoPicker alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    photoPickerView.delegate = self;
    photoPickerView.maxImageCnt = 9;
    [self addSubview:photoPickerView];
}

#pragma mark -NDKeyBoardPhotoPickerDelegate
-(void)didPickedImages:(NSArray *)photoDatas pickerView:(NDKeyBoardPhotoPicker *)pickerView
{
    NSMutableArray *imagePathArray = [[NSMutableArray alloc]init];
    for (int i=0; i<photoDatas.count; i++) {
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
        NSString *filePath = [NDTDFileUtility createPath:[NSString stringWithFormat:@"appdata/chatbuffer/image/%@",fileName] isLibraryPath:YES];
        NDPhotoData *photoData = [photoDatas objectAtIndex:i];
        UIImage *image = [photoData imageToShow];
        [UIImageJPEGRepresentation(image, 0.5) writeToFile:filePath atomically:YES];
        [imagePathArray addObject:filePath];
    }
    if ([delegate respondsToSelector:@selector(didPickedImagePaths:imagePaths:)]) {
        [delegate didPickedImagePaths:self imagePaths:imagePathArray];
    }
}

@end
