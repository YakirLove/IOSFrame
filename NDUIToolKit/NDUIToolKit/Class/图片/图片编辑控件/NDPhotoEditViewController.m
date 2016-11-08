//
//  NDPhotoEditViewController.m
//  NDUIToolKit
//
//  Created by zhangx on 15/8/7.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDPhotoEditViewController.h"
#import "NDPhotoEditToolbar.h"

/**
 *  线条数据
 */
@interface NDPhotoLinePathData : NSObject

@property(strong,nonatomic)NSArray *pointArray; ///< 点的数据
@property(assign,nonatomic)CGFloat lineWidth; ///< 线条粗细
@property(strong,nonatomic)UIColor *lineColor; ///< 线条颜色

@end

@implementation NDPhotoLinePathData


@end

@interface NDPhotoColorCircleView(){
    UIView *innerView; ///< 内部view
}

/**
 *  内圆颜色
 *
 *  @return 颜色
 */
-(UIColor *)innerColor;

/**
 *  内圆半径
 *
 *  @return 半径
 */
-(CGFloat)innerRadius;

@end

@implementation NDPhotoColorCircleView

#pragma mark 初始化
-(id)initWithFrame:(CGRect)frame circleSize:(CGFloat)circleSize color:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"EBEBEB"];
        self.layer.cornerRadius = self.width / 2.0;
        self.layer.borderWidth = 1.0f;
        
        innerView = [[UIView alloc] initWithFrame:CGRectZero];
        innerView.backgroundColor = color;
        [self addSubview:innerView];
        
        [self setInnerCircleSize:circleSize];
    }
    return self;
}

#pragma mark 设置内圆大小
-(void)setInnerCircleSize:(CGFloat)size
{
    innerView.layer.cornerRadius = size;
    size = size * 2 ;
    innerView.frame = CGRectMake((self.width - size)/2.0, (self.width - size)/2.0, size, size);
}

#pragma mark 设置颜色
-(void)setCircleColor:(UIColor *)color
{
    self.layer.borderColor = color.CGColor;
    innerView.backgroundColor = color;
}

#pragma mark 内圆颜色
-(UIColor *)innerColor
{
    return innerView.backgroundColor;
}



#pragma mark 内圆半径
-(CGFloat)innerRadius
{
    return innerView.width / 2.0;
}

@end

@implementation NDPhotoColorView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        _colorImage = [[UIImageView alloc] initWithImage:[UIImage imageInUIToolKitProject:@"color_bar"]];
        _colorImage.frame = CGRectMake(self.width - NDUI_COLOR_IMAGE_WIDTH, 0, NDUI_COLOR_IMAGE_WIDTH, self.height);
        [self addSubview:_colorImage];
    }
    return self;
}

@end

@interface NDPhotoEditViewController()<NDPhotoEditToolbarDelegate,UITextFieldDelegate>{
    UIImage *_oriImage; ///< 原始图
    NDPhotoEditToolbar *editToolbar; ///< 工具栏
    UIImageView *contentView;   ///< 内容view
    NDPhotoColorView *photoColor; ///< 颜色条
    BOOL isEditColor; ///< 编辑颜色
    NDPhotoColorCircleView *circleView; ///< 画笔颜色、粗细指示视图
    UIImageView *scrawlView; ///< 涂鸦视图
    NSMutableArray *pathArray; ///< 路径数组
    NSMutableArray *pointArray; ///< 点的数组
    UIButton *repealBtn; ///< 撤销按钮
    UILabel *infoLabel;  ///< 提示信息
    UITextField *textInput; ///< 输入
}

@end

@implementation NDPhotoEditViewController

#pragma mark 初始化
-(id)initWithOriImage:(UIImage *)oriImage
{
    self = [super init];
    if (self) {
        _oriImage = oriImage;
        self.view.backgroundColor = [UIColor whiteColor];
        pathArray = [[NSMutableArray alloc] init];
        [self createNavBar];
        [self createContentView];
        [self createToolBar];
        [self createColorView];
        [self createRepealBtn];
    }
    return self;
}

/**
 *  创建导航条
 */
-(void)createNavBar
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 49, NDUI_NAV_BAR_HEIGHT)];
    UIButton *cancelBtn = [self createNavBarBtn];
    cancelBtn.frame = leftView.bounds;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sendBtn = [self createNavBarBtn];
    sendBtn.frame = CGRectMake(0, 0, 49, NDUI_NAV_BAR_HEIGHT);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight ;
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    
    [self createNavBarTitle];
}

