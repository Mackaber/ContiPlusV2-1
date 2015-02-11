//
//  CPActualBeltViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/3/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPActualBeltViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *widhtPlgTF;
@property (weak, nonatomic) IBOutlet UITextField *tensionTF;
@property (weak, nonatomic) IBOutlet UILabel *topCoverThicknessDescLB;
@property (strong, nonatomic) NSString *topCoverThicknessID;
@property (weak, nonatomic) IBOutlet UILabel *bottomCoverThicknessDescLB;
@property (strong, nonatomic) NSString *bottomCoverThicknessID;
@property (weak, nonatomic) IBOutlet UITextField *velocityTF;
@property (weak, nonatomic) IBOutlet UILabel *instalationDateDescLB;
@property (strong, nonatomic) NSDate *installationDate;
@property (weak, nonatomic) IBOutlet UITextField *brandTF;
@property (weak, nonatomic) IBOutlet UITextField *totalDevelopmentTF;
@property (weak, nonatomic) IBOutlet UITextField *operationHrsTF;

@end
