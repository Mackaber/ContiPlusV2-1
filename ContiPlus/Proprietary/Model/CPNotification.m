//
//  CPNotification.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/12/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPNotification.h"
#import "CPLanguajeUtils.h"

@implementation CPNotification

- (id)init
{
    if ((self = [super init])) {
        _ID = 0;
        _content = @"";
        _createdAt = 0;
        _read = NO;
    }
    return self;
}

+ (instancetype)notificationWithJSONDictionary:(NSDictionary *)dictionary
{
    CPNotification *notification = [[self alloc] init];
    notification.ID         = [dictionary[@"id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"id"] intValue];
    notification.content    = [dictionary[@"content"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"content"];
    notification.createdAt  = [dictionary[@"created_at"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"created_at"] intValue];

    return notification;
}

#pragma mark - NSCoding Protocols
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.ID) forKey:@"ID"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:@(self.createdAt) forKey:@"createdAt"];
    [aCoder encodeObject:@(self.read) forKey:@"read"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.ID = [[aDecoder decodeObjectForKey:@"ID"] intValue];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.createdAt = [[aDecoder decodeObjectForKey:@"createdAt"] intValue];
        self.read = [[aDecoder decodeObjectForKey:@"read"] boolValue];
    }
    
    return self;
}


+ (void)getAllNotificationsWithAuthenticationKey:(NSString *)authenticationKey
                               completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *URL = [NSURL URLWithString:@"http://api.contiplus.net/notifications"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSMutableArray *notifArray = [NSMutableArray array];
                                      if ([[NSUserDefaults standardUserDefaults] objectForKey:@"notificationsArray"]) {
                                          notifArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationsArray"]] mutableCopy];
                                      }
                                      BOOL success = NO;
                                      if (((long)[(NSHTTPURLResponse *)response statusCode] == 200) && !error) {
                                          success = YES;
                                          NSArray *notifJsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          if (notifArray.count == 0) {
                                              for (NSDictionary *dictionary in notifJsonArray) {
                                                  [notifArray addObject:[CPNotification notificationWithJSONDictionary:dictionary]];
                                              }
                                          } else {
                                              NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:notifJsonArray.count];
                                              for (NSDictionary *dictionary in notifJsonArray) {
                                                  [tempArray addObject:[CPNotification notificationWithJSONDictionary:dictionary]];
                                              }
                                              
                                              for (int i = 0; i < tempArray.count; i++) {
                                                  BOOL found = NO;
                                                  CPNotification *jsonNot = tempArray[i];
                                                  for (int j = 0; j < notifArray.count; j++) {
                                                      CPNotification *localNot = notifArray[j];
                                                      if (jsonNot.ID == localNot.ID) {
                                                          found = YES;
                                                      }
                                                  }
                                                  if (!found) {
                                                      [notifArray addObject:jsonNot];
                                                  }
                                              }
                                          }
                                          NSData *encodeNotificationsArray = [NSKeyedArchiver archivedDataWithRootObject:notifArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeNotificationsArray forKey:@"notificationsArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                      } else success = NO;
                                      completionHandler(success);
                                  }];
    [task resume];
}

+ (void)changeNotificationEmail:(NSString *)authenticationKey
              completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *URL = [NSURL URLWithString:@"http://api.contiplus.net/notifications/toggle"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      BOOL success;
                                      if (((long)[(NSHTTPURLResponse *)response statusCode] == 203) && !error) {
                                          success = YES;
                                      } else success = NO;
                                      completionHandler(success);
                                  }];
    [task resume];
}

@end
