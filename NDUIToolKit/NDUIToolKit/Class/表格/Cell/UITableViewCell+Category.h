//
//  UITableViewCell+Category.h
//  NDUIToolKit
//
//  Created by 林 on 9/29/15.
//  Copyright © 2015 nd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Category)

/**
 *  查找cell对应的tableView
 *
 *  @return 返回对应的tableView
 */
- (UITableView *)findContainingTableView;

@end
