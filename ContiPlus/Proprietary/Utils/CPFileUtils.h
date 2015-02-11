//
//  CPFileUtils.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/18/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CPEnum.h"

@interface CPFileUtils : NSObject

+ (void)createUserFolder;

+ (void)saveDataToUserForder:(NSData *)data
                    withName:(NSString *)name
                    dataType:(CPFileType)fileType;

+ (NSData *)dataFromUserFolderWithName:(NSString *)name
                                  dataType:(CPFileType)fileType;

+ (void)renameDataFileName:(NSString *)oldName
               withNewName:(NSString *)newName
                  dataType:(CPFileType)fileType;

+ (void)deleteDataFileName:(NSString *)name
                  dataType:(CPFileType)fileType;

+ (void)deleteAllObjectsFromUserFolder;

+ (NSString *)stringPathForVideoWithName:(NSString *)name;
@end
