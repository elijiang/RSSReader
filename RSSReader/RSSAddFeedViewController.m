//
//  RSSAddFeedViewController.m
//  RSSReader
//
//  Created by Coremail on 14-3-8.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "RSSAddFeedViewController.h"
#import "RSSParseOperation.h"
#import "Feed+Create.h"

@interface RSSAddFeedViewController () <RSSParseOperationDelegate, UITextFieldDelegate>
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
    self.feedTitle = title;
}

- (void)channelDescription:(NSString *)description
{
    self.feedDescription = description;
}

- (void)parsedItems:(NSMutableArray *)items
{
    self.feedItems = items;
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    [self addFeed:nil];
    return YES;
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
                        RSSParseOperation *parseOperation = [[RSSParseOperation alloc] initWithURL:location];
                        parseOperation.delegate = self;
                        if ([parseOperation parse]) {
                            NSLog(@"Parse feed %@ success", feedURL);
                            [self.managedObjectContext performBlock:^{
                                [Feed feedWithURL:feedURL title:self.feedTitle desc:self.feedDescription items:self.feedItems inManagedObjectContext:self.managedObjectContext];
                            }];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self performSegueWithIdentifier:@"Unwind To Feed List" sender:self.addButton];
                            });
                        } else {
                            NSLog(@"Parse feed %@ error, %@", feedURL, [parseOperation parserError].localizedDescription);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showAlertViewWithTitle:@"Parse feed error" message:[parseOperation parserError].localizedDescription];
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

@end
