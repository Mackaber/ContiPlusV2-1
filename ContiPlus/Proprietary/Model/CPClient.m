//
//  Client.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/23/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPClient.h"

@implementation CPClient

- (id)init
{
    if ((self = [super init])) {
        _ID = -1;
        _name = @"";
        _city = @"";
        _address = @"";
        _corporation = @"";
        _country = @"";
        _dealer = @"";
        _region = @"";
        _isSuspended = NO;
        _imageLink = @"";
        _createdAt = 0;
        _updatedAt = 0;
    }
    
    return self;
}

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
                  updatedAt:(int)updatedAt
{
    CPClient *client = [[self alloc] init];
    client.ID = ID;
    client.name = name;
    client.city = city;
    client.address = address;
    client.corporation = corporation;
    client.country = country;
    client.dealer = dealer;
    client.region = region;
    client.isSuspended = suspended;
    client.imageLink = imageLink;
    client.createdAt = createdAt;
    client.updatedAt = updatedAt;
    
    return client;
}

+ (instancetype)clientWithJSONDictionary:(NSDictionary *)dictionary
{
    CPClient *client = [[self alloc] init];
    client.ID             = [dictionary[@"id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"id"] intValue];
    client.name           = [dictionary[@"name"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"name"];
    client.city           = [dictionary[@"city"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"city"];
    client.address        = [dictionary[@"address"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"address"];
    client.corporation    = [dictionary[@"corporation"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"corporation"];
    client.country        = [dictionary[@"country"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"country"];
    client.dealer         = [dictionary[@"dealer"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"dealer"];
    client.region         = [dictionary[@"region"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"region"];
    client.isSuspended    = [dictionary[@"suspended"] isKindOfClass:[NSNull class]] ? NO : [dictionary[@"suspended"] boolValue];
    client.imageLink      = [dictionary[@"image"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"image"];
    client.createdAt      = [dictionary[@"created_at"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"created_at"] intValue];
    client.updatedAt      = [dictionary[@"updated_at"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"updated_at"] intValue];
    
    return client;
}

#pragma mark - NSCoding Protocols
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.ID) forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.corporation forKey:@"corporation"];
    [aCoder encodeObject:self.country forKey:@"country"];
    [aCoder encodeObject:self.dealer forKey:@"dealer"];
    [aCoder encodeObject:self.region forKey:@"region"];
    [aCoder encodeObject:@(self.isSuspended) forKey:@"isSuspended"];
    [aCoder encodeObject:self.imageLink forKey:@"imageLink"];
    [aCoder encodeObject:@(self.createdAt) forKey:@"createdAt"];
    [aCoder encodeObject:@(self.updatedAt) forKey:@"updatedAt"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.ID = [[aDecoder decodeObjectForKey:@"id"] intValue];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.corporation = [aDecoder decodeObjectForKey:@"corporation"];
        self.country = [aDecoder decodeObjectForKey:@"country"];
        self.dealer = [aDecoder decodeObjectForKey:@"dealer"];
        self.region = [aDecoder decodeObjectForKey:@"region"];
        self.isSuspended = [[aDecoder decodeObjectForKey:@"isSuspended"] boolValue];
        self.imageLink = [aDecoder decodeObjectForKey:@"imageLink"];
        self.createdAt = [[aDecoder decodeObjectForKey:@"createdAt"] intValue];
        self.updatedAt = [[aDecoder decodeObjectForKey:@"updatedAt"] intValue];
    }
    
    return self;
}

+ (void)getAllClientsWithAuthenticationKey:(NSString *)authenticationKey
                         completionHandler:(void(^)(NSURLResponse *response, NSError *error))completionHandler
{
    NSURL *url = [NSURL URLWithString:@"http://api.contiplus.net/clients"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          NSArray *clientsJsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          NSMutableArray *clientsArray = [NSMutableArray array];
                                          for (NSDictionary *dictionary in clientsJsonArray) {
                                              [clientsArray addObject:[CPClient clientWithJSONDictionary:dictionary]];
                                          }
                                          NSData *encodeClientArray = [NSKeyedArchiver archivedDataWithRootObject:clientsArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeClientArray forKey:@"clientsArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                      }
                                      completionHandler(response, error);
                                  }];
    [task resume];
}

+ (void)supendClientWithWithAuthenticationKey:(NSString *)authenticationKey
                                           ID:(int)ID
                            completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.contiplus.net/clients/suspend/%i", ID]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      BOOL success;
                                      if (!error && (long)[(NSHTTPURLResponse *)response statusCode] == 204) {
                                          NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientsArray"]] mutableCopy];
                                          
                                          int index = 0;
                                          CPClient *tempClient;
                                          for (CPClient *client in tempArray) {
                                              if (client.ID == ID) {
                                                  tempClient = client;
                                                  break;
                                              }
                                              index++;
                                          }
                                          tempClient.isSuspended = YES;
                                          [tempArray replaceObjectAtIndex:index
                                                               withObject:tempClient];
                                          NSData *encodeConveyorArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeConveyorArray forKey:@"clientsArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                      } else success = NO;
                                      
                                      completionHandler(success);
                                  }];
    [task resume];
}

+ (void)reactivateClientWithWithAuthenticationKey:(NSString *)authenticationKey
                                               ID:(int)ID
                                completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.contiplus.net/clients/reactivate/%i", ID]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      BOOL success;
                                      if (!error && (long)[(NSHTTPURLResponse *)response statusCode] == 204) {
                                          NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientsArray"]] mutableCopy];
                                          
                                          int index = 0;
                                          CPClient *tempClient;
                                          for (CPClient *client in tempArray) {
                                              if (client.ID == ID) {
                                                  tempClient = client;
                                                  break;
                                              }
                                              index++;
                                          }
                                          tempClient.isSuspended = NO;
                                          [tempArray replaceObjectAtIndex:index
                                                               withObject:tempClient];
                                          NSData *encodeConveyorArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeConveyorArray forKey:@"clientsArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                      } else success = NO;
                                      
                                      completionHandler(success);
                                  }];
    [task resume];
}

+ (void)deleteClientWithWithAuthenticationKey:(NSString *)authenticationKey
                                           ID:(int)ID
                            completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.contiplus.net/clients/%i", ID]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      BOOL success;
                                      if ((long)[(NSHTTPURLResponse *)response statusCode] == 204 && !error) {
                                          NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientsArray"]] mutableCopy];
                                          
                                          int index = 0;
                                          for (CPClient *client in tempArray) {
                                              if (client.ID == ID) {
                                                  [tempArray removeObject:client];
                                                  break;
                                              }
                                              index++;
                                          }

                                          NSData *encodeConveyorArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeConveyorArray forKey:@"clientsArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                      } else success = NO;
                                      
                                      completionHandler(success);
                                  }];
    [task resume];
}

@end
