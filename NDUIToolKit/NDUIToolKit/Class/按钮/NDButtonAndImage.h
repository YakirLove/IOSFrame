//
//  NDButtonAndImage.h
//  NDUIToolKit
//
//  Created by 林 on 9/24/15.
//  Copyright © 2015 nd. All rights reserved.
//

/**
 *  按钮里面带图标的按钮
 */

#import <UIKit/UIKit.h>

@interface NDButtonAndImage : UIButton

@property(nonatomic,strong)UIImageView *iconImageView;

-(instancetype)initWithFrame:(CGRect)frame iconImage:(UIImage *)iconImage;

-(instancetype)init:(UIImage *)iconImage;
@end
