//
//  CPBucket.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/4/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPBucket.h"
#import "CPLanguajeUtils.h"

@implementation CPBucket

+ (instancetype)bucketWithID:(int)ID
                        name:(NSString *)name
                  conveyorID:(int)conveyorID
                   createdAt:(int)createdAt
                   updatedAt:(int)updatedAt
{
    CPBucket *bucket = [[self alloc] init];
    bucket.ID = ID;
    bucket.name = name;
    bucket.conveyorID = conveyorID;
    bucket.createdAt = createdAt;
    bucket.updatedAt = updatedAt;
    
    return bucket;
}

+ (instancetype)bucketWithJSONDictionary:(NSDictionary *)dictionary
{
    CPBucket *bucket = [[self alloc] init];
    bucket.ID             = [dictionary[@"id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"id"] intValue];
    bucket.name           = [dictionary[@"name"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"name"];
    bucket.conveyorID     = [dictionary[@"conveyor_id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"conveyor_id"] intValue];
    bucket.createdAt      = [dictionary[@"created_at"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"created_at"] intValue];
    bucket.updatedAt      = [dictionary[@"updated_at"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"updated_at"] intValue];
    
    return bucket;
}

#pragma mark - NSCoding Protocols
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.ID) forKey:@"ID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:@(self.conveyorID) forKey:@"conveyorID"];
    [aCoder encodeObject:@(self.createdAt) forKey:@"createdAt"];
    [aCoder encodeObject:@(self.updatedAt) forKey:@"updatedAt"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.ID = [[aDecoder decodeObjectForKey:@"ID"] intValue];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.conveyorID = [[aDecoder decodeObjectForKey:@"conveyorID"] intValue];
        self.createdAt = [[aDecoder decodeObjectForKey:@"createdAt"] intValue];
        self.updatedAt = [[aDecoder decodeObjectForKey:@"updatedAt"] intValue];
    }
    
    return self;
}

+ (void)getAllBucketsWithAuthenticationKey:(NSString *)authenticationKey
                         completionHandler:(void(^)(NSURLResponse *response, NSError *error))completionHandler
{
    NSURL *url = [NSURL URLWithString:@"http://api.contiplus.net/buckets"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          NSArray *bucketsJsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          NSMutableArray *bucketsArray = [NSMutableArray array];
                                          for (NSDictionary *dictionary in bucketsJsonArray) {
                                              [bucketsArray addObject:[CPBucket bucketWithJSONDictionary:dictionary]];
                                          }
                                          NSData *encodeBucketsArray = [NSKeyedArchiver archivedDataWithRootObject:bucketsArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeBucketsArray forKey:@"bucketsArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                      }
                                      completionHandler(response, error);
                                  }];
    [task resume];
}

+ (void)saveBucketWithAuthenticationKey:(NSString *)authenticationKey
                                   name:(NSString *)name
                             conveyorID:(int)conveyorID
                              createdAt:(int)createdAt
                              updatedAt:(int)updatedAt
                      completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *URL = [NSURL URLWithString:@"http://api.contiplus.net/buckets"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"name\":\"%@\",\n  \"conveyor_id\":\"%i\",\n  \"created_at\":\"%i\",\n  \"updated_at\":\"%i\"\n}", name, conveyorID, createdAt, updatedAt] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
                                                                                                                   objectForKey:@"bucketsArray"]] mutableCopy];
                                          [tempArray addObject:[CPBucket bucketWithJSONDictionary:dict]];
                                          NSData *encodeBucketsArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeBucketsArray forKey:@"bucketsArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                      } else success = NO;
                                      completionHandler(success);
                                  }];
    [task resume];
}

+ (void)updateBucketWithAuthenticationKey:(NSString *)authenticationKey
                                       ID:(int)ID
                                     name:(NSString *)name
                               conveyorID:(int)conveyorID
                                createdAt:(int)createdAt
                                updatedAt:(int)updatedAt
                        completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.contiplus.net/buckets/%i", ID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"PUT"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{\"id\":\"%i\",\n  \"name\":\"%@\",\n  \"conveyor_id\":\"%i\",\n  \"created_at\":\"%i\",\n  \"updated_at\":\"%i\"\n}", ID, name, conveyorID, createdAt, updatedAt] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      BOOL success;
                                      if ((long)[(NSHTTPURLResponse *)response statusCode] == 200 && !error) {
                                          NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"bucketsArray"]] mutableCopy];
                                          NSDictionary *updateCpBucket = [NSJSONSerialization JSONObjectWithData:data
                                                                                                        options:0
                                                                                                          error:nil];
                                          int index = 0;
                                          for (CPBucket *bucket in tempArray) {
                                              if (bucket.ID == ID) {
                                                  break;
                                              }
                                              index++;
                                          }
                                          [tempArray replaceObjectAtIndex:index
                                                               withObject:[CPBucket bucketWithJSONDictionary:updateCpBucket]];
                                          NSData *encodeBucketArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeBucketArray forKey:@"bucketsArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                      } else success = NO;
                                      completionHandler(success);
                                  }];
    [task resume];
}

+ (void)deleteBucketWithWithAuthenticationKey:(NSString *)authenticationKey
                                           ID:(int)ID
                            completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.contiplus.net/buckets/%i", ID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      BOOL success;
                                      if ((long)[(NSHTTPURLResponse *)response statusCode] == 204 && !error) {
                                          NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"bucketsArray"]] mutableCopy];
                                          for (CPBucket *cpBuck in tempArray) {
                                              if (cpBuck.ID == ID) {
                                                  [tempArray removeObject:cpBuck];
                                                  break;
                                              }
                                          }
                                          NSData *encodeBucketsArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeBucketsArray forKey:@"bucketsArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                      } else success = NO;
                                      completionHandler(success);
                                  }];
    [task resume];
}

@end
