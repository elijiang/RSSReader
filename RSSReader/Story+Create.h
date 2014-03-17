//
//  Story+Create.h
//  RSSReader
//
//  Created by Coremail on 14-3-16.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "Story.h"

@interface Story (Create)
+ (Story *)storyWithTitle:(NSString *)title link:(NSString *)link desc:(NSString *)desc inManagedContext:(NSManagedObjectContext *)context;
@end
