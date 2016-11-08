//
//  StringsComboBox.m
//  ZorkBox(FifthPhase)
//
//  Created by zhangx on 15/10/22.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "StringsComboBox.h"
#import "DXPopover.h"

@interface StringsComboBox()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;  ///< 表格
    NSArray *_datas;  ///< 数据
    NSInteger _selectedIndex; ///< 选中的位置
    DXPopover *popView; ///< 弹出框
}

@end

@implementation StringsComboBox

/**
 *  初始化
 *
 *  @param datas        数据
 *  @param selectString 选中项
 *
 *  @return 实例对象
 */
- (instancetype)initWithDatas:(NSArray *)datas selectString:(NSString *)selectString
{
    self = [super init];
    if (self) {
        _datas = datas;
        for (NSInteger i = 0; i < datas.count ; i++) {
            if ([selectString isEqualToString:datas[i]]) {
                _selectedIndex = i;
                break;
            }
        }
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 5.0f;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas == nil ? 0 : _datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"StringsComboBoxCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIImageView *checkMark = [[UIImageView alloc] initWithImage:[UIImage imageInUIToolKitProject:@"check-mark-icon"]];
        checkMark.tag = 250;
        [cell.contentView addSubview:checkMark];
    }
    
    cell.textLabel.text = [_datas[indexPath.row] description];
    cell.textLabel.font = [UIFont systemFontOfSize:NDUI_LABEL_DEFUALT_FONT_SIZE];
    
    UIImageView *checkMark = (UIImageView *)[cell.contentView viewWithTag:250];
    if (indexPath.row == _selectedIndex) {
        checkMark.hidden = NO;
        checkMark.frame = CGRectMake(tableView.width - 40, (self.rowHeight - 32.0)/2.0, 32, 32);
    }else{
        checkMark.hidden = YES;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self rowHeight];
}

- (CGFloat)rowHeight
{
    return 76.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedString = _datas[indexPath.row];
    _selectedIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if ([self.delegate respondsToSelector:@selector(didSelectChanged:)]) {
        [self.delegate didSelectChanged:self];
    }
    [popView dismiss];
}


- (void)showAtPoint:(CGPoint)startPoint parentView:(UIView *)parentView
{
    if (popView == nil) {
        popView = [[DXPopover alloc] init];
    }
    //加载弹出框内容
    CGFloat tableHeight = _datas.count * self.rowHeight;
    tableHeight = tableHeight > parentView.height - 200 ? parentView.height - 200 : tableHeight; //最大高度只能是self.view.height - 200
    _tableView.frame = CGRectMake(2, 70, parentView.width - 4, tableHeight);
    
    [_tableView reloadData];
    
    CGFloat marginLeft = (parentView.width - _tableView.width)/2.0;
    popView.contentInset = UIEdgeInsetsMake(0, marginLeft, 0, marginLeft);
    popView.backgroundColor = [UIColor whiteColor];
    [popView showAtPoint:startPoint
                popoverPostion:DXPopoverPositionDown
               withContentView:_tableView
                        inView:parentView];
}

@end
