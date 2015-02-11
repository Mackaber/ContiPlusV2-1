//
//  CPMedia.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/5/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPObject : NSObject

@property (nonatomic) int ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *descriptionStr;
@property (nonatomic) int conveyorID;
@property (nonatomic) int bucketID;
@property (nonatomic) int createdAt;
@property (nonatomic) int updatedAt;

@end
