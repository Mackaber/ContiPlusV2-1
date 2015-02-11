//
//  CPFolderViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/9/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPBucket;

@interface CPFolderViewController : UIViewController

@property (strong, nonatomic) CPBucket *bucket;
@property (strong, nonatomic) NSString *serialNumber;

@end
