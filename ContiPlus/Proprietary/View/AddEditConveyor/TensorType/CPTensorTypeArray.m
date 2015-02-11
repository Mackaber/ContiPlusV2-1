//
//  CPTensorTypeArray.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/3/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPTensorTypeArray.h"
#import "CPLanguajeUtils.h"

@implementation CPTensorTypeArray

+ (NSArray *)tensorTypeArray
{
    return @[@{@"id": @0, @"Name": @""},
             @{@"id": @127, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Tornillo"]},
             @{@"id": @128, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Gravedad"]}];
}

@end
