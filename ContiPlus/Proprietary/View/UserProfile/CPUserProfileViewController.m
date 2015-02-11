//
//  CPUserProfileViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/10/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPUserProfileViewController.h"
#import "CPUser.h"
#import "CPLanguajeUtils.h"

@interface CPUserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *positionLB;
@property (weak, nonatomic) IBOutlet UILabel *emailLB;
@property (weak, nonatomic) IBOutlet UILabel *phoneLB;
@property (weak, nonatomic) IBOutlet UILabel *employeeIDLB;
@property (weak, nonatomic) IBOutlet UILabel *businessUnitLB;
@property (weak, nonatomic) IBOutlet UILabel *regionLB;

@end

@implementation CPUserProfileViewController

#pragma mark - UIViewController LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void)setUpView
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0
                                                                           green:165.0/255.0
                                                                            blue:0.0
                                                                           alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    if (self.isImageLoad) {
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.borderWidth = 2.0f;
        self.imageView.layer.borderColor = [UIColor colorWithRed:253.0/255.0
                                                               green:148.0/255.0
                                                                blue:9.0/255.0
                                                               alpha:1.0].CGColor;
        self.imageView.image = self.imageProfile;
    } else {
        self.imageView.image = [UIImage imageNamed:@"userImageLarge"];
    }
    self.nameLB.text = [CPUser sharedUser].name;
    self.positionLB.text = [CPUser sharedUser].position;
    self.emailLB.text = [CPUser sharedUser].email;
    self.phoneLB.text = [NSString stringWithFormat:@"%@ %@", [CPLanguajeUtils languajeSelectedForString:@"Tel."], [CPUser sharedUser].phone];
    self.employeeIDLB.text = [NSString stringWithFormat:@"%@ %i", [CPLanguajeUtils languajeSelectedForString:@"No. Empleado"], [CPUser sharedUser].ID];
    self.businessUnitLB.text = [CPUser sharedUser].businessUnit;
    self.regionLB.text = [NSString stringWithFormat:@"%@ %@", [CPLanguajeUtils languajeSelectedForString:@"Región"], [CPUser sharedUser].region];
}

- (IBAction)goToPrController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
