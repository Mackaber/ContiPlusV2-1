//
//  CPMaterialViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/2/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPMaterialViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *descriptionDescLB;
@property (weak, nonatomic) IBOutlet UILabel *densityDescLB;
@property (strong, nonatomic) NSString  *matDescriptionID;
@property (weak, nonatomic) IBOutlet UITextField *maxSizeTerronTF;
@property (weak, nonatomic) IBOutlet UITextField *temperatureTF;
@property (weak, nonatomic) IBOutlet UITextField *heightOfFallTF;
@property (weak, nonatomic) IBOutlet UITextField *finesTF;
@property (weak, nonatomic) IBOutlet UILabel *loadingConditionsDescLB;
@property (strong, nonatomic) NSString *matLoadingConditionsID;
@property (weak, nonatomic) IBOutlet UILabel *loadingFrecuencyDescLB;
@property (strong, nonatomic) NSString *matLoadingFrecuencyID;
@property (weak, nonatomic) IBOutlet UILabel *granularSizeDescLB;
@property (strong, nonatomic) NSString *matGranularSizeID;
@property (weak, nonatomic) IBOutlet UILabel *densityNewDescLB;
@property (strong, nonatomic) NSString *matDensityNewID;
@property (weak, nonatomic) IBOutlet UILabel *aggresivityDescLB;
@property (strong, nonatomic) NSString *matAggresivityID;
@property (weak, nonatomic) IBOutlet UILabel *materialConveyedDescLB;
@property (strong, nonatomic) NSString *matMaterialConveyedID;
@property (weak, nonatomic) IBOutlet UILabel *feedingConditionsDescLB;
@property (strong, nonatomic) NSString *matFeedingConditionsID;

@end
