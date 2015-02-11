//
//  CPDataSheetViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/7/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPConveyor;

@interface CPDataSheetViewController : UIViewController

@property (strong, nonatomic) CPConveyor *conveyor;
@property (strong, nonatomic) NSString *clientName;

@end
