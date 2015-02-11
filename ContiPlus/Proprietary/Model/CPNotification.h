//
//  CPNotification.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/12/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPNotification : NSObject<NSCoding>

@property (nonatomic) int ID;
@property (strong, nonatomic) NSString *content;
@property (nonatomic) int createdAt;
@property (nonatomic) BOOL read;

+ (instancetype)notificationWithJSONDictionary:(NSDictionary *)dictionary;

+ (void)getAllNotificationsWithAuthenticationKey:(NSString *)authenticationKey
                               completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)changeNotificationEmail:(NSString *)authenticationKey
              completionHandler:(void(^)(BOOL success))completionHandler;

@end
