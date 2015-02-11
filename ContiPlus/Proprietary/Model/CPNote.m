//
//  CPNote.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/5/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPNote.h"
#import "CPLanguajeUtils.h"

@implementation CPNote

+ (instancetype)noteWithName:(NSString *)name
                 description:(NSString *)description
                  conveyorID:(int)conveyorID
                    bucketID:(int)bucketID
                   createdAt:(int)createdAt
                   updatedAt:(int)updatedAt
{
    CPNote *note = [[self alloc] init];
    note.name = name;
    note.descriptionStr = description;
    note.conveyorID = conveyorID;
    note.bucketID = bucketID;
    note.createdAt = createdAt;
    note.updatedAt = updatedAt;
    
    return note;
}

+ (instancetype)noteWithJSONDictionary:(NSDictionary *)dictionary;
{
    CPNote *note = [[self alloc] init];
    note.ID             = [dictionary[@"id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"id"] intValue];
    note.name           = [dictionary[@"name"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"name"];
    note.descriptionStr = [dictionary[@"description"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"description"];
    note.conveyorID     = [dictionary[@"conveyor_id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"conveyor_id"] intValue];
    note.bucketID       = [dictionary[@"bucket_id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"bucket_id"] intValue];
    note.createdAt      = [dictionary[@"created_at"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"created_at"] intValue];
    note.updatedAt      = [dictionary[@"updated_at"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"updated_at"] intValue];
    
    return note;
}

#pragma mark - NSCoding Protocols
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.ID) forKey:@"ID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.descriptionStr forKey:@"descriptionStr"];
    [aCoder encodeObject:@(self.conveyorID) forKey:@"conveyorID"];
    [aCoder encodeObject:@(self.bucketID) forKey:@"bucketID"];
    [aCoder encodeObject:@(self.createdAt) forKey:@"createdAt"];
    [aCoder encodeObject:@(self.updatedAt) forKey:@"updatedAt"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.ID = [[aDecoder decodeObjectForKey:@"ID"] intValue];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.descriptionStr = [aDecoder decodeObjectForKey:@"descriptionStr"];
        self.conveyorID = [[aDecoder decodeObjectForKey:@"conveyorID"] intValue];
        self.bucketID = [[aDecoder decodeObjectForKey:@"bucketID"] intValue];
        self.createdAt = [[aDecoder decodeObjectForKey:@"createdAt"] intValue];
        self.updatedAt = [[aDecoder decodeObjectForKey:@"updatedAt"] intValue];
    }
    
    return self;
}

+ (void)getAllNotesWithAuthenticationKey:(NSString *)authenticationKey
                       completionHandler:(void(^)(NSURLResponse *response, NSError *error))completionHandler
{
    NSURL *url = [NSURL URLWithString:@"http://api.contiplus.net/notes"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          NSArray *jsonNotesArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          NSMutableArray *notesArray = [NSMutableArray array];
                                          for (NSDictionary *dictionary in jsonNotesArray) {
                                              [notesArray addObject:[CPNote noteWithJSONDictionary:dictionary]];
                                          }
                                          NSData *encodeNotesArray = [NSKeyedArchiver archivedDataWithRootObject:notesArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeNotesArray forKey:@"notesArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                      }
                                      completionHandler(response, error);
                                  }];
    [task resume];
}

+ (void)saveNoteWithAuthenticationKey:(NSString *)authenticationKey
                                 name:(NSString *)name
                      descriptionNote:(NSString *)descriptionNote
                           conveyorID:(int)conveyorID
                             bucketID:(int)bucketID
                            createdAt:(int)createdAt
                            updatedAt:(int)updatedAt
                    completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *URL = [NSURL URLWithString:@"http://api.contiplus.net/notes"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{\n  \"name\":\"%@\",\n  \"description\":\"%@\",\n  \"conveyor_id\":%i,\n  \"bucket_id\":%i,\n  \"created_at\":%i,\n  \"updated_at\":%i\n}", name, descriptionNote, conveyorID, bucketID, createdAt, updatedAt] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      BOOL success;
                                      if (!error && (long)[(NSHTTPURLResponse *)response statusCode] == 201) {
                                          NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:0
                                                                                                 error:nil];
                                          NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]
                                                                                                                   objectForKey:@"notesArray"]] mutableCopy];
                                          [tempArray addObject:[CPNote noteWithJSONDictionary:dict]];
                                          NSData *encodeNotesArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeNotesArray forKey:@"notesArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                      } else success = NO;
                                      completionHandler(success);
                                  }];
    [task resume];
}

+ (void)deleteNoteWithWithAuthenticationKey:(NSString *)authenticationKey
                                         ID:(int)ID
                          completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.contiplus.net/notes/%i", ID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      BOOL success;
                                      if ((long)[(NSHTTPURLResponse *)response statusCode] == 204 && !error) {
                                          NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"notesArray"]] mutableCopy];
                                          for (CPNote *cpNote in tempArray) {
                                              if (cpNote.ID == ID) {
                                                  [tempArray removeObject:cpNote];
                                                  break;
                                              }
                                          }
                                          NSData *encodeNotesArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeNotesArray forKey:@"notesArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                      } else success = NO;
                                      completionHandler(success);
                                  }];
    [task resume];
}

@end
