//
//  UITableViewCell+Category.m
//  NDUIToolKit
//
//  Created by 林 on 9/29/15.
//  Copyright © 2015 nd. All rights reserved.
//

#import "UITableViewCell+Category.h"

@implementation UITableViewCell (Category)

- (UITableView *)findContainingTableView
{
    UIView *tableView = self.superview;
    
    while (tableView)
    {
        if ([tableView isKindOfClass:[UITableView class]])
        {
            return (UITableView *)tableView;
        }
        
        tableView = tableView.superview;
    }
    
    return nil;

}

@end
