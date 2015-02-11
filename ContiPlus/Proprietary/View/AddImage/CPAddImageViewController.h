//
//  CPAddImageViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/9/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPImage;

@interface CPAddImageViewController : UIViewController

@property (strong, nonatomic) CPImage *image;
@property (nonatomic) BOOL isEditable;
@property (nonatomic) BOOL isCache;
@property (nonatomic) int conveyorID;
@property (nonatomic) int bucketID;
@property (nonatomic) BOOL isCacheConveyor;
@property (nonatomic) BOOL isEditableConveyorChache;

@end
