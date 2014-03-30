//
//  RSSStoryListCell.m
//  RSSReader
//
//  Created by Coremail on 14-3-30.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "RSSStoryListCell.h"

@implementation RSSStoryListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
