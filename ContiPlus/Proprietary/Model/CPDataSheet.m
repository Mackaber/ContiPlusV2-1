//
//  CPDataSheet.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/6/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPDataSheet.h"

@implementation CPDataSheet

+ (instancetype)dataSheetWithName:(NSString *)name
                   andDateUpdated:(int)dateUpdated
{
    CPDataSheet *dataSheet = [[CPDataSheet alloc] init];
    dataSheet.name = name;
    dataSheet.updatedAt = dateUpdated;
    
    return dataSheet;
}

@end
