//
//  Story+Create.m
//  RSSReader
//
//  Created by Coremail on 14-3-16.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "Story+Create.h"

@implementation Story (Create)

+ (Story *)storyWithTitle:(NSString *)title link:(NSString *)link desc:(NSString *)desc inManagedContext:(NSManagedObjectContext *)context
{
    Story *story = nil;
    if (title.length) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Story"];
        request.predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
        
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
            NSLog(@"Add story, title:%@", story.title);
        }
    }
    
    return story;
}

@end
