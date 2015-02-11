//
//  CPQuoteRequestViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/10/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPQuoteRequestViewController.h"
#import "CPLanguajeUtils.h"
#import "MRProgress.h"
#import "CPUser.h"
#import "CPConveyor.h"

@interface CPQuoteRequestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *recomendedBandPIWLB;
@property (weak, nonatomic) IBOutlet UILabel *recomendedBandPIWDescLB;
@property (weak, nonatomic) IBOutlet UILabel *recomendedBandNmmLB;
@property (weak, nonatomic) IBOutlet UILabel *recomendedBandNmmDescLB;
@property (weak, nonatomic) IBOutlet UIButton *quoteRequestBT;
@property (weak, nonatomic) IBOutlet UILabel *noticeLB;

@end

@implementation CPQuoteRequestViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void)setUpView
{
    self.navigationController.navigationBar.hidden = YES;
    self.recomendedBandPIWLB.text = [CPLanguajeUtils languajeSelectedForString:@"Banda recomendada en PIW"];
    self.recomendedBandNmmLB.text = [CPLanguajeUtils languajeSelectedForString:@"Banda recomendada en N/mm"];
    
    self.recomendedBandPIWDescLB.text = self.recommendedConveyorIn;
    self.recomendedBandNmmDescLB.text = self.recommendedConveyorMm;
    
    [self.quoteRequestBT.layer setBorderWidth:1.5f];
    [self.quoteRequestBT.layer setBorderColor:[UIColor colorWithRed:1.0
                                                                 green:45.0/255.0
                                                                  blue:55.0/255.0
                                                                 alpha:1.0].CGColor];
    [self.quoteRequestBT.layer setCornerRadius:5.0f];
    [self.quoteRequestBT setTitle:[CPLanguajeUtils languajeSelectedForString:@"Solicitar cotización"]
                            forState:UIControlStateNormal];
    
    self.noticeLB.text = [CPLanguajeUtils languajeSelectedForString:@"Disclaimer"];
}

#pragma mark - IBAction Methods
- (IBAction)returnToPrController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)quoteRequest
{
    [MRProgressOverlayView showOverlayAddedTo:self.view
                                        title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                         mode:MRProgressOverlayViewModeIndeterminate
                                     animated:YES];
    [CPConveyor requestConveyorQuoteWithAuthenticationKey:[CPUser sharedUser].authKey
                                                       ID:self.conveyorID
                                        completionHandler:^(BOOL success) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                              [MRProgressOverlayView dismissOverlayForView:self.view
                                                                                  animated:YES];
                                               if (success) {
                                                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Tu solicitud fue enviada con exito"]
                                                                                                                  message:nil
                                                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                                   UIAlertAction *ok = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Ok"]
                                                                                                style:UIAlertActionStyleDefault
                                                                                              handler:^(UIAlertAction *action) {
                                                                                                  [alert dismissViewControllerAnimated:YES
                                                                                                                            completion:nil];
                                                                                              }];
                                                   [alert addAction:ok];
                                                   [self presentViewController:alert
                                                                      animated:YES
                                                                    completion:nil];
                                               } else {
                                                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al enviar la solicitud"]
                                                                                                                  message:[CPLanguajeUtils languajeSelectedForString:@"Favor de verificar tu conexión a internet o intentar más tarde"]
                                                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                                   UIAlertAction *ok = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Ok"]
                                                                                                style:UIAlertActionStyleDefault
                                                                                              handler:^(UIAlertAction *action) {
                                                                                                  [alert dismissViewControllerAnimated:YES
                                                                                                                            completion:nil];
                                                                                              }];
                                                   [alert addAction:ok];
                                                   [self presentViewController:alert
                                                                      animated:YES
                                                                    completion:nil];
                                               }
                                           });
                                        }];
}

@end