/**
 *  创建导航栏title
 */
-(void)createNavBarTitle
{
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, NDUI_SCREEN_WIDTH - 40, NDUI_NAV_BAR_HEIGHT)];
    navTitle.text = @"预览";
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.font = [UIFont boldSystemFontOfSize:NDUI_LABEL_DEFUALT_FONT_SIZE];
    navTitle.userInteractionEnabled = YES;
    self.navigationItem.titleView = navTitle;
}

/**
 *  导航栏上按钮
 *
 *  @return 按钮
 */
-(UIButton *)createNavBarBtn
{
    UIButton *barBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    barBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft ;
    barBtn.titleLabel.font = [UIFont systemFontOfSize:NDUI_LABEL_DEFUALT_FONT_SIZE];
    [barBtn setTitleColor:[UIColor colorWithHexString:NDUI_SYSTEM_DEFUALT_FONT_COLOR] forState:UIControlStateNormal];
    [barBtn setTitleColor:[UIColor colorWithHexString:NDUI_SYSTEM_DEFUALT_FONT_HIGHLIGHT_COLOR] forState:UIControlStateHighlighted];
    
    return barBtn;
}

#pragma mark 取消按钮点击
-(void)cancelBtnClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        if([self.delegate respondsToSelector:@selector(didCancelEdit)]){
            [self.delegate didCancelEdit];
        }
    }];
}

#pragma mark 发送按钮点击
-(void)sendBtnClick
{
    [infoLabel removeFromSuperview];
    
    UIGraphicsBeginImageContextWithOptions(contentView.bounds.size, YES, 0);
    [contentView drawViewHierarchyInRect:contentView.bounds afterScreenUpdates:YES];
    UIImage *viewShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(contentView.size);
    //Draw image2
    [viewShot drawInRect:CGRectMake(0, 0, contentView.width, contentView.height)];
    //Draw image1
    [scrawlView.image drawInRect:CGRectMake(0, 0, scrawlView.width, scrawlView.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([self.delegate respondsToSelector:@selector(didFinishedEdit:editViewController:)]) {
        [self.delegate didFinishedEdit:resultImage editViewController:self];
    }
}

#pragma mark 创建工具栏
-(void)createToolBar
{
    editToolbar = [[NDPhotoEditToolbar alloc] initWithFrame:CGRectMake(0, self.view.height - NDUI_TOOL_BAR_HEIGHT, self.view.width, NDUI_TOOL_BAR_HEIGHT)];
    editToolbar.delegate = self;
    [self.view addSubview:editToolbar];
}



#pragma mark - NDPhotoEditToolbarDelegate
#pragma mark 工具类按钮状态改变
-(void)didEditToolbarStatusChange:(NDUIEditToolbarStatus)newStatus
{
    [textInput resignFirstResponder];
    if (newStatus == NDUI_EDIT_TOOLBAR_STATUS_TEXT) {
        [UIView animateWithDuration:NDUI_ANIMATE_TIME animations:^{
            photoColor.frame = CGRectMake(self.view.width - NDUI_COLOR_PANEL_WIDTH + NDUI_COLOR_IMAGE_WIDTH, photoColor.top, photoColor.width, photoColor.height);
            infoLabel.hidden = NO;
        }];
    }else{
        [UIView animateWithDuration:NDUI_ANIMATE_TIME animations:^{
            photoColor.frame = CGRectMake(self.view.width - NDUI_COLOR_PANEL_WIDTH, photoColor.top, photoColor.width, photoColor.height);
            infoLabel.hidden = YES;
        }];
    }
}
#pragma mark

#pragma mark 创建内容视图
-(void)createContentView
{
    CGSize contentSize = CGSizeMake(self.view.width, self.view.height - NDUI_TOOL_BAR_HEIGHT - NDUI_TOP_BAR_HEIGHT);
    
    contentView = [[UIImageView alloc] initWithImage:_oriImage];
    
    //计算宽高比
    if (contentSize.width / contentSize.height > contentView.image.size.width / contentView.image.size.height) {
        CGFloat newWidth = contentView.image.size.width * contentSize.height / contentView.image.size.height;
        contentView.frame = CGRectMake((contentSize.width - newWidth)/2.0, NDUI_TOP_BAR_HEIGHT, (NSInteger)newWidth, (NSInteger)contentSize.height);
    }else{
        CGFloat newHeight = contentView.image.size.height * contentSize.width/ contentView.image.size.width ;
        contentView.frame = CGRectMake(0, (contentSize.height - newHeight)/2.0 + NDUI_TOP_BAR_HEIGHT, (NSInteger)contentSize.width, (NSInteger)newHeight);
    }
    
    infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, contentView.width, 12)];
    infoLabel.text = @"轻触照片，添加文本";
    infoLabel.font = [UIFont systemFontOfSize:11.0f];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.backgroundColor = [UIColor colorWithHexString:@"A0383838"];
    [contentView addSubview:infoLabel];
    
    textInput = [[UITextField alloc] initWithFrame:CGRectMake(0, (contentView.height - 50) /2.0, contentView.width, 55)];
    textInput.textAlignment = NSTextAlignmentCenter;
    textInput.font = [UIFont systemFontOfSize:50.0];
    textInput.textColor = [UIColor whiteColor];
    textInput.backgroundColor = [UIColor clearColor];
    textInput.delegate = self;
    textInput.returnKeyType = UIReturnKeyDone;
    [contentView addSubview:textInput];
    
    [self.view addSubview:contentView];
    
    scrawlView = [[UIImageView alloc] initWithFrame:contentView.frame];
    scrawlView.image = [[UIImage alloc] init];
    [self.view addSubview:scrawlView];
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)]];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)]];
}

