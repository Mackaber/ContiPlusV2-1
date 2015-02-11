//
//  CPMedia.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/5/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPObject.h"

@implementation CPObject

- (id)init
{
    if ((self = [super init])) {
        _ID = -1;
        _name = @"";
        _descriptionStr = @"";
        _conveyorID = 0;
        _bucketID = 0;
        _createdAt = 0;
        _updatedAt = 0;
    }
    
    return self;
}

@end
