//
//  RSSFeedParser.h
//  RSSReader
//
//  Created by feriely on 14-4-12.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kItemElementName = @"item";
static NSString * const kTitleElementName = @"title";
static NSString * const kLinkElementName = @"link";
static NSString * const kDescriptionElementName = @"description";

@interface RSSFeedParser : NSObject

+ (NSDictionary *)parseFeedWithData:(NSData *)data link:(NSString *)link;

@end
