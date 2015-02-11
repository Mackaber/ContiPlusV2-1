//
//  CPTensorTypeViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/29/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPTensorTypeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *estimatedWeightTF;
@property (weak, nonatomic) IBOutlet UITextField *careerTF;
@property (weak, nonatomic) IBOutlet UILabel *tensorTypeDescLB;
@property (strong, nonatomic) NSString  *tensorTypeID;
@end
