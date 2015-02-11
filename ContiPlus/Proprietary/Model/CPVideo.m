//
//  CPVideo.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/5/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPVideo.h"
#import "CPLanguajeUtils.h"

@implementation CPVideo

- (id)init
{
    if ((self = [super init])) {
        _url = @"";
        _thumbnailUrl = @"";
    }
    
    return self;
}

+ (instancetype)videoWithName:(NSString *)name
             descriptionVideo:(NSString *)descriptionVideo
                   conveyorID:(int)conveyorID
                     bucketID:(int)bucketID
                    createdAt:(int)createdAt
                    updatedAt:(int)updatedAt
{
    CPVideo *video = [[self alloc] init];
    video.name = name;
    video.descriptionStr = descriptionVideo;
    video.conveyorID = conveyorID;
    video.bucketID = bucketID;
    video.createdAt = createdAt;
    video.updatedAt = updatedAt;
    
    return video;
}

+ (instancetype)videoWithJSONDictionary:(NSDictionary *)dictionary;
{
    CPVideo *video = [[self alloc] init];
    video.ID                = [dictionary[@"id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"id"] intValue];
    video.name              = [dictionary[@"name"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"name"];
    video.descriptionStr    = [dictionary[@"description"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"description"];
    video.url               = [dictionary[@"url"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"url"];
    video.thumbnailUrl      = [dictionary[@"thumbnail_url"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"thumbnail_url"];
    video.conveyorID        = [dictionary[@"conveyor_id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"conveyor_id"] intValue];
    video.bucketID          = [dictionary[@"bucket_id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"bucket_id"] intValue];
    video.createdAt         = [dictionary[@"created_at"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"created_at"] intValue];
    video.updatedAt         = [dictionary[@"updated_at"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"updated_at"] intValue];
    
    return video;
}

#pragma mark - NSCoding Protocols
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.ID) forKey:@"ID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.descriptionStr forKey:@"descriptionStr"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.thumbnailUrl forKey:@"thumbnailUrl"];
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
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.thumbnailUrl = [aDecoder decodeObjectForKey:@"thumbnailUrl"];
        self.conveyorID = [[aDecoder decodeObjectForKey:@"conveyorID"] intValue];
        self.bucketID = [[aDecoder decodeObjectForKey:@"bucketID"] intValue];
        self.createdAt = [[aDecoder decodeObjectForKey:@"createdAt"] intValue];
        self.updatedAt = [[aDecoder decodeObjectForKey:@"updatedAt"] intValue];
    }
    
    return self;
}

+ (void)getAllVideosWithAuthenticationKey:(NSString *)authenticationKey
                        completionHandler:(void(^)(NSURLResponse *response, NSError *error))completionHandler
{
    NSURL *url = [NSURL URLWithString:@"http://api.contiplus.net/videos"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          NSArray *jsonVideosArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          NSMutableArray *videosArray = [NSMutableArray array];
                                          for (NSDictionary *dictionary in jsonVideosArray) {
                                              [videosArray addObject:[CPVideo videoWithJSONDictionary:dictionary]];
                                          }
                                          NSData *encodeVideosArray = [NSKeyedArchiver archivedDataWithRootObject:videosArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeVideosArray forKey:@"videosArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                      }
                                      completionHandler(response, error);
                                  }];
    [task resume];
}

+ (void)saveVideoWithAuthenticationKey:(NSString *)authenticationKey
                             videoData:(NSData *)videoData
                                  name:(NSString *)name
                        descriptionVid:(NSString *)descriptionVid
                            conveyorID:(int)conveyorID
                              bucketID:(int)bucketID
                             createdAt:(int)createdAt
                             updatedAt:(int)updatedAt
                     completionHandler:(void(^)(NSURLResponse *response, NSError *error, NSString *name))completionHandler
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.contiplus.net/videos"]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [NSString stringWithFormat:@"%@", [[NSUUID UUID] UUIDString]];
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"videoDetails"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"{\n  \"name\":\"%@\",\n  \"description\":\"%@\",\n  \"conveyor_id\":\"%i\",\n  \"bucket_id\":\"%i\",\n  \"created_at\":\"%i\",\n  \"updated_at\":\"%i\"\n}\r\n", name, descriptionVid, conveyorID, bucketID, createdAt, updatedAt] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    if (videoData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%i.mp4\r\n", @"video", createdAt] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: video/mp4\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:videoData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (((long)[(NSHTTPURLResponse *)response statusCode] == 201) && !error) {
                                          NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:0
                                                                                                 error:nil];
                                          NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]
                                                                                                                   objectForKey:@"videosArray"]] mutableCopy];
                                          CPVideo *cpVid = [CPVideo videoWithJSONDictionary:dict];
                                          [tempArray addObject:cpVid];
                                          NSData *encodeVideosArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeVideosArray forKey:@"videosArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          
                                          completionHandler(response, error, [NSString stringWithFormat:@"%i%i_%i", cpVid.conveyorID, cpVid.bucketID, cpVid.createdAt]);
                                      } else {
                                          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                              NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                                              NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
                                          }
                                          
                                          NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          NSLog(@"Response Body:\n%@\n", body);
                                          completionHandler(response, error, @"");
                                      }
                                  }];
    [task resume];
}

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
                       completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.contiplus.net/videos/%i", ID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"PUT"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{\"id\":\"%i\",\n  \"name\":\"%@\",\n  \"description\":\"%@\",\n  \"url\":\"%@\",\n \"thumbnail_url\":\"%@\",\n \"conveyor_id\":\"%i\",\n \"bucket_id\":\"%i\",\n  \"created_at\":\"%i\",\n  \"updated_at\":\"%i\"\n}", ID, name, descriptionVideo, url, thumbnailUrl, conveyorID, bucketID, createdAt, updatedAt] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      BOOL success;
                                      if ((long)[(NSHTTPURLResponse *)response statusCode] == 200 && !error) {
                                          NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"videosArray"]] mutableCopy];
                                          NSDictionary *updateCpVideo = [NSJSONSerialization JSONObjectWithData:data
                                                                                                        options:0
                                                                                                          error:nil];
                                          int index = 0;
                                          for (CPVideo *vid in tempArray) {
                                              if (vid.ID == ID) {
                                                  break;
                                              }
                                              index++;
                                          }
                                          [tempArray replaceObjectAtIndex:index
                                                               withObject:[CPVideo videoWithJSONDictionary:updateCpVideo]];
                                          NSData *encodeVideosArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeVideosArray forKey:@"videosArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                      } else success = NO;
                                      completionHandler(success);
                                  }];
    [task resume];
}

+ (void)deleteVideoWithWithAuthenticationKey:(NSString *)authenticationKey
                                          ID:(int)ID
                           completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.contiplus.net/videos/%i", ID]];
    
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
                                          NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"videosArray"]] mutableCopy];
                                          for (CPVideo *cpVid in tempArray) {
                                              if (cpVid.ID == ID) {
                                                  [tempArray removeObject:cpVid];
                                                  break;
                                              }
                                          }
                                          NSData *encodeVideosArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeVideosArray forKey:@"videosArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                      } else success = NO;
                                      completionHandler(success);
                                  }];
    [task resume];
}

@end
