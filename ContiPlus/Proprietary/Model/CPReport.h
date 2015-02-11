//
//  CPReport.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 1/1/15.
//  Copyright (c) 2015 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPObject.h"

@interface CPReport : CPObject<NSCoding>

@property (strong, nonatomic) NSString *url;

+ (instancetype)reportWithJSONDictionary:(NSDictionary *)dictionary;

+ (void)getAllReportsWithAuthenticationKey:(NSString *)authenticationKey
                        completionHandler:(void(^)(BOOL success))completionHandler;

@end
