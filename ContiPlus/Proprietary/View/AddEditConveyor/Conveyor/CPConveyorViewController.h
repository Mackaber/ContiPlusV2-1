//
//  CPConveyorViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/29/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPConveyorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *distanceTF;
@property (weak, nonatomic) IBOutlet UITextField *elevationTF;
@property (weak, nonatomic) IBOutlet UITextField *hpMotorTF;
@property (weak, nonatomic) IBOutlet UITextField *reductorRelationTF;
@property (weak, nonatomic) IBOutlet UITextField *rpmMotorTF;
@property (weak, nonatomic) IBOutlet UITextField *inclinationAngleTF;
@property (weak, nonatomic) IBOutlet UITextField *capacityTF;
@property (weak, nonatomic) IBOutlet UITextField *loadTF;
@end
