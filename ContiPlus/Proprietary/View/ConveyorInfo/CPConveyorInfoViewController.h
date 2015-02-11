//
//  CPConveyorInfoViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/4/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPConveyor;

@interface CPConveyorInfoViewController : UIViewController

@property (strong, nonatomic) CPConveyor *conveyor;
@property (strong, nonatomic) NSString *clientName;
@property (nonatomic) int clientID;

@end
