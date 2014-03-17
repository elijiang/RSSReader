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
#import <CoreData/CoreData.h>
#import "Feed.h"

@interface RSSFeedListViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation RSSFeedListViewController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Feed"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"title" cacheName:nil];
    }
    return _fetchedResultsController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self.rssList addObject:[NSURL URLWithString:@"http://coolshell.cn/feed"]];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"section count:%d", self.fetchedResultsController.sections.count);
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

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
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.feeds removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", segue.destinationViewController);
    if ([segue.destinationViewController isKindOfClass:[RSSStoryListViewController class]]) {
//        RSSStoryListViewController *storyListViewController = (RSSStoryListViewController *)segue.destinationViewController;
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//        RSSFeed *feed = self.feeds[indexPath.row];
//        storyListViewController.title = feed.feedTitle;
//        storyListViewController.items = [feed.feedItems copy];
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
//    if ([segue.sourceViewController isKindOfClass:[RSSAddFeedViewController class]]) {
//        RSSAddFeedViewController *addFeedVC = (RSSAddFeedViewController *)segue.sourceViewController;
//        if (addFeedVC.feed) {
//            [self.feeds addObject:addFeedVC.feed];
//            [self.tableView reloadData];
//        }
//    }
}


@end
