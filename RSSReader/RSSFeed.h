//
//  RSSFeed.h
//  RSSReader
//
//  Created by Coremail on 14-3-12.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSFeed : NSObject
@property (nonatomic, copy) NSURL *feedURL;
@property (nonatomic, copy) NSString *feedTitle;
@property (nonatomic, copy) NSString *feedDescription;
@property (nonatomic, strong) NSMutableArray *feedItems;
@end
