//
//  CPVideo.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/5/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPObject.h"

@interface CPVideo : CPObject<NSCoding>

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *thumbnailUrl;

+ (instancetype)videoWithName:(NSString *)name
             descriptionVideo:(NSString *)descriptionVideo
                   conveyorID:(int)conveyorID
                     bucketID:(int)bucketID
                    createdAt:(int)createdAt
                    updatedAt:(int)updatedAt;

+ (instancetype)videoWithJSONDictionary:(NSDictionary *)dictionary;

+ (void)getAllVideosWithAuthenticationKey:(NSString *)authenticationKey
                        completionHandler:(void(^)(NSURLResponse *response, NSError *error))completionHandler;

+ (void)saveVideoWithAuthenticationKey:(NSString *)authenticationKey
                             videoData:(NSData *)videoData
                                  name:(NSString *)name
                        descriptionVid:(NSString *)descriptionVid
                            conveyorID:(int)conveyorID
                              bucketID:(int)bucketID
                             createdAt:(int)createdAt
                             updatedAt:(int)updatedAt
                     completionHandler:(void(^)(NSURLResponse *response, NSError *error, NSString *name))completionHandler;

+ (void)updateVideoWithAuthenticationKey:(NSString *)authenticationKey
                                      ID:(int)ID
                                    name:(NSString *)name
                        descriptionVideo:(NSString *)descriptionVideo
                                     url:(NSString *)url
                           thumbanailUrl:(NSString *)thumbnailUrl
                              conveyorID:(int)conveyorID
                                bucketID:(int)bucketID
                               createdAt:(int)createdAt
                               updatedAt:(int)updatedAt
                       completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)deleteVideoWithWithAuthenticationKey:(NSString *)authenticationKey
                                          ID:(int)ID
                           completionHandler:(void(^)(BOOL success))completionHandler;

@end
