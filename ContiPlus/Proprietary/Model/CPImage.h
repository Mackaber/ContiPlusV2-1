//
//  CPImage.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/5/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPObject.h"

@interface CPImage : CPObject<NSCoding>

@property (strong, nonatomic) NSString *url;

+ (instancetype)imageWithName:(NSString *)name
               descriptionImg:(NSString *)descriptionImg
                   conveyorID:(int)conveyorID
                     bucketID:(int)bucketID
                    createdAt:(int)createdAt
                    updatedAt:(int)updatedAt;

+ (instancetype)imageWithJSONDictionary:(NSDictionary *)dictionary;

+ (void)getAllImagesWithAuthenticationKey:(NSString *)authenticationKey
                        completionHandler:(void(^)(NSURLResponse *response, NSError *error))completionHandler;

+ (void)saveImageWithAuthenticationKey:(NSString *)authenticationKey
                             imageData:(NSData *)imageData
                                  name:(NSString *)name
                        descriptionImg:(NSString *)descriptionImg
                            conveyorID:(int)conveyorID
                              bucketID:(int)bucketID
                             createdAt:(int)createdAt
                             updatedAt:(int)updatedAt
                     completionHandler:(void(^)(NSURLResponse *response, NSError *error, NSString *name, int coverID))completionHandler;

+ (void)deleteImageWithWithAuthenticationKey:(NSString *)authenticationKey
                                          ID:(int)ID
                           completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)updateImageWithAuthenticationKey:(NSString *)authenticationKey
                                      ID:(int)ID
                                    name:(NSString *)name
                          descriptionImg:(NSString *)descriptionImg
                                     url:(NSString *)url
                              conveyorID:(int)conveyorID
                                bucketID:(int)bucketID
                               createdAt:(int)createdAt
                               updatedAt:(int)updatedAt
                       completionHandler:(void(^)(BOOL success))completionHandler;

@end
