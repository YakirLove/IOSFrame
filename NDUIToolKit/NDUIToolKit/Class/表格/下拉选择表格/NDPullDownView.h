//
//  PullDownView.h
//  SelectServer
//
//  Created by 网龙技术部 on 15/8/6.
//  Copyright (c) 2015年 吴焰基. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NDPullDownTableView.h"

@class NDPullDownView;

@protocol NDPullDownViewDelegate <NSObject>
/**
 *  选择内容回调
 *
 *  @param dic          选中的内容字典
 *  @param string       在dataArray中的字典需要显示的字段
 *  @param pullDownView 点击的视图
 */
-(void)selectDic:(NSDictionary *)dic dickey:(NSString *)string pullDownView:(NDPullDownView *)pullDownView;

@optional
-(void)noticeNoData:(NDPullDownView *)pullDownView;

@end

@interface NDPullDownView : UIView<NDPullDownTableViewDelegate>
{
    UITextField *pullDownTextField;
    
    UIView *tapView;              ///<点击的view，点击后收起tableview
    NDPullDownTableView *tableView; ///<列表
    NSString *key;                ///<在dataArray中的字典需要显示的字段
    BOOL defaultValue;            ///<是否要默认值
    UIColor *lineColor;           ///<边框的颜色
    UIImageView *arrowImgView;    ///<下拉三角图标
    UIButton *bgButton;           ///< 下拉按钮
    UIColor *_tableColor;         ///< cell颜色
    UIColor *_tableSelectedColor; ///< cell选中颜色
    NSTextAlignment _textAlignment; ///< 文字布局
    UIColor *_selectedColor;       ///< 选中的字体颜色
    CGFloat _textMargin;
}

@property (nonatomic ,assign) id <NDPullDownViewDelegate> delegateForSup;
@property (nonatomic ,strong) UIImageView *arrowImgView;
@property (nonatomic ,strong) NSMutableArray *dataArray;    ///<数据
/**
 *  创建方法
 *
 *  @param frame     视图frame
 *  @param string    在dataArray中的字典需要显示的字段
 *  @param ifDefault 是否要默认显示第一个,如果为yes不会显示取消选择的选项
 *
 *  @return PullDownView
 */
- (instancetype)initWithFrame:(CGRect)frame dicKey:(NSString *)string showDefault:(BOOL)ifDefault color:(UIColor *)color;

/**
 *  设置数据
 *
 *  @param array 下来列表要现实的数据
 */

-(void)setArray:(NSMutableArray *)array;
/**
 *  设置Placeholder
 *
 *  @param string 如果defaultValue是yes的话不会显示取消选择的选项
 */
-(void)setPlaceholder:(NSString *)string;

/**
 *  是否有选中值
 *
 *  @return 是否有选择值
 */
-(BOOL)hadChoosedValue;

/**
 *  选择某一项
 *
 *  @param dic 选中项内容
 */
-(void)selectDic:(NSDictionary *)dic;

-(void)clearText;


-(void)setSelectedColor:(UIColor *)color;
-(void)setArrowImage:(UIImage *)image size:(CGSize)size;
-(void)setArrowButtonBGColor:(UIColor *)color;
-(void)setTableViewColor:(UIColor *)color;
-(void)setTableViewSelectedColor:(UIColor *)color;
-(void)setTableViewTextAlignment:(NSTextAlignment)textAlignment;
-(void)setTextMargin:(CGFloat)margin;

@end
