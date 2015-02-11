//
//  CPDataSheet.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/6/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPObject.h"

@interface CPDataSheet : CPObject

+ (instancetype)dataSheetWithName:(NSString *)name
                   andDateUpdated:(int)dateUpdated;

@end
