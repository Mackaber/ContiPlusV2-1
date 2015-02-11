//
//  CPIdlersViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/3/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPIdlersViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *impactLCTF;
@property (weak, nonatomic) IBOutlet UILabel *loadLCDescLB; // loadDiameter
@property (strong, nonatomic) NSString *loadDiameterID;
@property (weak, nonatomic) IBOutlet UILabel *returnLCDescLB; // ReturnDiameter
@property (strong, nonatomic) NSString *returnDiameterID;
@property (weak, nonatomic) IBOutlet UITextField *spaceLCTF;
@property (weak, nonatomic) IBOutlet UITextField *spaceLRTF;
@property (weak, nonatomic) IBOutlet UILabel *impactLRDescLB; // impactAngle
@property (strong, nonatomic) NSString *impactAngleID;
@property (weak, nonatomic) IBOutlet UILabel *loadLRDescLB; // loadAngle
@property (strong, nonatomic) NSString *loadAngleID;
@property (weak, nonatomic) IBOutlet UITextField *returnLRTF;
@property (weak, nonatomic) IBOutlet UILabel *partTroghingDescLB;

@end
