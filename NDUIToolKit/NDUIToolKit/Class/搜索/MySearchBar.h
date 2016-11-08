//
//  MySearchBar.h
//  SearchBarTest
//
//  Created by 林 on 4/29/14.
//  Copyright (c) 2014 福建网龙科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MySearchBar;
@protocol MySearchBarDelegate <NSObject>
//点击取消按钮回调
- (void)searchBarCancelButtonClicked:(MySearchBar *)searchBar;
@end

@interface MySearchBar : UISearchBar<UITextFieldDelegate>
{
    UIColor *textColor;
}
//背景图片
@property(nonatomic,strong)UIImageView *myBackgroundImage;
@property(nonatomic,assign)id<MySearchBarDelegate>myDelegate;

- (id)initWithFrame:(CGRect)frame textColor:(UIColor *)textColors;
@end
