 

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ScreenSize) {
    cun4 = 0,
    cun4_7 = 1,
    cun5_5 = 2
};

//获取视图中心点。
CGPoint CGRectGetCenter(CGRect rect);

//视图当前点，移动至中心点。返回cgrect
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)

@property CGPoint origin;

@property CGSize size;

@property (readonly) CGPoint bottomLeft; //最左下角的点

@property (readonly) CGPoint bottomRight; //最右下角的点

@property (readonly) CGPoint topRight;    //最右上角的点

@property CGFloat height; //高度     self.frame.size.height

@property CGFloat width;  //长度     self.frame.size.width

@property CGFloat top;    //Y做标    self.frame.origin.x

@property CGFloat left;   //X坐标     self.frame.origin.x

@property CGFloat bottom; //视图最底端 self.frame.origin.y + self.frame.size.height

@property CGFloat right;  //视图最右边 self.frame.origin.x + self.frame.size.width

- (void) moveBy: (CGPoint) delta;

- (void) scaleBy: (CGFloat) scaleFactor;

- (void) fitInSize: (CGSize) aSize;

/**
 *  //UIView对象获取该对象所属的UIViewController
 *
 *  @return 返回对应UIViewController
 */
- (UIViewController *)viewController;

/**
 *  //UIView对象获取该对象所属的UINavigationViewController
 *
 *  @return 返回对应的UINavigationViewController
 */
- (UINavigationController *)navigationController;

/**
 *  删除所有子视图
 */
-(void)removeAllSubview;

/**
 *  所有的子view 包括子view的子view
 *
 *  @return 子view数组
 */
-(NSArray *)allDeepSubview;


/**
 *  创建圆型对象
 *
 *  @param width 边框的长度
 *  @param color 边框的颜色
 */
- (void)circleFromView:(CGFloat)width borderColor:(UIColor *)color;

/**
 *  当前视图转换成其他视图的坐标
 *
 *  @param toView 转换到的视图
 *
 *  @return 返回转换的结果
 */
-(CGRect)convertRect:(UIView *)toView;

/**
 *  截取该视图为图片
 *
 *  @return 返回图片
 */
-(UIImage *)shot;

/**
 *  打印View的层次结构，以树的形式展示,用于调试比较方便
 *
 *  @return 打印结果
 */
-(NSString *)displayViews;

/**
 *  获取当前屏幕是4寸，4.7还是5.5寸
 *
 *  @return 返回结果如果为－1则是未知屏幕
 */
-(ScreenSize)getScreenSize;

/**
 *  网络加载
 *
 *  @param string 提示文字
 */
- (void)networkLoad:(NSString *)string;
/**
 *  隐藏对话框
 */
- (void)hiddenNetworkLoad;

//当每个view的width不一样，横向等间隙的排列一组view.每个view自己要设置top的位置和控件的size
- (void)distributeSpacingHorizontallyWith:(NSArray*)views;

//当每个view的height不一样，纵向等间隙的排列一组view.每个view自己要设置x的位置和控件的size
- (void)distributeSpacingVerticallyWith:(NSArray*)views;

@end