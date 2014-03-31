//
//  Feed+Create.m
//  RSSReader
//
//  Created by Coremail on 14-3-16.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "Feed+Create.h"
#import "Story+Create.h"
#import "RSSFeedItem.h"

@implementation Feed (Create)

+ (Feed *)feedWithURL:(NSURL *)url title:(NSString *)title desc:(NSString *)desc items:(NSMutableArray *)items inManagedObjectContext:(NSManagedObjectContext *)context
{
    Feed *feed = nil;
    if (url) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Feed"];
        request.predicate = [NSPredicate predicateWithFormat:@"url = %@", url];
        
        NSError *error;
        NSArray *feeds = [context executeFetchRequest:request error:&error];
        if (error || feeds.count > 1) {
            NSLog(@"Fetch feed with url:%@ error:%@", url, error.localizedDescription);
        } else if (feeds.count) {
            feed = [feeds firstObject];
        } else {
            feed = [NSEntityDescription insertNewObjectForEntityForName:@"Feed" inManagedObjectContext:context];
            feed.url = url.absoluteString;
            feed.title = title;
            feed.desc = desc;
            for (RSSFeedItem *item in items) {
                Story *story = [Story storyWithTitle:item.itemTitle
                                                link:item.itemLink
                                                desc:item.itemDescription
                                    inManagedContext:context];
                [feed addStoriesObject:story];
            }
            NSLog(@"Add feed, url:%@, title:%@, item count:%lu", feed.url, feed.title, (unsigned long)feed.stories.count);
        }
        
    }
    
    return feed;
}

@end
