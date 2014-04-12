//
//  Feed+Create.m
//  RSSReader
//
//  Created by Coremail on 14-3-16.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "Feed+Create.h"
#import "Story+Create.h"
#import "RSSFeedParser.h"

@implementation Feed (Create)

+ (Feed *)feedWithDictionary:(NSDictionary *)feedDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    Feed *feed = nil;
    NSString *link = [feedDictionary objectForKey:kLinkElementName];
    if (link) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Feed"];
        request.predicate = [NSPredicate predicateWithFormat:@"link = %@", link];
        
        NSError *error;
        NSArray *feeds = [context executeFetchRequest:request error:&error];
        if (error || feeds.count > 1) {
            NSLog(@"Fetch feed with link:%@ error:%@", link, error.localizedDescription);
        } else if (feeds.count) {
            feed = [feeds firstObject];
        } else {
            feed = [NSEntityDescription insertNewObjectForEntityForName:@"Feed" inManagedObjectContext:context];
            feed.link = link;
            feed.title = [feedDictionary objectForKey:kTitleElementName];
            feed.desc = [feedDictionary objectForKey:kDescriptionElementName];
            NSArray *items = [feedDictionary objectForKey:kItemElementName];
            NSDate *now = [NSDate date];
            NSInteger sequence = 0;
            for (NSDictionary *item in items) {
                ++sequence;
                Story *story = [Story storyWithDictionary:item
                                          createDate:now
                                     sequenceInBatch:sequence
                                    inManagedContext:context];
                [feed addStoriesObject:story];
            }
            NSLog(@"Add feed, link:%@, title:%@, item count:%lu", feed.link, feed.title, (unsigned long)feed.stories.count);
        }
    }
    
    return feed;
}

+ (Feed *)feedWithLink:(NSString *)feedLink inManagedObjectContext:(NSManagedObjectContext *)context
{
    Feed *feed = nil;
    if (feedLink) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Feed"];
        request.predicate = [NSPredicate predicateWithFormat:@"link = %@", feedLink];
        
        NSError *error;
        NSArray *feeds = [context executeFetchRequest:request error:&error];
        if (error || feeds.count > 1) {
            NSLog(@"Fetch feed with link:%@ error:%@", feedLink, error.localizedDescription);
        } else if (feeds.count) {
            feed = [feeds firstObject];
        }
    }
    
    return feed;
}

+ (NSArray *)allFeedsinManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *feeds = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Feed"];
    request.predicate = nil;
    
    NSError *error;
    feeds = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Fetch all feeds with error:%@", error.localizedDescription);
        feeds = nil;
    }
    
    return feeds;
}

@end
