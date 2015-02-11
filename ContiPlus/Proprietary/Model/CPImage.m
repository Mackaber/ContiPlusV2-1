//
//  CPImage.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/5/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPImage.h"
#import "CPLanguajeUtils.h"

@implementation CPImage

- (id)init
{
    if ((self = [super init])) {
        _url = @"";
    }
    
    return self;
}

+ (instancetype)imageWithName:(NSString *)name
               descriptionImg:(NSString *)descriptionImg
                   conveyorID:(int)conveyorID
                     bucketID:(int)bucketID
                    createdAt:(int)createdAt
                    updatedAt:(int)updatedAt
{
    CPImage *image = [[self alloc] init];
    image.name = name;
    image.descriptionStr = descriptionImg;
    image.conveyorID = conveyorID;
    image.bucketID = bucketID;
    image.createdAt = createdAt;
    image.updatedAt = updatedAt;
    
    return image;
}

#pragma mark - NSCoding Protocols
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.ID) forKey:@"ID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.descriptionStr forKey:@"descriptionStr"];
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
        self.descriptionStr = [aDecoder decodeObjectForKey:@"descriptionStr"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.conveyorID = [[aDecoder decodeObjectForKey:@"conveyorID"] intValue];
        self.bucketID = [[aDecoder decodeObjectForKey:@"bucketID"] intValue];
        self.createdAt = [[aDecoder decodeObjectForKey:@"createdAt"] intValue];
        self.updatedAt = [[aDecoder decodeObjectForKey:@"updatedAt"] intValue];
    }
    
    return self;
}

+ (instancetype)imageWithJSONDictionary:(NSDictionary *)dictionary;
{
    CPImage *image = [[self alloc] init];
    image.ID                = [dictionary[@"id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"id"] intValue];
    image.name              = [dictionary[@"name"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"name"];
    image.descriptionStr    = [dictionary[@"description"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"description"];
    image.url               = [dictionary[@"url"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"url"];
    image.conveyorID        = [dictionary[@"conveyor_id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"conveyor_id"] intValue];
    image.bucketID          = [dictionary[@"bucket_id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"bucket_id"] intValue];
    image.createdAt         = [dictionary[@"created_at"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"created_at"] intValue];
    image.updatedAt         = [dictionary[@"updated_at"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"updated_at"] intValue];
    
    return image;
}

+ (void)getAllImagesWithAuthenticationKey:(NSString *)authenticationKey
                        completionHandler:(void(^)(NSURLResponse *response, NSError *error))completionHandler
{
    NSURL *url = [NSURL URLWithString:@"http://api.contiplus.net/images"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          NSArray *imagesJsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          NSMutableArray *imagesArray = [NSMutableArray array];
                                          for (NSDictionary *dictionary in imagesJsonArray) {
                                              [imagesArray addObject:[CPImage imageWithJSONDictionary:dictionary]];
                                          }
                                          NSData *encodeImagesArray = [NSKeyedArchiver archivedDataWithRootObject:imagesArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeImagesArray forKey:@"imagesArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                      }
                                      completionHandler(response, error);
                                  }];
    [task resume];
}

+ (void)saveImageWithAuthenticationKey:(NSString *)authenticationKey
                             imageData:(NSData *)imageData
                                  name:(NSString *)name
                        descriptionImg:(NSString *)descriptionImg
                            conveyorID:(int)conveyorID
                              bucketID:(int)bucketID
                             createdAt:(int)createdAt
                             updatedAt:(int)updatedAt
                     completionHandler:(void(^)(NSURLResponse *response, NSError *error, NSString *name, int coverID))completionHandler
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.contiplus.net/images"]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [NSString stringWithFormat:@"%@", [[NSUUID UUID] UUIDString]];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageDetails"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"{\n  \"name\":\"%@\",\n  \"description\":\"%@\",\n  \"conveyor_id\":\"%i\",\n  \"bucket_id\":\"%i\",\n  \"created_at\":\"%i\",\n  \"updated_at\":\"%i\"\n}\r\n", name, descriptionImg, conveyorID, bucketID, createdAt, updatedAt] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%i.jpg\r\n", @"image", createdAt] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
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
                                                                                                                   objectForKey:@"imagesArray"]] mutableCopy];
                                          CPImage *cpImg = [CPImage imageWithJSONDictionary:dict];
                                          [tempArray addObject:cpImg];
                                          NSData *encodeImagesArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeImagesArray forKey:@"imagesArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          
                                          completionHandler(response, error, [NSString stringWithFormat:@"%i%i_%i", cpImg.conveyorID, cpImg.bucketID, cpImg.createdAt], [dict[@"id"] intValue]);
                                      } else {
                                          completionHandler(response, error, @"", 0);
                                      }
                                  }];
    [task resume];
}

+ (void)deleteImageWithWithAuthenticationKey:(NSString *)authenticationKey
                                          ID:(int)ID
                           completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.contiplus.net/images/%i", ID]];
    
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
                                          NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"imagesArray"]] mutableCopy];
                                          for (CPImage *cpImg in tempArray) {
                                              if (cpImg.ID == ID) {
                                                  [tempArray removeObject:cpImg];
                                                  break;
                                              }
                                          }
                                          NSData *encodeImagesArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeImagesArray forKey:@"imagesArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                      } else success = NO;
                                      completionHandler(success);
                                  }];
    [task resume];
}

+ (void)updateImageWithAuthenticationKey:(NSString *)authenticationKey
                                      ID:(int)ID
                                    name:(NSString *)name
                          descriptionImg:(NSString *)descriptionImg
                                     url:(NSString *)url
                              conveyorID:(int)conveyorID
                                bucketID:(int)bucketID
                               createdAt:(int)createdAt
                               updatedAt:(int)updatedAt
                       completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.contiplus.net/images/%i", ID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"PUT"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{\"id\":\"%i\",\n  \"name\":\"%@\",\n  \"description\":\"%@\",\n  \"url\":\"%@\", \n  \"conveyor_id\":\"%i\",\n  \"bucket_id\":\"%i\",\n  \"created_at\":\"%i\",\n  \"updated_at\":\"%i\"\n}", ID, name, descriptionImg, url, conveyorID, bucketID, createdAt, updatedAt] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      BOOL success;
                                      if ((long)[(NSHTTPURLResponse *)response statusCode] == 200 && !error) {
                                          NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"imagesArray"]] mutableCopy];
                                          NSDictionary *updateCpImage = [NSJSONSerialization JSONObjectWithData:data
                                                                                                        options:0
                                                                                                          error:nil];
                                          int index = 0;
                                          for (CPImage *img in tempArray) {
                                              if (img.ID == ID) {
                                                  break;
                                              }
                                              index++;
                                          }
                                          [tempArray replaceObjectAtIndex:index
                                                               withObject:[CPImage imageWithJSONDictionary:updateCpImage]];
                                          NSData *encodeImagesArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeImagesArray forKey:@"imagesArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                      } else success = NO;
                                      completionHandler(success);
                                  }];
    [task resume];
}

@end
