//
//  RSSContentViewController.m
//  RSSReader
//
//  Created by Coremail on 14-3-8.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "RSSStoryListViewController.h"
#import "RSSParseOperation.h"
#import "RSSStoryWebViewController.h"
#import "Story+Create.h"
#import "RSSStoryListCell.h"

@interface RSSStoryListViewController () <RSSParseOperationDelegate>
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation RSSStoryListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.rowHeight = 66.0f;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Story"];
    request.predicate = [NSPredicate predicateWithFormat:@"belongTo = %@", self.feed];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Item Cell";
    RSSStoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Story *story = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = story.title;
    cell.summaryLabel.text = story.desc;
    cell.summaryLabel.numberOfLines = 2;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[RSSStoryWebViewController class]]) {
        RSSStoryWebViewController * storyWebViewController = (RSSStoryWebViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Story *story = [self.fetchedResultsController objectAtIndexPath:indexPath];
        storyWebViewController.title = story.title;
        storyWebViewController.storyURL = [NSURL URLWithString:story.link];
    }
}

#pragma mark - Actions

- (IBAction)refreshStoryList:(id)sender
{
    [self.refreshControl beginRefreshing];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.feed.url]];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
        completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            if (!error) {
                RSSParseOperation *parser = [[RSSParseOperation alloc] initWithURL:location];
                parser.delegate = self;
                if ([parser parse]) {
                    for (RSSFeedItem *item in self.items) {
                        [self.managedObjectContext performBlock:^{
                            [Story storyWithTitle:item.itemTitle
                                             link:item.itemLink
                                             desc:item.itemDescription
                                 inManagedContext:self.managedObjectContext];
                        }];
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Parse error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fetch feed error"
                                                                        message:error.localizedDescription
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Cancel"
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }];
    [task resume];
}

#pragma mark - RSSParseOperation delegate

- (void)parsedItems:(NSMutableArray *)items
{
    self.items = items;
}

@end
