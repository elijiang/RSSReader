//
//  RSSAddFeedViewController.m
//  RSSReader
//
//  Created by Coremail on 14-3-8.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "RSSAddFeedViewController.h"

@interface RSSAddFeedViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonCancel;

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
            self.feedURL = [NSURL URLWithString:url];
        }
    }
}

@end
