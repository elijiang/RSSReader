//
//  RSSFeedFetcher.m
//  RSSReader
//
//  Created by feriely on 14-4-12.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "RSSFeedFetcher.h"

@implementation RSSFeedFetcher

+ (void)fetchFeedWithURL:(NSURL *)feedURL completionHandler:(void(^)(NSURL *location, NSError *error))completionHandler
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:feedURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
        completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (!error) {
                NSLog(@"Download feed %@ to location:%@", feedURL, location);
                if ([request.URL isEqual:feedURL]) {
                    if (completionHandler) {
                        completionHandler(location, nil);
                    }
                }
            } else {
                NSLog(@"Download feed %@ error:%@", feedURL, error.localizedDescription);
                if (completionHandler) {
                    completionHandler(nil, error);
                }
            }
        }];
    [task resume];
}

@end
