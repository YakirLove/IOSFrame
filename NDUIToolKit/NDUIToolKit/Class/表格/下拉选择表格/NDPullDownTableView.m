//
//  PullDownTableView.m
//  ZorkBox(ThirdPhase)
//
//  Created by 网龙技术部 on 14-7-28.
//  Copyright (c) 2014年 福建网龙科技有限公司. All rights reserved.
//

#import "NDPullDownTableView.h"

@implementation NDPullDownTableView

@synthesize delegateForSup;
@synthesize defaultString;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithArray:(NSMutableArray *)array dicKey:(NSString *)string color:(CGColorRef)color
{
    self = [super init];
    if (self) {
        // Initialization code
        key = [NSString stringWithFormat:@"%@",string];
        dataArray = [[NSMutableArray alloc] initWithArray:array copyItems:YES];
        self.delegate = self;
        self.dataSource = self;
        self.layer.borderColor = color;
        self.layer.borderWidth = 1;
        self.textAlignment = NSTextAlignmentLeft;
        self.enableDeleteItem = NO;
        self.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
//        self.separatorColor = [UIColor clearColor];
    }
    return self;
}

-(void)setDefaultString:(NSString *)string
{
    defaultString = string;
    [self reloadData];
}

#pragma mark - table delegate datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(defaultString == nil)
        return dataArray.count;
    else
        return dataArray.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell1 = @"cell1";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell1];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1];
        cell.backgroundColor = self.backgroundColor;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = self.selectedColor;
        cell.selectedBackgroundView = view;
        
        if (self.enableDeleteItem) {
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame = CGRectMake(self.width - 30, 10, 20, 20);
            [deleteBtn setEnlargeEdge:8];
            deleteBtn.tag = 250;
            [deleteBtn setImage:self.deleteImage forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(itemDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:deleteBtn];
        }
    }

    NSMutableDictionary *dic = nil;
    UIView *deleteBtn = [self viewWithTag:250];
    cell.tag = indexPath.row;
    
    if(defaultString == nil)
    {
        dic = [dataArray objectAtIndex:indexPath.row];
        deleteBtn.hidden = NO;
    }
    else
    {
        if(indexPath.row == 0)
        {
            dic = [[NSMutableDictionary alloc] init];
            [dic setValue:defaultString forKey:key];
            deleteBtn.hidden = YES;
        }
        else
        {
            dic = [dataArray objectAtIndex:indexPath.row-1];
            deleteBtn.hidden = NO;
        }
    }
    
    cell.textLabel.textAlignment = self.textAlignment;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [dic objectForKey:key];
    
    return cell;
}

-(void)itemDeleteClick:(UIButton *)sender
{
    UIView *parent = sender.superview;
    while ([parent isKindOfClass:[UITableViewCell class]] == NO) {
        parent = parent.superview;
    }
    
    if ([self.delegateForSup respondsToSelector:@selector(deleteRowItem:)]) {
        [self.delegateForSup deleteRowItem:parent.tag];
    }
    
    [dataArray removeObjectAtIndex:parent.tag];
    [self reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = nil;
    if(defaultString == nil)
    {
        dic = [dataArray objectAtIndex:indexPath.row];
    }
    else
    {
        if(indexPath.row == 0)
        {
           
        }
        else
        {
            dic = [dataArray objectAtIndex:indexPath.row-1];
        }
    }
    if([delegateForSup respondsToSelector:@selector(selectDic:)])
        [delegateForSup selectDic:dic];
}

#pragma mark -

@end
