//
//  CPPulleysViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/3/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPPulleysViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *drivePulleyTF;
@property (weak, nonatomic) IBOutlet UITextField *widthDrivePulleyTF;
@property (weak, nonatomic) IBOutlet UITextField *coveringTF;
@property (weak, nonatomic) IBOutlet UILabel *contactArcDescLB;
@property (strong, nonatomic) NSString *contactArcPulleyID;
@property (weak, nonatomic) IBOutlet UITextField *headPulleyTF;
@property (weak, nonatomic) IBOutlet UITextField *widthHeadPulleyTF;
@property (weak, nonatomic) IBOutlet UITextField *tailPulleyTF;
@property (weak, nonatomic) IBOutlet UITextField *widthTailPulleyTF;
@property (weak, nonatomic) IBOutlet UITextField *contactPulleyTF;
@property (weak, nonatomic) IBOutlet UITextField *widthContactPulleyTF;
@property (weak, nonatomic) IBOutlet UITextField *bendingPulleyTF;
@property (weak, nonatomic) IBOutlet UITextField *widthBendingPulleyTF;
@property (weak, nonatomic) IBOutlet UITextField *tensorPulleyTF;
@property (weak, nonatomic) IBOutlet UITextField *widthTensorPulleyTF;
@property (weak, nonatomic) IBOutlet UITextField *additionalPulley1TF;
@property (weak, nonatomic) IBOutlet UITextField *widthAdditionalPulley1TF;
@property (weak, nonatomic) IBOutlet UITextField *additionalPulley2TF;
@property (weak, nonatomic) IBOutlet UITextField *widthAdditionalPulley2TF;

@end
