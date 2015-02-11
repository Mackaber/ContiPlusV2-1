//
//  CPAddEditConveyorViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/29/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDScrollViewController.h"
#import "CPConveyor.h"

@interface CPAddEditConveyorViewController : DDScrollViewController

@property (strong, nonatomic) CPConveyor *conveyor;
@property (nonatomic) BOOL isEditable;
@property (nonatomic) BOOL isCache;
@property (nonatomic) int clientID;


@end
