//
//  CPReport.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 1/1/15.
//  Copyright (c) 2015 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPReport.h"

@implementation CPReport

- (id)init
{
    if ((self = [super init])) {
        _url = @"";
    }
    
    return self;
}

+ (instancetype)reportWithJSONDictionary:(NSDictionary *)dictionary;
{
    CPReport *report = [[self alloc] init];
    report.ID                = [dictionary[@"id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"id"] intValue];
    report.name              = [dictionary[@"name"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"name"];
    report.url               = [dictionary[@"url"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"url"];
    report.conveyorID        = [dictionary[@"conveyor_id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"conveyor_id"] intValue];
    report.bucketID          = [dictionary[@"bucket_id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"bucket_id"] intValue];
    report.createdAt         = [dictionary[@"created_at"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"created_at"] intValue];
    report.updatedAt         = [dictionary[@"updated_at"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"updated_at"] intValue];
    
    return report;
}

#pragma mark - NSCoding Protocols
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.ID) forKey:@"ID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.url forKey:@"url"];
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
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.conveyorID = [[aDecoder decodeObjectForKey:@"conveyorID"] intValue];
        self.bucketID = [[aDecoder decodeObjectForKey:@"bucketID"] intValue];
        self.createdAt = [[aDecoder decodeObjectForKey:@"createdAt"] intValue];
        self.updatedAt = [[aDecoder decodeObjectForKey:@"updatedAt"] intValue];
    }
    
    return self;
}

+ (void)getAllReportsWithAuthenticationKey:(NSString *)authenticationKey
                        completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *url = [NSURL URLWithString:@"http://api.contiplus.net/reports"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      BOOL success;
                                      if (((long)[(NSHTTPURLResponse *)response statusCode] == 200) && !error) {
                                          NSArray *reportsJsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          NSMutableArray *reportsArray = [NSMutableArray array];
                                          for (NSDictionary *dictionary in reportsJsonArray) {
                                              [reportsArray addObject:[CPReport reportWithJSONDictionary:dictionary]];
                                          }
                                          NSData *encodeReportsArray = [NSKeyedArchiver archivedDataWithRootObject:reportsArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeReportsArray forKey:@"reportsArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                      } else success = NO;
                                      completionHandler(success);
                                  }];
    [task resume];
}

@end
