//
//  RSSAddFeedViewController.m
//  RSSReader
//
//  Created by Coremail on 14-3-8.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "RSSAddFeedViewController.h"
#import "Feed+Create.h"
#import "RSSFeedParser.h"

@interface RSSAddFeedViewController () <UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, copy) NSString *feedTitle;
@property (nonatomic, copy) NSString *feedDescription;
@property (nonatomic, strong) NSMutableArray *feedItems;        // array of stories
@end

@implementation RSSAddFeedViewController

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
    self.addButton.enabled = NO;
    self.textField.delegate = self;
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addFeed:(UIButton *)sender
{
    [self.textField resignFirstResponder];
    if (self.textField.text) {
        NSString *link = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t"]];
        if (link.length) {
            Feed *feed = [Feed feedWithLink:link inManagedContext:self.managedObjectContext];
            if (feed) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add feed error"
                                                                    message:[NSString stringWithFormat:@"Feed %@ already exists", link]
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                [self startDownloadFeed:[NSURL URLWithString:link]];
            }
        }
    }
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self addFeed:nil];
    return YES;
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Add feed error"]) {
        [self.textField becomeFirstResponder];
    }
}

#pragma mark - Actions

- (IBAction)textFieldEditingChanged:(UITextField *)sender
{
    self.addButton.enabled = (sender.text.length > 0);
}

#pragma mark - Helper functions

- (void)startDownloadFeed:(NSURL *)feedURL
{
    if (feedURL) {
        self.addButton.enabled = NO;
        [self.spinner startAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSURLRequest *request = [NSURLRequest requestWithURL:feedURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
            completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                if (!error) {
                    NSLog(@"Download feed %@ to location:%@", feedURL, location);
                    if ([request.URL isEqual:feedURL]) {
                        RSSFeedParser *parser = [[RSSFeedParser alloc] initWithURL:feedURL];
                        NSDictionary *feedDictionary = [parser parse];
                        if (feedDictionary) {
                            NSLog(@"Parse feed %@ success", feedURL);
                            [self.managedObjectContext performBlock:^{
                                __block Feed *feed = [Feed feedWithDictionary:feedDictionary inManagedObjectContext:self.managedObjectContext];
                                [self downloadFavicon:[self faviconURL:feedURL] completionHandler:^(UIImage *image) {
                                    feed.icon = image;
                                }];
                            }];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self performSegueWithIdentifier:@"Unwind To Feed List" sender:self.addButton];
                            });
                        } else {
                            NSLog(@"Parse feed %@ error", feedURL);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showAlertViewWithTitle:@"Parse feed error" message:nil];
                            });
                        }
                    }
                } else {
                    NSLog(@"Download feed %@ error:%@", feedURL, error.localizedDescription);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showAlertViewWithTitle:@"Fetch feed error" message:error.localizedDescription];
                    });
                }
                dispatch_async(dispatch_get_main_queue(), ^{ [self finishDownload]; });
            }];
        [task resume];
    }
}

- (void)finishDownload
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.addButton.enabled = YES;
    [self.spinner stopAnimating];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (NSURL *)faviconURL:(NSURL *)feedURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/favicon.ico", feedURL.scheme, feedURL.host]];
}

- (void)downloadFavicon:(NSURL *)faviconURL completionHandler:(void(^)(UIImage *image))completionHandler
{
    if (faviconURL) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:faviconURL
            completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                if (!error) {
                    NSLog(@"Download favorite icon %@ to location:%@", faviconURL, location);
                    UIImage *favicon = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                    completionHandler(favicon);
                } else {
                    NSLog(@"Download favorite icon %@ error:%@", faviconURL, error.localizedDescription);
                    completionHandler(nil);
                }
            }];
        [task resume];
    }
}

@end
