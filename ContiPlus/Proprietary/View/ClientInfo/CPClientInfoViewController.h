//
//  CPClientInfoViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/23/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPClient;

@interface CPClientInfoViewController : UIViewController

@property (strong, nonatomic) CPClient *client;
@property (strong, nonatomic) NSMutableArray *allConveyorsArray;

@end