#pragma mark 点击手势
-(void)tapHandle:(UITapGestureRecognizer *)pgr
{
    infoLabel.hidden = YES;
    if (editToolbar.toolbarStatus == NDUI_EDIT_TOOLBAR_STATUS_TEXT) {
        if ([textInput isFirstResponder]) {
            [textInput resignFirstResponder];
        }else{
            [textInput becomeFirstResponder];
        }
        
    }
}

#pragma mark 图片滑动手势
-(void)panHandle:(UIPanGestureRecognizer *)pgr
{
    if (editToolbar.toolbarStatus == NDUI_EDIT_TOOLBAR_STATUS_HANDWRITE) {
        CGPoint location = [pgr locationInView:self.view];
        
        if (pgr.state == UIGestureRecognizerStateBegan) {
            //计算一开始是不是在颜色区域
            if (location.x > photoColor.left ) { ///在颜色区
                isEditColor = YES;
                [self calculatePenColor:location];
                circleView.hidden = NO;
            }else{
                isEditColor = NO;
                pointArray = [[NSMutableArray alloc] init];
                [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(location.x - contentView.left, location.y - contentView.top)]];
            }
        }else if (pgr.state == UIGestureRecognizerStateChanged) {
            if(isEditColor){
                [self calculatePenColor:location];
            }else{ //不是编辑颜色跟粗细的时候  直接在图片上写字
                
                //先计算手的位置是否在图片内部,如果是的话 开始涂鸦
                if (location.x >= scrawlView.left && location.x <= scrawlView.right && location.y >= scrawlView.top && location.y <= scrawlView.bottom) {
                    [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(location.x - scrawlView.left, location.y - scrawlView.top)]];
                    CGPoint previousPoint = [pointArray[pointArray.count - 2] CGPointValue];
                    CGPoint currentPoint = [pointArray[pointArray.count - 1] CGPointValue];
                    [self drawNewLine:[circleView innerColor] lineSize:[circleView innerRadius] previousPoint:previousPoint currentPoint:currentPoint];
                }
                
            }
        }else if (pgr.state == UIGestureRecognizerStateEnded) {
            circleView.hidden = YES;
            if (isEditColor == NO) {
                NDPhotoLinePathData * pathData = [[NDPhotoLinePathData alloc] init];
                pathData.pointArray = pointArray,pathData.lineWidth = [circleView innerRadius],pathData.lineColor = [circleView innerColor];
                [pathArray addObject:pathData];
                [self judgeRepealBtnVisable];
            }
        }
    }
}

/**
 *  画线
 *
 *  @param color         颜色
 *  @param size          粗细
 *  @param previousPoint 前一个点
 *  @param currentPoint  后一个点
 */
- (void)drawNewLine:(UIColor *)color lineSize:(CGFloat)size previousPoint:(CGPoint)previousPoint currentPoint:(CGPoint)currentPoint
{
    UIGraphicsBeginImageContext(scrawlView.bounds.size);
    [scrawlView.image drawInRect:scrawlView.bounds];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), size);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    scrawlView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [scrawlView setNeedsDisplay];
}

