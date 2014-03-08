//
//  RSSContentViewController.m
//  RSSReader
//
//  Created by Coremail on 14-3-8.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "RSSContentViewController.h"
#import "RSSParseOperation.h"
#import "RSSWebViewController.h"

@interface RSSContentViewController () <RSSParseOperationDelegate>
@property (nonatomic, copy) NSString *channelTitle;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation RSSContentViewController

@synthesize items = _items;

- (void)setUrl:(NSURL *)url
{
    _url = url;
    [self startDownloadFeed];
}

- (NSMutableArray *)items
{
    if (!_items) _items = [[NSMutableArray alloc] init];
    return _items;
}

- (void)setItems:(NSMutableArray *)items
{
    _items = items;
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Item Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    RSSItem *item = self.items[indexPath.row];
    cell.textLabel.text = item.itemTitle;
    cell.detailTextLabel.text = item.itemDescription;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[RSSWebViewController class]]) {
        RSSWebViewController * webViewController = (RSSWebViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        RSSItem *selectItem = self.items[indexPath.row];
        webViewController.title = selectItem.itemTitle;
        webViewController.url = [NSURL URLWithString:selectItem.itemLink];
    }
}

#pragma mark - RSSParseOperation delegate

- (void)channelTitle:(NSString *)title
{
    self.channelTitle = title;
}

#pragma mark - Helper functions

- (void)startDownloadFeed
{
    if (self.url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
            completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                if (!error) {
                    if ([request.URL isEqual:self.url]) {
                        RSSParseOperation *parseOperation = [[RSSParseOperation alloc] initWithURL:location];
                        parseOperation.delegate = self;
                        NSMutableArray *parsedItems = [parseOperation parse];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.title = self.channelTitle;
                            self.items = parsedItems;
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
        }];
        [task resume];
    }
}

@end
