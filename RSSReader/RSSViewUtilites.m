//
//  RSSViewUtilites.m
//  RSSReader
//
//  Created by feriely on 14-4-12.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "RSSViewUtilites.h"

@implementation RSSViewUtilites

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    [self showAlertViewWithTitle:title message:message delegate:nil];
}

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:delegate
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    });
}


@end
