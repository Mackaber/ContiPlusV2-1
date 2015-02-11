//
//  CPUser.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/10/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPUser.h"

@implementation CPUser

+ (CPUser *)sharedUser
{
    static dispatch_once_t pred = 0;
    __strong static CPUser *_sharedUser = nil;
    dispatch_once(&pred, ^{
        _sharedUser = [[CPUser alloc] init];
    });
    
    return _sharedUser;
}

- (id)init
{
    if ((self = [super init])) {
        _name = @"";
        _position = @"";
        _email = @"";
        _urlProfilePicture = @"";
        _phone = @"";
        _ID = 0;
        _businessUnit = @"";
        _region = @"";
        _authKey = @"";
        _rol = @"";
        _helpUrl = @"";
        _privacyUrl = @"";
        _termsUrl = @"";
        _notificationsEmail = NO;
    }
    
    return self;
}

+ (instancetype)userWithName:(NSString *)name
                     positon:(NSString *)position
                       email:(NSString *)email
           urlProfilePicture:(NSString *)urlProfilePicture
                       phone:(NSString *)phone
                          ID:(int)ID
                businessUnit:(NSString *)businessUnit
                      region:(NSString *)region
                     authKey:(NSString *)authKey
                         rol:(NSString *)rol
                     helpUrl:(NSString *)helpUrl
                  privacyUrl:(NSString *)privacyUrl
                    termsUrl:(NSString *)termsUrl
          notificationsEmail:(BOOL)notificationsEmail
{
    CPUser *user = [[self alloc] init];
    user.name = name;
    user.position = position;
    user.email = email;
    user.urlProfilePicture = urlProfilePicture;
    user.phone = phone;
    user.ID = ID;
    user.businessUnit = businessUnit;
    user.region = region;
    user.authKey = authKey;
    user.rol = rol;
    user.helpUrl = helpUrl;
    user.privacyUrl = privacyUrl;
    user.termsUrl = termsUrl;
    user.notificationsEmail = notificationsEmail;
    
    return user;
}

#pragma mark - NSCoding Protocols
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.position forKey:@"position"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.urlProfilePicture forKey:@"urlProfilePicture"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:@(self.ID) forKey:@"id"];
    [aCoder encodeObject:self.businessUnit forKey:@"businessUnit"];
    [aCoder encodeObject:self.authKey forKey:@"authKey"];
    [aCoder encodeObject:self.region forKey:@"region"];
    [aCoder encodeObject:self.rol forKey:@"rol"];
    [aCoder encodeObject:self.helpUrl forKey:@"helpUrl"];
    [aCoder encodeObject:self.privacyUrl forKey:@"privacyUrl"];
    [aCoder encodeObject:self.termsUrl forKey:@"termsUrl"];
    [aCoder encodeObject:@(self.notificationsEmail) forKey:@"notificationsEmail"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.position = [aDecoder decodeObjectForKey:@"position"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.urlProfilePicture = [aDecoder decodeObjectForKey:@"urlProfilePicture"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.ID = [[aDecoder decodeObjectForKey:@"id"] intValue];
        self.businessUnit = [aDecoder decodeObjectForKey:@"businessUnit"];
        self.authKey = [aDecoder decodeObjectForKey:@"authKey"];
        self.region = [aDecoder decodeObjectForKey:@"region"];
        self.rol = [aDecoder decodeObjectForKey:@"rol"];
        self.helpUrl = [aDecoder decodeObjectForKey:@"helpUrl"];
        self.privacyUrl = [aDecoder decodeObjectForKey:@"privacyUrl"];
        self.termsUrl = [aDecoder decodeObjectForKey:@"termsUrl"];
        self.notificationsEmail = [[aDecoder decodeObjectForKey:@"notificationsEmail"] boolValue];
    }
    
    return self;
}

+ (void)userWithJSONDictionary:(NSDictionary *)dictionary
{
    [CPUser sharedUser].name               = [dictionary[@"name"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"name"];
    [CPUser sharedUser].position           = [dictionary[@"puesto"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"puesto"];
    [CPUser sharedUser].email              = [dictionary[@"email"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"email"];
    [CPUser sharedUser].urlProfilePicture  = [dictionary[@"image"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"image"];
    [CPUser sharedUser].phone              = [dictionary[@"phone"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"phone"];
    [CPUser sharedUser].ID                 = [dictionary[@"no_empleado_a"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"no_empleado_a"] intValue];
    [CPUser sharedUser].businessUnit       = [dictionary[@"unidad_negocio_a"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"unidad_negocio_a"];
    [CPUser sharedUser].region             = [dictionary[@"region"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"region"];
    [CPUser sharedUser].authKey            = [dictionary[@"auth_key"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"auth_key"];
    [CPUser sharedUser].rol                = [dictionary[@"rol"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"rol"];
    [CPUser sharedUser].helpUrl            = [dictionary[@"help_url"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"help_url"];
    [CPUser sharedUser].privacyUrl         = [dictionary[@"privacy_url"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"privacy_url"];
    [CPUser sharedUser].termsUrl           = [dictionary[@"terms_url"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"terms_url"];
    [CPUser sharedUser].notificationsEmail = [dictionary[@"notifications_by_mail"] isKindOfClass:[NSNull class]] ? NO : [dictionary[@"notifications_by_mail"] boolValue];
}

+ (void)loginAndCreateCPUserWithUsername:(NSString *)username
                             andPassword:(NSString *)password
                       completionHandler:(void(^)(BOOL success, long response))completionHandler
{
    NSURL *URL = [NSURL URLWithString:@"http://api.contiplus.net/users/auth"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"user\": \"%@\", \"password\": \"%@\"}", username, password] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      BOOL success;
                                      if ((long)[(NSHTTPURLResponse *)response statusCode] == 200 && !error) {
                                          success = YES;
                                          NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:0
                                                                                                       error:nil];
                                          [CPUser userWithJSONDictionary:dictionary];
                                          NSData *encodeUser = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeUser forKey:@"cpUser"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                      } else success = NO;
                                      completionHandler(success, (long)[(NSHTTPURLResponse *)response statusCode]);
                                  }];
    [task resume];
}

@end
