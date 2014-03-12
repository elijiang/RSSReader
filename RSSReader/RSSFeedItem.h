//
//  RSSItem.h
//  RSSReader
//
//  Created by Coremail on 14-3-8.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSFeedItem : NSObject
@property (nonatomic, copy) NSString *itemTitle;
@property (nonatomic, copy) NSString *itemLink;
@property (nonatomic, copy) NSString *itemDescription;
@end
