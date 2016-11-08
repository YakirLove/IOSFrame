//
//  TableFooterView.m
//  Test
//
//  Created by wyj on 16/7/25.
//  Copyright © 2016年 wyj. All rights reserved.
//

#import "TableFooterView.h"
#import "POP.h"

#define BEGIN_COLOR [UIColor grayColor]

#define BEGIN_WIDTH 6
#define END_WIDTH 10

@interface TableFooterView()
{
    CGPoint firstPoint;
    CGPoint secondPoint;
    CGPoint thirdPoint;
    double animationTime;
}

@property (weak, nonatomic) UIView *firstView;
@property (weak, nonatomic) UIView *secondView;
@property (weak, nonatomic) UIView *thirdView;

@end

@implementation TableFooterView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        animationTime = 0.3;
        [self initView];
    }
    return self;
}

-(void)initView
{
    CGFloat width = BEGIN_WIDTH;
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-width)/2.0-20, (self.frame.size.height-width)/2.0, width, width)];
    firstView.tag = 1;
    firstView.backgroundColor = BEGIN_COLOR;
    [self addSubview:firstView];
    self.firstView = firstView;
    self.firstView.layer.cornerRadius = self.firstView.frame.size.width/2.0;
    self.firstView.layer.masksToBounds = YES;
    self.firstView.alpha = 0.5;
    
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-width)/2.0, (self.frame.size.height-width)/2.0, width, width)];
    secondView.tag = 2;
    secondView.backgroundColor = BEGIN_COLOR;
    [self addSubview:secondView];
    self.secondView = secondView;
    self.secondView.layer.cornerRadius = self.secondView.frame.size.width/2.0;
    self.secondView.layer.masksToBounds = YES;
    self.secondView.alpha = 0.5;
    
    UIView *thirdView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-width)/2.0+20, (self.frame.size.height-width)/2.0, width, width)];
    thirdView.tag = 3;
    thirdView.backgroundColor = BEGIN_COLOR;
    [self addSubview:thirdView];
    self.thirdView = thirdView;
    self.thirdView.layer.cornerRadius = self.thirdView.frame.size.width/2.0;
    self.thirdView.layer.masksToBounds = YES;
    self.thirdView.alpha = 0.5;
    
    firstPoint = self.firstView.center;
    secondPoint = self.secondView.center;
    thirdPoint = self.thirdView.center;
    
    [self animationStar:self.firstView];
    
    double delayInSeconds = animationTime*2/3.0;
    __block TableFooterView* bself = self;
    dispatch_time_t secondTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(secondTime, dispatch_get_main_queue(), ^(void){
        [bself animationStar:self.secondView];
    });
    
    dispatch_time_t thirdTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds*2 * NSEC_PER_SEC));
    dispatch_after(thirdTime, dispatch_get_main_queue(), ^(void){
        [bself animationStar:self.thirdView];
    });
}

-(void)animationStar:(UIView *)view
{
    [self frameAnimation:view];
    [self alphaAnimation:view];
}

-(void)frameAnimation:(UIView *)view
{
    if(view == nil)
    {
        return;
    }
    
    POPBasicAnimation *anim = [POPBasicAnimation animation];
    anim.duration = animationTime;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop)
                                    {
                                        prop.readBlock = ^(id obj, CGFloat values[])
                                        {
                                            values[0] = [[obj description] floatValue];
                                        };
                                        prop.writeBlock = ^(id obj, const CGFloat values[])
                                        {
                                            
                                            UIView *objView = (UIView *)obj;
                                            
                                            objView.frame = CGRectMake(0, 0, values[0], values[0]);
                                            if(objView.tag == 1)
                                            {
                                                objView.center = firstPoint;
                                            }
                                            else if(objView.tag == 2)
                                            {
                                                objView.center = secondPoint;
                                            }
                                            else if(objView.tag == 3)
                                            {
                                                objView.center = thirdPoint;
                                            }
                                            objView.layer.cornerRadius = objView.frame.size.width/2.0;
                                        };
                                        prop.threshold = 0.01;
                                    }];
    anim.property = prop;
    anim.fromValue = @(BEGIN_WIDTH);
    anim.toValue = @(END_WIDTH);
    anim.delegate = self;
    [view pop_addAnimation:anim forKey:[NSString stringWithFormat:@"width%ld",(long)view.tag]];\
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
            POPBasicAnimation *anim = [POPBasicAnimation animation];
            anim.duration = animationTime;
            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop)
                                            {
                                                prop.readBlock = ^(id obj, CGFloat values[])
                                                {
                                                    values[0] = [[obj description] floatValue];
                                                };
                                                prop.writeBlock = ^(id obj, const CGFloat values[])
                                                {
                                                    
                                                    UIView *objView = (UIView *)obj;
                                                    
                                                    objView.frame = CGRectMake(0, 0, values[0], values[0]);
                                                    if(objView.tag == 1)
                                                    {
                                                        objView.center = firstPoint;
                                                    }
                                                    else if(objView.tag == 2)
                                                    {
                                                        objView.center = secondPoint;
                                                    }
                                                    else if(objView.tag == 3)
                                                    {
                                                        objView.center = thirdPoint;
                                                    }
                                                    objView.layer.cornerRadius = objView.frame.size.width/2.0;
                                                };
                                                prop.threshold = 0.01;
                                            }];
            anim.property = prop;
            anim.fromValue = @(END_WIDTH);
            anim.toValue = @(BEGIN_WIDTH);
            anim.delegate = self;
            [view pop_addAnimation:anim forKey:[NSString stringWithFormat:@"width%ld",(long)view.tag]];\
            anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                if (finished) {
                    [self frameAnimation:view];
                }
            };
            
            
        }
    };
    
}

-(void)alphaAnimation:(UIView *)view
{
    POPBasicAnimation *alphaAnim = [POPBasicAnimation animation];
    alphaAnim.duration = animationTime;
    alphaAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    alphaAnim.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    alphaAnim.fromValue = @(0.5);
    alphaAnim.toValue = @(1);
    [view pop_addAnimation:alphaAnim forKey:[NSString stringWithFormat:@"alpha%ld",(long)view.tag]];
    alphaAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished)
        {
            POPBasicAnimation *alphaAnim = [POPBasicAnimation animation];
            alphaAnim.duration = animationTime;
            alphaAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            alphaAnim.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
            alphaAnim.fromValue = @(1);
            alphaAnim.toValue = @(0.5);
            [view pop_addAnimation:alphaAnim forKey:[NSString stringWithFormat:@"alpha%ld",(long)view.tag]];
            alphaAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                if (finished)
                {
                    [self alphaAnimation:view];
                }
            };
        }
    };
}


@end
