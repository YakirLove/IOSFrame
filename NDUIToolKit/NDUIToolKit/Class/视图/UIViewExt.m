/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "UIViewExt.h"
#import "MBProgressHUD.h"

CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x-CGRectGetMidX(rect);
    newrect.origin.y = center.y-CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (ViewGeometry)

// Retrieve and set the origin
- (CGPoint) origin
{
	return self.frame.origin;
}

- (void) setOrigin: (CGPoint) aPoint
{
	CGRect newframe = self.frame;
	newframe.origin = aPoint;
	self.frame = newframe;
}


// Retrieve and set the size
- (CGSize) size
{
	return self.frame.size;
}

- (void) setSize: (CGSize) aSize
{
	CGRect newframe = self.frame;
	newframe.size = aSize;
	self.frame = newframe;
}

// Query other frame locations
- (CGPoint) bottomRight
{
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint) bottomLeft
{
	CGFloat x = self.frame.origin.x;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint) topRight
{
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y;
	return CGPointMake(x, y);
}



- (CGFloat) height
{
	return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
	CGRect newframe = self.frame;
	newframe.size.height = newheight;
	self.frame = newframe;
}

- (CGFloat) width
{
	return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
	CGRect newframe = self.frame;
	newframe.size.width = newwidth;
	self.frame = newframe;
}

- (CGFloat) top
{
	return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
	CGRect newframe = self.frame;
	newframe.origin.y = newtop;
	self.frame = newframe;
}

- (CGFloat) left
{
	return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
	CGRect newframe = self.frame;
	newframe.origin.x = newleft;
	self.frame = newframe;
}

- (CGFloat) bottom
{
	return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
	CGRect newframe = self.frame;
	newframe.origin.y = newbottom - self.frame.size.height;
	self.frame = newframe;
}

- (CGFloat) right
{
	return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
	CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
	CGRect newframe = self.frame;
	newframe.origin.x += delta ;
	self.frame = newframe;
}

// Move via offset
- (void) moveBy: (CGPoint) delta
{
	CGPoint newcenter = self.center;
	newcenter.x += delta.x;
	newcenter.y += delta.y;
	self.center = newcenter;
}

// Scaling
- (void) scaleBy: (CGFloat) scaleFactor
{
	CGRect newframe = self.frame;
	newframe.size.width *= scaleFactor;
	newframe.size.height *= scaleFactor;
	self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void) fitInSize: (CGSize) aSize
{
	CGFloat scale;
	CGRect newframe = self.frame;
	
	if (newframe.size.height && (newframe.size.height > aSize.height))
	{
		scale = aSize.height / newframe.size.height;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	if (newframe.size.width && (newframe.size.width >= aSize.width))
	{
		scale = aSize.width / newframe.size.width;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	self.frame = newframe;	
}

- (UIViewController*)viewController {
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


- (UINavigationController *)navigationController
{
    UINavigationController *nav = self.viewController.navigationController;
    UIView *view = self;
    while (nav == nil && view.superview != nil) {
        view = view.superview;
        nav = view.viewController.navigationController;
    }
    return nav;
}

-(void)removeAllSubview
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark 截屏
-(UIImage *)shot
{
    //支持retina高分的关键
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    //获取图像
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 创建圆型对象
- (void)circleFromView:(CGFloat)width borderColor:(UIColor *)color
{
    CALayer * layer = self.layer;
    [layer setMasksToBounds:YES];
    CGFloat radius = self.frame.size.width/2;
    [layer setCornerRadius:radius];
    [layer setBorderWidth:width];
    if (color) {
        [layer setBorderColor:color.CGColor];
    }
    
}

//当前视图转换成其他视图的坐标
-(CGRect)convertRect:(UIView *)toView
{
    CGRect rc = [self.superview convertRect:self.frame toView:toView];
    return rc;
}

// Start the tree recursion at level 0 with the root view
- (NSString *) displayViews
{
    NSMutableString *outstring = [[NSMutableString alloc] init];
    //AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self dumpView: self atIndent:0 into:outstring];
    NSLog(@"The view tree:\n%@",outstring);
    return outstring;
}

-(void)dumpView:(UIView *)aView atIndent:(int)indent into:(NSMutableString *)outstring
{
    for (int i = 0; i < indent; i++) [outstring appendString:@"--"];
    [outstring appendFormat:@"[%2d] %@\n", indent, [[aView class] description]];
    for (UIView *view in [aView subviews])
        [self dumpView:view atIndent:indent + 1 into:outstring];
}

-(ScreenSize)getScreenSize
{
    int width = (int)[UIScreen mainScreen].bounds.size.width;
    int height = (int)[UIScreen mainScreen].bounds.size.height;
    
    if(width == 320 && height == 568){
        return cun4;
    }
    else if (width == 375 && height == 667)
    {
        return cun4_7;
    }
    else if (width == 414 && height == 736)
    {
        return cun5_5;
    }
    return -1;

}

/**
 *  所有的子view 包括子view的子view
 *
 *  @return 子view数组
 */
-(NSArray *)allDeepSubview
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self ergodicView:self array:result];
    return result;
}

/**
 *  遍历视图
 *
 *  @param rootView 视图
 *  @param array    数组
 */
-(void)ergodicView:(UIView *)rootView array:(NSMutableArray *)array
{
    for (UIView *view in rootView.subviews ) {
        [array addObject:view];
        if (view.subviews != nil && view.subviews.count > 0) {
            [self ergodicView:view array:array];
        }
    }
}


/**
 *  网络加载
 *
 *  @param string 提示文字
 */
- (void)networkLoad:(NSString *)string
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = 	MBProgressHUDModeIndeterminate;  //网络加载设置类型
    hud.labelText = string;
    hud.detailsLabelText = @"";
}

/**
 *  隐藏对话框
 */
- (void)hiddenNetworkLoad
{
    [MBProgressHUD hideHUDForView:self animated:YES];  //隐藏
}


//横向等间隙的排列一组view，每个view的width不一样
- (void)distributeSpacingHorizontallyWith:(NSArray*)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    
    UIView *v0 = spaces[0];
    
    __weak __typeof(&*self)ws = self;
    
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left);
        make.centerY.equalTo(((UIView*)views[0]).mas_centerY);
    }];
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastSpace.mas_right);
            if (i==0) {
                make.centerY.equalTo(views);
            }
        }];
        
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj.mas_right);
            make.centerY.equalTo(obj.mas_centerY);
            make.width.equalTo(v0);
        }];
        
        lastSpace = space;
    }
    
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.mas_right);
    }];
}

//纵向等间隙的排列一组view，每个view的height不一样
- (void)distributeSpacingVerticallyWith:(NSArray*)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    
    
    UIView *v0 = spaces[0];
    
    __weak __typeof(&*self)ws = self;
    
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_top);
        make.centerX.equalTo(((UIView*)views[0]).mas_centerX);
    }];
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastSpace.mas_bottom);
            if (i==0) {
                make.centerX.equalTo(views);
            }
        }];
        
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(obj.mas_bottom);
            make.centerX.equalTo(obj.mas_centerX);
            make.height.equalTo(v0);
        }];
        
        lastSpace = space;
    }
    
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.mas_bottom);
    }];
}


@end