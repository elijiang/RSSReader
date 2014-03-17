//
//  RSSParseOperation.m
//  RSSReader
//
//  Created by Coremail on 14-3-8.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "RSSParseOperation.h"


@interface RSSParseOperation () <NSXMLParserDelegate>
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSMutableArray *parsedItems;
@property (nonatomic, strong) RSSFeedItem *currentItem;
@property (nonatomic, strong) NSMutableString *currentParsedCharacterData;
@property (nonatomic) BOOL accumulatingParsedCharacterData;
@property (nonatomic) BOOL beforeItem;
@end

@implementation RSSParseOperation

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        self.parser.delegate = self;
        self.beforeItem = YES;
    }
    
    return self;
}

- (NSMutableString *)currentParsedCharacterData
{
    if (!_currentParsedCharacterData) _currentParsedCharacterData = [[NSMutableString alloc] init];
    return _currentParsedCharacterData;
}

- (NSMutableArray *)parsedItems
{
    if (!_parsedItems) _parsedItems = [[NSMutableArray alloc] init];
    return _parsedItems;
}

- (BOOL)parse
{
    return [self.parser parse];
}

- (NSError *)parserError
{
    return [self.parser parserError];
}

#pragma mark - Parser contants

static NSString * const kChannelElementName = @"channel";
static NSString * const kItemElementName = @"item";
static NSString * const kTitleElementName = @"title";
static NSString * const kLinkElementName = @"link";
static NSString * const kDescriptionElementName = @"description";

#pragma mark - NSXMLParser delegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
//    NSLog(@"start, element name:swww%@, uri:%@, qname:%@, attributes:%@", elementName, namespaceURI, qName, attributeDict);
    if ([elementName isEqualToString:kItemElementName]) {
        if (self.beforeItem) {
            self.beforeItem = NO;
        }
        self.currentItem = [[RSSFeedItem alloc] init];
    } else if ([elementName isEqualToString:kTitleElementName] || [elementName isEqualToString:kLinkElementName] || [elementName isEqualToString:kDescriptionElementName]) {
        self.accumulatingParsedCharacterData = YES;
        [self.currentParsedCharacterData setString:@""];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//    NSLog(@"end, element name:%@, uri:%@, qname:%@", elementName, namespaceURI, qName);
    if ([elementName isEqualToString:kItemElementName]) {
        if (self.currentItem) {
            [self.parsedItems addObject:self.currentItem];
            self.currentItem = nil;
        }
    } else if ([elementName isEqualToString:kTitleElementName]) {
        if (self.beforeItem) {
            if ([self.delegate respondsToSelector:@selector(channelTitle:)]) {
                [self.delegate channelTitle:self.currentParsedCharacterData];
            }
        } else {
            self.currentItem.itemTitle = self.currentParsedCharacterData;
        }
    } else if ([elementName isEqualToString:kLinkElementName]) {
        self.currentItem.itemLink = self.currentParsedCharacterData;
    } else if ([elementName isEqualToString:kDescriptionElementName]) {
        if (self.beforeItem) {
            if ([self.delegate respondsToSelector:@selector(channelDescription:)]) {
                [self.delegate channelDescription:self.currentParsedCharacterData];
            }
        } else {
            self.currentItem.itemDescription = self.currentParsedCharacterData;
        }
    } else if ([elementName isEqualToString:kChannelElementName]) {
        if ([self.delegate respondsToSelector:@selector(parsedItems:)]) {
            [self.delegate parsedItems:self.parsedItems];
        }
    }
    self.accumulatingParsedCharacterData = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.accumulatingParsedCharacterData) {
        [self.currentParsedCharacterData appendString:string];
    }
}

@end
