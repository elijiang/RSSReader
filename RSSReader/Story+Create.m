//
//  Story+Create.m
//  RSSReader
//
//  Created by Coremail on 14-3-16.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "Story+Create.h"
#import "RSSFeedParser.h"

@implementation Story (Create)

+ (Story *)storyWithDictionary:(NSDictionary *)storyDictionary
                    createDate:(NSDate *)date
               sequenceInBatch:(NSInteger)sequence
              inManagedContext:(NSManagedObjectContext *)context
{
    Story *story = nil;
    NSString *link = [storyDictionary objectForKey:kLinkElementName];
    if (link.length) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Story"];
        request.predicate = [NSPredicate predicateWithFormat:@"link = %@", link];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        if (error || [matches count] > 1) {
            
        } else if ([matches count]) {
            story = [matches firstObject];
        } else {
            story = [NSEntityDescription insertNewObjectForEntityForName:@"Story" inManagedObjectContext:context];
            story.title = [storyDictionary objectForKey:kTitleElementName];
            story.link = [storyDictionary objectForKey:kLinkElementName];
            story.desc = [storyDictionary objectForKey:kDescriptionElementName];
            story.createDate = date;
            story.sequenceInBatch = @(sequence);
            NSLog(@"Add story, title:%@, link:%@", story.title, story.link);
        }
    }
    
    return story;
}

@end
