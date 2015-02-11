//
//  CPUser.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/10/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPUser : NSObject<NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *position;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *urlProfilePicture;
@property (strong, nonatomic) NSString *phone;
@property (nonatomic) int ID;
@property (strong, nonatomic) NSString *businessUnit;
@property (strong, nonatomic) NSString *region;
@property (strong, nonatomic) NSString *authKey;
@property (strong, nonatomic) NSString *rol;
@property (strong, nonatomic) NSString *helpUrl;
@property (strong, nonatomic) NSString *privacyUrl;
@property (strong, nonatomic) NSString *termsUrl;
@property (nonatomic) BOOL notificationsEmail;

+ (CPUser *)sharedUser;

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
          notificationsEmail:(BOOL)notificationsEmail;

+ (void)userWithJSONDictionary:(NSDictionary *)dictionary;

+ (void)loginAndCreateCPUserWithUsername:(NSString *)username
                             andPassword:(NSString *)password
                       completionHandler:(void(^)(BOOL success, long response))completionHandler;
@end
