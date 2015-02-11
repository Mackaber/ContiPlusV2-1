//
//  Client.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/23/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPClient : NSObject<NSCoding>

@property (nonatomic) int ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *corporation;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *dealer;
@property (strong, nonatomic) NSString *region;
@property (nonatomic) BOOL isSuspended;
@property (strong, nonatomic) NSString *imageLink;
@property (nonatomic) int createdAt;
@property (nonatomic) int updatedAt;


+ (instancetype)clientWithID:(int)ID
                        name:(NSString *)name
                        city:(NSString *)city
                     address:(NSString *)address
                 corporation:(NSString *)corporation
                     country:(NSString *)country
                      dealer:(NSString *)dealer
                      region:(NSString *)region
                 isSuspended:(BOOL)suspended
                   imageLink:(NSString *)imageLink
                  createdAt:(int)createdAt
                  updatedAt:(int)updatedAt;

+ (instancetype)clientWithJSONDictionary:(NSDictionary *)dictionary;

+ (void)getAllClientsWithAuthenticationKey:(NSString *)authenticationKey
                         completionHandler:(void(^)(NSURLResponse *response, NSError *error))completionHandler;

+ (void)supendClientWithWithAuthenticationKey:(NSString *)authenticationKey
                                           ID:(int)ID
                            completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)reactivateClientWithWithAuthenticationKey:(NSString *)authenticationKey
                                           ID:(int)ID
                            completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)deleteClientWithWithAuthenticationKey:(NSString *)authenticationKey
                                           ID:(int)ID
                            completionHandler:(void(^)(BOOL success))completionHandler;

@end
