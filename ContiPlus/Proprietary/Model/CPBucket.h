//
//  CPBucket.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/4/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPObject.h"

@interface CPBucket : CPObject<NSCoding>

@property (nonatomic) int ID;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) int conveyorID;
@property (nonatomic) int createdAt;
@property (nonatomic) int updatedAt;

+ (instancetype)bucketWithID:(int)ID
                        name:(NSString *)name
                  conveyorID:(int)conveyorID
                   createdAt:(int)createdAt
                   updatedAt:(int)updatedAt;

+ (instancetype)bucketWithJSONDictionary:(NSDictionary *)dictionary;

+ (void)getAllBucketsWithAuthenticationKey:(NSString *)authenticationKey
                        completionHandler:(void(^)(NSURLResponse *response, NSError *error))completionHandler;

+ (void)saveBucketWithAuthenticationKey:(NSString *)authenticationKey
                                   name:(NSString *)name
                             conveyorID:(int)conveyorID
                              createdAt:(int)createdAt
                              updatedAt:(int)updatedAt
                      completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)updateBucketWithAuthenticationKey:(NSString *)authenticationKey
                                      ID:(int)ID
                                    name:(NSString *)name
                              conveyorID:(int)conveyorID
                               createdAt:(int)createdAt
                               updatedAt:(int)updatedAt
                       completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)deleteBucketWithWithAuthenticationKey:(NSString *)authenticationKey
                                          ID:(int)ID
                           completionHandler:(void(^)(BOOL success))completionHandler;

@end
