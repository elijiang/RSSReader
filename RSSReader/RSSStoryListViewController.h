//
//  RSSContentViewController.h
//  RSSReader
//
//  Created by Coremail on 14-3-8.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"
#import "CoreDataTableViewController.h"

@interface RSSStoryListViewController : CoreDataTableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Feed *feed;
@end
