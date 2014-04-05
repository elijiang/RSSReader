//
//  UINavigationWithProgressViewController.m
//  RSSReader
//
//  Created by feriely on 14-4-5.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "UINavigationWithProgressViewController.h"

@interface UINavigationWithProgressViewController ()
@end

@implementation UINavigationWithProgressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.progressView];
    self.progressView.tintColor = self.navigationBar.tintColor;
    self.progressView.hidden = YES;
    
    [self.progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.progressView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.navigationBar
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:-1.0f];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.progressView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.navigationBar
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1
                                                                       constant:0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.progressView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.navigationBar
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1
                                                                        constant:0];
    [self.view addConstraints:@[bottomConstraint, leftConstraint, rightConstraint]];

}

- (UIProgressView *)progressView
{
    if (!_progressView) _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    return _progressView;
}

@end
