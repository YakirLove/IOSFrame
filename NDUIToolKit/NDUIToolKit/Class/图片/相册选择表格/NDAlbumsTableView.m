//
//  NDAlbumsTableView.m
//  NDUIToolKit
//
//  Created by zhangx on 15/7/28.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDAlbumsTableView.h"
#import "NDAlbumsTableCell.h"

@interface NDAlbumsTableView()<UITableViewDataSource,UITableViewDelegate>
{
    
}

@end

@implementation NDAlbumsTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}


#pragma mark - table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray ? self.dataArray.count : 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NDAlbumsTableCell";
    NDAlbumsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[NDAlbumsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell drawView:self.dataArray[indexPath.row]];
    
    if (indexPath.row == self.selectedIndex) {
        cell.checkMark.hidden = NO;
        cell.checkMark.frame = CGRectMake(self.width - 40, (self.rowHeight - 32.0)/2.0, 32, 32);
    }else{
        cell.checkMark.hidden = YES;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    if ([self.albumsDelegate respondsToSelector:@selector(didSelectedAlbum:)]) {
        [self.albumsDelegate didSelectedAlbum:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self rowHeight];
}

- (CGFloat)rowHeight
{
    return 76.0f;
}

@end
