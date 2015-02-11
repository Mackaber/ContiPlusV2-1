//
//  CPIdlersArray.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/3/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPIdlersArray.h"

@implementation CPIdlersArray

+ (NSArray *)anglesImpactArray
{
    return @[@{@"id": @0,   @"Value": @""},
             @{@"id": @124, @"Value": @"20"},
             @{@"id": @125, @"Value": @"35"},
             @{@"id": @126, @"Value": @"45"}];
}

+ (NSArray *)anglesLoadArray
{
    return @[@{@"id": @0,   @"Value": @""},
             @{@"id": @118, @"Value": @"20"},
             @{@"id": @119, @"Value": @"35"},
             @{@"id": @120, @"Value": @"45"}];
}

+ (NSArray *)diametersLoadArray
{
    return @[@{@"id": @0,   @"Value": @""},
             @{@"id": @115, @"Value": @"4"},
             @{@"id": @116, @"Value": @"5"},
             @{@"id": @117, @"Value": @"6"}];
}

+ (NSArray *)diametersReturnArray
{
    return @[@{@"id": @0,   @"Value": @""},
             @{@"id": @121, @"Value": @"4"},
             @{@"id": @122, @"Value": @"5"},
             @{@"id": @123, @"Value": @"6"}];
}

+ (NSArray *)partTroughingArray;
{
    return @[@{@"id": @0,   @"Value": @""},
             @{@"id": @1,   @"Value": @"1"},
             @{@"id": @2,   @"Value": @"2"},
             @{@"id": @3,   @"Value": @"3"},
             @{@"id": @5,   @"Value": @"5"}];
}

@end