#pragma mark 计算画笔颜色
/**
 *  计算画笔颜色 粗细
 *
 *  @param pointInView 位置
 *
 */
-(void) calculatePenColor:(CGPoint)pointInView
{
    CGFloat pointY = pointInView.y - NDUI_TOP_BAR_HEIGHT;
    UIColor *color = [photoColor.colorImage.image getPixelColorAtLocation:CGPointMake(1, pointY * photoColor.colorImage.image.size.height / (self.view.height - NDUI_TOOL_BAR_HEIGHT - NDUI_TOP_BAR_HEIGHT))];
    CGFloat marginLeft = pointInView.x - circleView.width * 1.5;
    circleView.frame = CGRectMake(marginLeft < 0 ? 0 : marginLeft , pointInView.y - circleView.height / 2.0, circleView.width, circleView.height);
    [circleView setCircleColor:color];
    
    CGFloat distance = self.view.width - pointInView.x;
    if (distance < NDUI_COLOR_PANEL_WIDTH) {
        [circleView setInnerCircleSize:2];
    }else if (distance > self.view.width - NDUI_MAX_PEN_SIZE){
        [circleView setInnerCircleSize:NDUI_MAX_PEN_SIZE/2.0 - 2];
    }else{
        [circleView setInnerCircleSize:2 + (distance - NDUI_COLOR_PANEL_WIDTH) * (NDUI_MAX_PEN_SIZE/2.0 - 4) / (self.view.width -  NDUI_MAX_PEN_SIZE - NDUI_COLOR_PANEL_WIDTH)];
    }
}

#pragma mark 撤销按钮
/**
 *  撤销按钮
 */
-(void)createRepealBtn
{
    repealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    repealBtn.frame = CGRectMake((self.view.width - 40)/2.0, editToolbar.top - 50, 40, 40);
    [repealBtn setImage:[UIImage imageInUIToolKitProject:@"inboxRepliedIcon"] forState:UIControlStateNormal];
    repealBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [repealBtn addTarget:self action:@selector(repealLastLine:) forControlEvents:UIControlEventTouchUpInside];
    repealBtn.hidden = YES;
    [self.view addSubview:repealBtn];
}

#pragma mark 撤销按钮显示或者隐藏
-(void)judgeRepealBtnVisable
{
    if (pathArray.count>0) {
        repealBtn.hidden = NO;
    }else{
        repealBtn.hidden = YES;
    }
}

#pragma mark 撤销最后一次划线
-(void)repealLastLine:(UIButton *)sender
{
    if (pathArray .count > 0 && sender.enabled) {
        repealBtn.enabled = NO;
        [pathArray removeLastObject];
        [self reDrawLine];
        [self judgeRepealBtnVisable];
        [self performSelector:@selector(enableRepealBtn:) withObject:nil afterDelay:0.1];
    }
}


-(void)enableRepealBtn:(id)sender
{
    repealBtn.enabled = YES;
}

#pragma mark 重新划线
-(void)reDrawLine
{
    scrawlView.image = [[UIImage alloc] init];
    for (NDPhotoLinePathData * pathData in pathArray) {
        if (pathData.pointArray.count >= 2) {
            for (NSInteger i = 1; i < pathData.pointArray.count ; i++) {
                [self drawNewLine:pathData.lineColor lineSize:pathData.lineWidth previousPoint:[pathData.pointArray[i - 1] CGPointValue] currentPoint:[pathData.pointArray[i] CGPointValue]];
            }
        }
    }
}


#pragma mark 创建颜色条
/**
 *  创建颜色条
 */
-(void)createColorView
{
    photoColor = [[NDPhotoColorView alloc] initWithFrame:CGRectMake(self.view.width - NDUI_COLOR_PANEL_WIDTH + NDUI_COLOR_IMAGE_WIDTH, NDUI_TOP_BAR_HEIGHT, NDUI_COLOR_PANEL_WIDTH, self.view.height - NDUI_TOOL_BAR_HEIGHT - NDUI_TOP_BAR_HEIGHT)];
    [self.view addSubview:photoColor];
    
    circleView = [[NDPhotoColorCircleView alloc] initWithFrame:CGRectMake(0, 0, NDUI_MAX_PEN_SIZE, NDUI_MAX_PEN_SIZE) circleSize:2 color:[UIColor blackColor]];
    [self.view addSubview:circleView];
    circleView.hidden = YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textInput resignFirstResponder];
    return YES;
}
#pragma mark -

@end
