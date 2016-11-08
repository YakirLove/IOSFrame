//
//  PullDownTableView.h
//  ZorkBox(ThirdPhase)
//
//  Created by 网龙技术部 on 14-7-28.
//  Copyright (c) 2014年 福建网龙科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NDPullDownTableViewDelegate <NSObject>
/**
 *  返回选择内容
 *
 *  @param dic 选中的内容,取消选择时dic＝nil
 */
-(void)selectDic:(NSDictionary *)dic;

@optional

/**
 *  删除按钮点击
 *
 *  @param row 行
 */
-(void)deleteRowItem:(NSInteger)row;

@end

@interface NDPullDownTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataArray;
    NSString *key;
    UIColor *lineColor;
}
@property (nonatomic ,assign) id <NDPullDownTableViewDelegate> delegateForSup;
@property (nonatomic ,strong) NSString *defaultString;
@property (nonatomic ,assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign)BOOL enableDeleteItem;
@property (nonatomic ,strong)UIImage *deleteImage;
/**
 *  创建方法
 *
 *  @param array  数据
 *  @param string dic中的key
 *
 *  @return PullDownTableView
 */
-(id)initWithArray:(NSMutableArray *)array dicKey:(NSString *)string color:(CGColorRef)color;
/**
 *  取消选择选项
 *
 *  @param string 取消选择显示的字符
 */
-(void)setDefaultString:(NSString *)string;

@end
