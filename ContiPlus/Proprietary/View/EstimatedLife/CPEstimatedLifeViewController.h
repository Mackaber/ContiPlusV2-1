//
//  CPEstimatedLifeViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/10/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPEstimatedLifeViewController : UIViewController

@property (nonatomic) int conveyorID;
@property (strong, nonatomic) NSString *estimatedLife;
@property (strong, nonatomic) NSString *tonnage;
@property (strong, nonatomic) NSNumber *aproxChangeDate;
@property (strong, nonatomic) NSString *recommendedConveyorIn;
@property (strong, nonatomic) NSString *recommendedConveyorMm;

@end
