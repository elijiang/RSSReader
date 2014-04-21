//
//  RSSWebViewController.m
//  RSSReader
//
//  Created by Coremail on 14-3-8.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "RSSStoryWebViewController.h"
#import "UINavigationWithProgressViewController.h"

@interface RSSStoryWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSTimer *progressTimer;
@property (nonatomic) NSInteger webViewLoadFrames;
@property (nonatomic) BOOL finishLoad;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@end

@implementation RSSStoryWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"Begin to load URL:%@", self.storyURL);
    [self progressView].alpha = 1.0f;
    [[self progressView] setProgress:0.1f animated:YES];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.storyURL]];
    self.webView.delegate = self;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1667f target:self selector:@selector(increaseProcess) userInfo:nil repeats:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.backButton.title = @"Back";
    self.backButton.enabled = NO;
    self.forwardButton.title = @"Forward";
    self.forwardButton.enabled = NO;
    NSMutableArray *toolbarButtons = [self.toolbarItems mutableCopy];
    [toolbarButtons addObject:self.stopButton];
    self.toolbarItems = toolbarButtons;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    [self progressView].hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
    [self progressView].hidden = YES;
    [self progressView].progress = 0;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIProgressView *)progressView
{
    UINavigationWithProgressViewController *vc = (UINavigationWithProgressViewController *)self.navigationController;
    return vc.progressView;
}

#pragma mark - UIWebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"begin to load:%@", webView.request.URL);
    ++self.webViewLoadFrames;
    [self updateToolbar];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finished load:%@", webView.request.URL);
    --self.webViewLoadFrames;
    if (!self.webViewLoadFrames) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.finishLoad = YES;
        NSLog(@"Finished load URL:%@", self.storyURL);
    }
    [self updateToolbar];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.webViewLoadFrames = 0;
    [self fadeProgressView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Actions

- (IBAction)backAction:(id)sender
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}

- (IBAction)forwardAction:(id)sender
{
    if (!self.webView.canGoForward) {
        [self.webView goForward];
    }
}

- (IBAction)stopOrRefreshAction:(UIBarButtonItem *)sender
{
    NSMutableArray *toolbarButtons = [self.toolbarItems mutableCopy];
    [toolbarButtons removeLastObject];
    if ([sender isEqual:self.stopButton]) {
        [self.webView stopLoading];
        [toolbarButtons addObject:self.refreshButton];
    } else {
        [self.webView reload];
        [toolbarButtons addObject:self.stopButton];
    }
    self.toolbarItems = toolbarButtons;
}

#pragma mark - Help functions

- (void)increaseProcess
{
    if (self.finishLoad) {
        [[self progressView] setProgress:1.0f animated:YES];
        [self performSelector:@selector(fadeProgressView) withObject:nil afterDelay:1.0f];
        [self.progressTimer invalidate];
    } else if ([self progressView].progress < 0.9f) {
        [[self progressView] setProgress:[self progressView].progress + 0.005f animated:YES];
    }
}

- (void)fadeProgressView
{
    [UIView animateWithDuration:0.2f animations:^{
        [self progressView].alpha = 0;
    } completion:^(BOOL finished) {
        [self progressView].hidden = YES;
        [self progressView].progress = 0;
    }];
}

- (void)updateToolbar
{
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}

@end
