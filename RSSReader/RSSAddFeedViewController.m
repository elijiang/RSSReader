//
//  RSSAddFeedViewController.m
//  RSSReader
//
//  Created by Coremail on 14-3-8.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "RSSAddFeedViewController.h"
#import "RSSParseOperation.h"

@interface RSSAddFeedViewController () <RSSParseOperationDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonCancel;
@end

@implementation RSSAddFeedViewController

//- (RSSFeed *)feed
//{
//    if (!_feed) _feed = [[RSSFeed alloc] init];
//    return _feed;
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addFeed:(UIButton *)sender
{
    if (self.textField.text) {
        NSString *url = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t"]];
        if (url.length) {
            [self startDownloadFeed:[NSURL URLWithString:url]];
        }
    }
}

#pragma mark - RSSParseOpertion delegate

- (void)channelTitle:(NSString *)title
{
    self.feed.feedTitle = title;
}

- (void)channelDescription:(NSString *)description
{
    self.feed.feedDescription = description;
}

- (void)parsedItems:(NSMutableArray *)items
{
    self.feed.feedItems = items;
}

#pragma mark - Helper functions

- (void)startDownloadFeed:(NSURL *)feedURL
{
    if (feedURL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:feedURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
            completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                if (!error) {
                    if ([request.URL isEqual:feedURL]) {
                        RSSParseOperation *parseOperation = [[RSSParseOperation alloc] initWithURL:location];
                        parseOperation.delegate = self;
                        self.feed = [[RSSFeed alloc] init];
                        if ([parseOperation parse]) {
                            self.feed.feedURL = feedURL;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self performSegueWithIdentifier:@"Unwind To Feed List" sender:self.buttonAdd];
                            });
                        } else {
                            self.feed = nil;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Parse feed error"
                                                                                    message:[parseOperation parserError].localizedDescription
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"Cancel"
                                                                          otherButtonTitles:nil, nil];
                                [alertView show];
                            });
                        }
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
