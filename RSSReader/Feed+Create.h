//
//  Feed+Create.h
//  RSSReader
//
//  Created by Coremail on 14-3-16.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "Feed.h"

@interface Feed (Create)

+ (Feed *)feedWithDictionary:(NSDictionary *)feedDictionary inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Feed *)feedWithLink:(NSString *)feedLink inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)allFeedsinManagedObjectContext:(NSManagedObjectContext *)context;

@end
