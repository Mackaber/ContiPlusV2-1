//
//  CPMonthArray.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 1/22/15.
//  Copyright (c) 2015 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPMonthArray.h"
#import "CPLanguajeUtils.h"

@implementation CPMonthArray

+ (NSArray *)monthArray
{
    return @[@{@"Number": @1, @"Month": [CPLanguajeUtils languajeSelectedForString:@"Ene"]},
             @{@"Number": @2, @"Month": [CPLanguajeUtils languajeSelectedForString:@"Feb"]},
             @{@"Number": @3, @"Month": [CPLanguajeUtils languajeSelectedForString:@"Mar"]},
             @{@"Number": @4, @"Month": [CPLanguajeUtils languajeSelectedForString:@"Abr"]},
             @{@"Number": @5, @"Month": [CPLanguajeUtils languajeSelectedForString:@"May"]},
             @{@"Number": @6, @"Month": [CPLanguajeUtils languajeSelectedForString:@"Jun"]},
             @{@"Number": @7, @"Month": [CPLanguajeUtils languajeSelectedForString:@"Jul"]},
             @{@"Number": @8, @"Month": [CPLanguajeUtils languajeSelectedForString:@"Ago"]},
             @{@"Number": @9, @"Month": [CPLanguajeUtils languajeSelectedForString:@"Sep"]},
             @{@"Number": @10, @"Month": [CPLanguajeUtils languajeSelectedForString:@"Oct"]},
             @{@"Number": @11, @"Month": [CPLanguajeUtils languajeSelectedForString:@"Nov"]},
             @{@"Number": @12, @"Month": [CPLanguajeUtils languajeSelectedForString:@"Dic"]},];
}

@end
