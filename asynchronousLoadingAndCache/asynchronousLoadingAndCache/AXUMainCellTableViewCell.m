//
//  AXUMainCellTableViewCell.m
//  Chat
//
//  Created by zxiou on 15-11-11.
//  Copyright © 2015年 Meng To. All rights reserved.
//

#import "AXUMainCellTableViewCell.h"
#import "UIImageView+CornerRadius.h"

@implementation AXUMainCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView
{
    //头像（防止离屏渲染）
    _headerPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(6, 7, 40, 40)];
    [_headerPhoto zy_cornerRadiusRoundingRect];
//    [_headerPhoto zy_attachBorderWidth:0.0 color:[UIColor lightGrayColor]];
//    _headerPhoto = [[UIImageView alloc] initCircleWithFrame:CGRectMake(6, 7, 40, 40) borderWidth:0.0 borderColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:_headerPhoto];
    
    //名字
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(58, 5, 200, 25)];
    _nameLabel.backgroundColor  = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_nameLabel];
    
    //性别
    _sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(58, 28, 20, 25)];
    _sexLabel.backgroundColor  = [UIColor clearColor];
    _sexLabel.textColor = [UIColor lightGrayColor];
    _sexLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_sexLabel];
    
    //电话
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 28, 240, 25)];
    _phoneLabel.backgroundColor  = [UIColor clearColor];
    _phoneLabel.textColor = [UIColor lightGrayColor];
    _phoneLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_phoneLabel];

    //分割线
    _imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 53, 375, 1)];
    [self.contentView addSubview:_imageLine];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
