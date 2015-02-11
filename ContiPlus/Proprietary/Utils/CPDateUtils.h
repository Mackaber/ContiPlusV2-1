//
//  CPDateUtils.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/4/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPDateUtils : NSObject

+ (NSString *)stringFromTimeStamp:(NSNumber *)timeStamp;
+ (NSString *)stringYearFromTimeStamp:(NSNumber*)timeStamp;
+ (NSString *)comparitionStringFromTimeStamp:(int)timeStamp;
+ (int)timeStampFromDate:(NSDate *)date;
+ (int)monthFromDate:(NSNumber*)timeStamp;
@end
