//
//  Feed+Create.h
//  RSSReader
//
//  Created by Coremail on 14-3-16.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "Feed.h"

@interface Feed (Create)

+ (Feed *)feedWithURL:(NSURL *)url title:(NSString *)title desc:(NSString *)desc items:(NSMutableArray *)items inManagedObjectContext:(NSManagedObjectContext *)context;

@end
