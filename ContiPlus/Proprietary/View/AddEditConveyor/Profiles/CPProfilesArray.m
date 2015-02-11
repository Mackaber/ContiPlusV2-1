//
//  CPProfilesArray.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/6/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPProfilesArray.h"

@implementation CPProfilesArray

+ (NSArray *)profilesArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 40; i++) {
        array[i] = @{@"id": [NSNumber numberWithInt:i + 1], @"Image": [NSString stringWithFormat:@"profile_%i", i + 1]};
    }
    
    return array;
}

@end
