//
//  CPFileUtils.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/18/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPFileUtils.h"

@implementation CPFileUtils

+ (void)createUserFolder
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserFolder"];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error]) {
            NSLog(@"Create directory error: %@", error);
        }
    }
}

+ (void)saveDataToUserForder:(NSData *)data
                    withName:(NSString *)name
                    dataType:(CPFileType)fileType
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserFolder"];
    NSString *extension = (fileType == CPImageFile) ? @"jpg" : @"mp4";
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", name, extension]];
    [[NSFileManager defaultManager] createFileAtPath:path
                                            contents:data
                                          attributes:nil];
}

+ (NSData *)dataFromUserFolderWithName:(NSString *)name
                                  dataType:(CPFileType)fileType
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserFolder"];
    NSString *extension = (fileType == CPImageFile) ? @"jpg" : @"mp4";
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", name, extension]];
    NSData *data;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        data = [NSData dataWithContentsOfFile:path];
    }
    
    return data;
}

+ (NSString *)stringPathForVideoWithName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"UserFolder"];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", name]];
    
    return path;
}

+ (void)renameDataFileName:(NSString *)oldName
                withNewName:(NSString *)newName
                dataType:(CPFileType)fileType
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *extension = (fileType == CPImageFile) ? @"jpg" : @"mp4";
    
    NSString *oldPath;
    oldPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserFolder"];
    oldPath = [oldPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", oldName, extension]];
    
    NSString *newPath;
    newPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserFolder"];
    newPath = [newPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", newName, extension]];
    
    [[NSFileManager defaultManager] moveItemAtPath:oldPath
                                            toPath:newName
                                             error:nil];
}

+ (void)deleteDataFileName:(NSString *)name
                  dataType:(CPFileType)fileType
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserFolder"];
    NSString *extension = (fileType == CPImageFile) ? @"jpg" : @"mp4";
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", name, extension]];
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error]) {
            NSLog(@"Delete file error: %@", error);
        }
    }
}

+ (void)deleteAllObjectsFromUserFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserFolder"];
    NSError *error;
    NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    
    for (NSString *path2 in directoryContents) {
        NSString *fullPath = [path stringByAppendingPathComponent:path2];
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
    }
}

@end
