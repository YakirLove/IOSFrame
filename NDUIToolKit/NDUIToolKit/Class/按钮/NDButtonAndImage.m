//
//  NDButtonAndImage.m
//  NDUIToolKit
//
//  Created by 林 on 9/24/15.
//  Copyright © 2015 nd. All rights reserved.
//

#import "NDButtonAndImage.h"

@interface NDButtonAndImage ()
{
    UIImage *_iconImage;
}

@end

@implementation NDButtonAndImage
@synthesize iconImageView;

-(instancetype)initWithFrame:(CGRect)frame iconImage:(UIImage *)iconImage
{
    self = [super initWithFrame:frame];
    if (self) {
        _iconImage = iconImage;
        [self  initSubView];
    }
    return self;
}


-(instancetype)init:(UIImage *)iconImage
{
    self = [super init];
    if (self) {
        _iconImage = iconImage;
        [self  initSubView];
    }
    return self;
}

-(void)initSubView
{
    iconImageView = [[UIImageView alloc]init];
    iconImageView.image = _iconImage;
    [self addSubview:iconImageView];
    CGSize imageSize = [_iconImage imageShowDesignSize];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imageSize);
        make.center.equalTo(self);
    }];
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self setLayoutSubviews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setLayoutSubviews];
}

-(void)setLayoutSubviews
{
    [self layoutIfNeeded];
    CGSize imageSize = [_iconImage imageShowDesignSize];
    CGFloat titleWidth = [self.titleLabel.text getStringWidth:self.titleLabel.font maxSize:CGSizeMake(self.width, self.height)];
    CGFloat offset = (self.width-titleWidth)/2-(self.width-(imageSize.width+8+titleWidth))/2;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -offset, 0, 0)];
    
    [iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([_iconImage imageShowDesignSize]);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset((self.width-titleWidth)/2-offset+titleWidth+8);
    }];

}





@end
