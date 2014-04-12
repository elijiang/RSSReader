//
//  RSSFeedFetcher.h
//  RSSReader
//
//  Created by feriely on 14-4-12.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSFeedFetcher : NSObject

+ (void)fetchFeedWithURL:(NSURL *)feedURL completionHandler:(void(^)(NSURL * location, NSError *error))completionHandler;

@end
