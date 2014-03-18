//
//  RSSURLViewController.m
//  RSSReader
//
//  Created by Coremail on 14-3-8.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "RSSFeedListViewController.h"
#import "RSSStoryListViewController.h"
#import "RSSAddFeedViewController.h"
#import "Feed.h"

@interface RSSFeedListViewController ()

@end

@implementation RSSFeedListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self.rssList addObject:[NSURL URLWithString:@"http://coolshell.cn/feed"]];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Feed"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RSS List Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Feed *feed = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = feed.title;
    cell.detailTextLabel.text = feed.desc;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Feed *feed = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:feed];
    }
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[RSSStoryListViewController class]]) {
        RSSStoryListViewController *storyListViewController = (RSSStoryListViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Feed *feed = [self.fetchedResultsController objectAtIndexPath:indexPath];
        storyListViewController.feed = feed;
        storyListViewController.title = feed.title;
        storyListViewController.managedObjectContext = self.managedObjectContext;
    } else if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        if ([[navigationController.viewControllers firstObject] isKindOfClass:[RSSAddFeedViewController class]]) {
            RSSAddFeedViewController *addFeedViewController = (RSSAddFeedViewController *)[navigationController.viewControllers firstObject];
            addFeedViewController.managedObjectContext = self.managedObjectContext;
        }
    }
}

#pragma mark - Actions

- (IBAction)unwindToFeedList:(UIStoryboardSegue *)segue
{
}

@end