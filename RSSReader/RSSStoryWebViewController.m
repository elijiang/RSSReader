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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self progressView].hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    ++self.webViewLoadFrames;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    --self.webViewLoadFrames;
    if (!self.webViewLoadFrames) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.finishLoad = YES;
        NSLog(@"Finished load URL:%@", self.storyURL);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.webViewLoadFrames = 0;
    [self fadeProgressView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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

@end
