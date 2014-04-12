//
//  RSSViewUtilites.h
//  RSSReader
//
//  Created by feriely on 14-4-12.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSViewUtilites : NSObject

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;

@end
