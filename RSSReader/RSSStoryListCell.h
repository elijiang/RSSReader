//
//  RSSStoryListCell.h
//  RSSReader
//
//  Created by Coremail on 14-3-30.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSStoryListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@end
