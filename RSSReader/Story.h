//
//  Story.h
//  RSSReader
//
//  Created by feriely on 14-4-6.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Feed;

@interface Story : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * sequenceInBatch;
@property (nonatomic, retain) Feed *belongTo;

@end
