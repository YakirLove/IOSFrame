//
//  NDCycleScrollView.m
//  NDUIToolKit
//
//  Created by zhangx on 15/11/3.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDCycleScrollView.h"

@implementation NDCycleScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [super initWithFrame:frame animationDuration:animationDuration];
    if (self) {
        [self addObserver:self forKeyPath:@"currentPageIndex" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSInteger newPange = [[change objectForKey:@"new"] integerValue];
    if(self.PageChanged != nil){
        self.PageChanged(newPange);
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"currentPageIndex"];
}

@end

