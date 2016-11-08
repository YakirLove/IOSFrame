//
//  NDPhotoFilterCellView.m
//  NDUIToolKit
//
//  Created by zhangx on 15/8/6.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDPhotoFilterCellView.h"

@interface NDPhotoFilterCellView(){
    UILabel *nameLabel;  ///< 滤镜名称
    UIImageView *demoImageView; ///< 效果图
}

@end

@implementation NDPhotoFilterCellView

#pragma mark 初始化
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        demoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, self.width, self.height - 20)];
        demoImageView.contentMode = UIViewContentModeScaleAspectFill;
        demoImageView.clipsToBounds = YES;
        demoImageView.layer.borderColor = [UIColor colorWithHexString:NDUI_DEFAULT_BLUE_COLOR].CGColor;
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, demoImageView.bottom, self.width, 10)];
        nameLabel.font = [UIFont systemFontOfSize:8.0f];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:demoImageView];
        [self addSubview:nameLabel];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
        
    }
    return self;
}

#pragma mark 按钮点击
- (void)click:(UITapGestureRecognizer *)tapGR
{
    if ([self.delegate respondsToSelector:@selector(didClick:)]) {
        [self.delegate didClick:self];
    }
}

#pragma mark 填充数据
-(void)fillData:(UIImage *)image name:(NSString *)name
{
    demoImageView.image = image;
    nameLabel.text = name;
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        demoImageView.layer.borderWidth = 3.0f;
    }else{
        demoImageView.layer.borderWidth = 0.0f;
    }
}

@end
