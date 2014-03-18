//
//  CoreDataTableViewController.h
//  RSSReader
//
//  Created by Coremail on 14-3-18.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTableViewController : UITableViewController

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
