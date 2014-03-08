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
@property (nonatomic, strong) RSSItem *currentItem;
@property (nonatomic, strong) NSMutableString *currentParsedCharacterData;
@property (nonatomic) BOOL accumulatingParsedCharacterData;
@property (nonatomic, strong) NSString *channelTitle;
@end

@implementation RSSParseOperation

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        self.parser.delegate = self;
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

- (NSMutableArray *)parse
{
    if ([self.parser parse]) {
        return self.parsedItems;
    }
    return nil;
}

#pragma mark - Parser contants

static NSString * const kItemElementName = @"item";
static NSString * const kTitleElementName = @"title";
static NSString * const kLinkElementName = @"link";
static NSString * const kDescriptionElementName = @"description";

#pragma mark - NSXMLParser delegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
//    NSLog(@"start, element name:%@, uri:%@, qname:%@, attributes:%@", elementName, namespaceURI, qName, attributeDict);
    if ([elementName isEqualToString:kItemElementName]) {
        self.currentItem = [[RSSItem alloc] init];
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
        if (!self.channelTitle) {
            self.channelTitle = self.currentParsedCharacterData;
            if ([self.delegate respondsToSelector:@selector(channelTitle:)]) {
                [self.delegate channelTitle:self.channelTitle];
            }
        } else {
            self.currentItem.itemTitle = self.currentParsedCharacterData;
        }
    } else if ([elementName isEqualToString:kLinkElementName]) {
        self.currentItem.itemLink = self.currentParsedCharacterData;
    } else if ([elementName isEqualToString:kDescriptionElementName]) {
        self.currentItem.itemDescription = self.currentParsedCharacterData;
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
