//
//  CPNote.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/5/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPObject.h"

@interface CPNote : CPObject<NSCoding>

+ (instancetype)noteWithName:(NSString *)name
                 description:(NSString *)description
                  conveyorID:(int)conveyorID
                    bucketID:(int)bucketID
                   createdAt:(int)createdAt
                   updatedAt:(int)updatedAt;

+ (instancetype)noteWithJSONDictionary:(NSDictionary *)dictionary;

+ (void)getAllNotesWithAuthenticationKey:(NSString *)authenticationKey
                        completionHandler:(void(^)(NSURLResponse *response, NSError *error))completionHandler;

+ (void)saveNoteWithAuthenticationKey:(NSString *)authenticationKey
                                 name:(NSString *)name
                      descriptionNote:(NSString *)descriptionNote
                           conveyorID:(int)conveyorID
                             bucketID:(int)bucketID
                            createdAt:(int)createdAt
                            updatedAt:(int)updatedAt
                    completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)deleteNoteWithWithAuthenticationKey:(NSString *)authenticationKey
                                         ID:(int)ID
                          completionHandler:(void(^)(BOOL success))completionHandler;

@end
