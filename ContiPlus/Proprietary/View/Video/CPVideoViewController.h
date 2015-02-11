//
//  CPVideoViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/9/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPVideo;

@interface CPVideoViewController : UIViewController

@property (strong, nonatomic) CPVideo *cpVideo;
@property (strong, nonatomic) NSString *serialNumber;
@property (nonatomic) BOOL isConveyorCache;

@end
