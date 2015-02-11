//
//  CPImageViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/8/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPImage.h"

@interface CPImageViewController : UIViewController

@property (strong, nonatomic) CPImage *cpImage;
@property (strong, nonatomic) NSString *serialNumber;
@property (nonatomic) int coverImgID;
@property (nonatomic) BOOL isConveyorCache;

@end
