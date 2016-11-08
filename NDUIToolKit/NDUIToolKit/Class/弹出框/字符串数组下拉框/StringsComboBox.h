//
//  StringsComboBox.h
//  ZorkBox(FifthPhase)
//
//  Created by zhangx on 15/10/22.
//  Copyright © 2015年 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StringsComboBoxDelegate;

/**
 *  通用下拉视图
 */
@interface StringsComboBox : NSObject

@property(nonatomic,copy)NSString *selectedString; ///< 选中的字符串
@property(nonatomic,assign)id<StringsComboBoxDelegate>delegate; ///< 事件委托

/**
 *  初始化
 *
 *  @param datas        数据
 *  @param selectString 选中项
 *
 *  @return 实例对象
 */
- (instancetype)initWithDatas:(NSArray *)datas selectString:(NSString *)selectString;

/**
 *  显示下拉框
 *
 *  @param startPoint 起始位置
 *  @param parentView 父视图
 */
- (void)showAtPoint:(CGPoint)startPoint parentView:(UIView *)parentView;

@end


@protocol StringsComboBoxDelegate <NSObject>

/**
 *  选中状态改变
 *
 *  @param comboBox 下拉框
 */
- (void)didSelectChanged:(StringsComboBox *)comboBox;

@end