//
//  Story+Create.m
//  RSSReader
//
//  Created by Coremail on 14-3-16.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "Story+Create.h"

@implementation Story (Create)

+ (Story *)storyWithTitle:(NSString *)title
                     link:(NSString *)link
                     desc:(NSString *)desc
               createDate:(NSDate *)date
          sequenceInBatch:(NSInteger)sequence
         inManagedContext:(NSManagedObjectContext *)context
{
    Story *story = nil;
    if (title.length) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Story"];
        request.predicate = [NSPredicate predicateWithFormat:@"link = %@", link];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        if (error || [matches count] > 1) {
            
        } else if ([matches count]) {
            story = [matches firstObject];
        } else {
            story = [NSEntityDescription insertNewObjectForEntityForName:@"Story" inManagedObjectContext:context];
            story.title = title;
            story.link = link;
            story.desc = desc;
            story.createDate = date;
            story.sequenceInBatch = @(sequence);
            NSLog(@"Add story, title:%@, link:%@", story.title, story.link);
        }
    }
    
    return story;
}

@end
