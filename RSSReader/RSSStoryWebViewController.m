//
//  RSSWebViewController.m
//  RSSReader
//
//  Created by Coremail on 14-3-8.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "RSSStoryWebViewController.h"

@interface RSSStoryWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation RSSStoryWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"link:%@", self.storyURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:self.storyURL];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
