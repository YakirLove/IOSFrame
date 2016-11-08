//
//  NDAlbumsTableCell.m
//  NDUIToolKit
//
//  Created by zhangx on 15/7/28.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDAlbumsTableCell.h"

@interface NDAlbumsTableCell(){
    UIImageView *thumbnailImage; ///< 缩略图
    UILabel *albumsLabel;  ///< 相册名称label
    
    UILabel *assertCntLabel; ///< 相册中媒体数量
}

@end

@implementation NDAlbumsTableCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        thumbnailImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 56, 56)];
        [self.contentView addSubview:thumbnailImage];
        
        albumsLabel = [[UILabel alloc] initWithFrame:CGRectMake(thumbnailImage.right + 10, 20, 150, 15)];
        [self.contentView addSubview:albumsLabel];
        
        assertCntLabel = [[UILabel alloc] initWithFrame:CGRectMake(thumbnailImage.right + 10, albumsLabel.bottom + 10, 150, 12)];
        assertCntLabel.font = [UIFont systemFontOfSize:12.0f];
        assertCntLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        [self.contentView addSubview:assertCntLabel];
        
        self.checkMark = [[UIImageView alloc] initWithImage:[UIImage imageInUIToolKitProject:@"check-mark-icon"]];
        [self.contentView addSubview:self.checkMark];
    }
    return self;
}

- (void)drawView:(NDAssetsGroup *)group
{
    thumbnailImage.image = [group posterImage];
    albumsLabel.text = group.groupName;
    assertCntLabel.text = [NSString stringWithFormat:@"%ld",(long)group.numberOfAssets];
}

@end
