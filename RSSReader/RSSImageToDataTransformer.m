//
//  RSSImageToDataTransformer.m
//  RSSReader
//
//  Created by feriely on 14-4-8.
//  Copyright (c) 2014年 Coremail. All rights reserved.
//

#import "RSSImageToDataTransformer.h"

@implementation RSSImageToDataTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value
{
    return [[UIImage alloc] initWithData:value];
}

@end
