//
//  UILabel+Category.m
//  NDUIToolKit
//
//  Created by 林 on 9/10/15.
//  Copyright © 2015 nd. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)

+ (void)load
{
    Class c = [UILabel class];
    AutoCloseSwizzle(c, @selector(init), @selector(override_init));
    AutoCloseSwizzle(c, @selector(initWithFrame:), @selector(override_initWithFrame:));
}

-(id)override_init
{
    id idValue = [self override_init];
    if (idValue) {
        [idValue defaultSet];
    }
    return idValue;
}

-(id)override_initWithFrame:(CGRect)frame
{
    id idValue = [self override_initWithFrame:frame];
    if (idValue) {
        [idValue defaultSet];
    }
    return idValue;
}

/**
 *  默认设置
 */
-(void)defaultSet
{
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor blackColor];
    self.font = [UIFont systemFontOfSize:NDUI_LABEL_DEFUALT_FONT_SIZE];
}


@end
