//
//  RSSParseOperation.h
//  RSSReader
//
//  Created by Coremail on 14-3-8.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSItem.h"

@protocol RSSParseOperationDelegate;

@interface RSSParseOperation : NSObject

@property (nonatomic, weak) id <RSSParseOperationDelegate> delegate;

- (instancetype)initWithURL:(NSURL *)url;
- (NSMutableArray *)parse;

@end

@protocol RSSParseOperationDelegate <NSObject>

@optional
- (void)channelTitle:(NSString *)title;

@end
