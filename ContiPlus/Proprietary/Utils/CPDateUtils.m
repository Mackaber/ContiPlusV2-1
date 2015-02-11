//
//  CPDateUtils.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/4/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPDateUtils.h"
#define kSecondsDay 86400
#define kSecondsHour 3600
#define kSeconds 60

@implementation CPDateUtils

+ (NSString *)stringFromTimeStamp:(NSNumber *)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, YYYY"];
    
    return [dateFormat stringFromDate:date];
}

+ (NSString *)stringYearFromTimeStamp:(NSNumber*)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY"];
    
    return [dateFormat stringFromDate:date];
}

+ (NSString *)comparitionStringFromTimeStamp:(int)timeStamp
{
    NSDate *previusDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSTimeInterval comparition = [[NSDate date] timeIntervalSinceDate:previusDate];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    NSString *dateString;
    if (comparition > kSecondsDay) {
        [dateformatter setDateFormat:@"dd MMM, YYYY"];
        dateString = [dateformatter stringFromDate:previusDate];
    } else if (comparition > kSecondsHour) {
        dateString = [NSString stringWithFormat:@"%i hr", (int)(comparition/kSecondsHour)];
    } else {
        dateString = [NSString stringWithFormat:@"%i min", (int)(comparition/kSeconds)];
    }
    
    return dateString;
}

+ (int)timeStampFromDate:(NSDate *)date
{
    return (int)[date timeIntervalSince1970];
}

+ (int)monthFromDate:(NSNumber*)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth
                                                                   fromDate:date];
    return (int)[components month];
}

@end
