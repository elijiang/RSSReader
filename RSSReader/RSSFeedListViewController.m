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
#import "RSSFeed.h"

@interface RSSFeedListViewController ()
@property (nonatomic, strong) NSMutableArray *feeds;    // array of feed
@end

@implementation RSSFeedListViewController

- (NSMutableArray *)feeds
{
    if (!_feeds) _feeds = [[NSMutableArray alloc] init];
    return _feeds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self.rssList addObject:[NSURL URLWithString:@"http://coolshell.cn/feed"]];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RSS List Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    RSSFeed *feed = self.feeds[indexPath.row];
    cell.textLabel.text = feed.feedTitle;
    cell.detailTextLabel.text = feed.feedDescription;
    
    return cell;
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[RSSStoryListViewController class]]) {
        RSSStoryListViewController *storyListViewController = (RSSStoryListViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        RSSFeed *feed = self.feeds[indexPath.row];
        storyListViewController.title = feed.feedTitle;
        storyListViewController.items = [feed.feedItems copy];
    }
}

#pragma mark - Actions

- (IBAction)unwindToFeedList:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[RSSAddFeedViewController class]]) {
        RSSAddFeedViewController *addFeedVC = (RSSAddFeedViewController *)segue.sourceViewController;
        if (addFeedVC.feed) {
            [self.feeds addObject:addFeedVC.feed];
            [self.tableView reloadData];
        }
    }
}


@end
