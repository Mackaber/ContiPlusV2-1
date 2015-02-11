//
//  CPAddVideoViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/10/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPVideo;

@interface CPAddVideoViewController : UIViewController

@property (strong, nonatomic) CPVideo *video;
@property (nonatomic) BOOL isEditable;
@property (nonatomic) BOOL isCache;
@property (nonatomic) int conveyorID;
@property (nonatomic) int bucketID;
@property (nonatomic) BOOL isCacheConveyor;
@property (nonatomic) BOOL isEditableConveyorChache;

@end
