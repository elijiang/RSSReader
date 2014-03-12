//
//  RSSItem.m
//  RSSReader
//
//  Created by Coremail on 14-3-8.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "RSSFeedItem.h"

@implementation RSSFeedItem

- (NSString *)description
{
    return [NSString stringWithFormat:@"title:%@, link:%@, description:%@", self.itemTitle, self.itemLink, self.itemDescription];
}

@end
