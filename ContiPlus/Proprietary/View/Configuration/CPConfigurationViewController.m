//
//  CPConfigurationViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/13/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPConfigurationViewController.h"
#import "CPLanguajeUtils.h"
#import "CPUser.h"
#import "CPWebViewSettingsViewController.h"
#import "CPUser.h"
#import "MRProgress.h"
#import "CPNotification.h"

@interface CPConfigurationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailNotificationsLB;
@property (weak, nonatomic) IBOutlet UILabel *languajeLB;
@property (weak, nonatomic) IBOutlet UILabel *languajeSelectionLB;
@property (weak, nonatomic) IBOutlet UILabel *contiplusLB;
@property (weak, nonatomic) IBOutlet UILabel *termsOfUseLB;
@property (weak, nonatomic) IBOutlet UILabel *privacyLB;
@property (strong, nonatomic) NSString *url;
@property (weak, nonatomic) IBOutlet UISwitch *emailNotificationsSwitch;

@end

@implementation CPConfigurationViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpView];
}

- (void)setUpView
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0
                                                                           green:165.0/255.0
                                                                            blue:0.0
                                                                           alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = [CPLanguajeUtils languajeSelectedForString:@"Configuración"];
    self.emailNotificationsLB.text = [CPLanguajeUtils languajeSelectedForString:@"Notificaciones vía email"];
    self.languajeLB.text = [CPLanguajeUtils languajeSelectedForString:@"Idioma"];
    self.languajeSelectionLB.text = [CPLanguajeUtils languajeSelectedForString:@"IdiomaDesc"];
    self.contiplusLB.text = [CPLanguajeUtils languajeSelectedForString:@"ContiPlus v2.0"];
    self.termsOfUseLB.text = [CPLanguajeUtils languajeSelectedForString:@"Terminos de Uso"];
    self.privacyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Privacidad"];
    [self.emailNotificationsSwitch setOn:[CPUser sharedUser].notificationsEmail];
}

#pragma mark - IBAction Methods
- (IBAction)gotoWebViewSettings:(UIButton *)sender
{
    if (sender.tag == 100) self.url = [CPUser sharedUser].termsUrl;
    else if (sender.tag == 200) self.url = [CPUser sharedUser].privacyUrl;
    [self performSegueWithIdentifier:@"WebViewSettingSegue"
                              sender:self];
}

- (IBAction)changeEmailNotification:(UISwitch *)sender
{
    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                        title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                         mode:MRProgressOverlayViewModeIndeterminate
                                     animated:YES];
    [CPNotification changeNotificationEmail:[CPUser sharedUser].authKey
                          completionHandler:^(BOOL success) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                     animated:YES];
                                 if (success) {
                                     NSMutableDictionary *userDict = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"cpUser"]] mutableCopy];
                                     [CPUser sharedUser].notificationsEmail = ![CPUser sharedUser].notificationsEmail;
                                     userDict[@"notifications_by_mail"] = @([CPUser sharedUser].notificationsEmail);
                                     NSData *encodeUser = [NSKeyedArchiver archivedDataWithRootObject:userDict];
                                     [[NSUserDefaults standardUserDefaults] setObject:encodeUser forKey:@"cpUser"];
                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                     [self.emailNotificationsSwitch setOn:[CPUser sharedUser].notificationsEmail
                                                                 animated:YES];
                                 } else {
                                     [self.emailNotificationsSwitch setOn:[CPUser sharedUser].notificationsEmail];
                                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al cambiar las notificaiones vía email"]
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

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"WebViewSettingSegue"]) {
        CPWebViewSettingsViewController *webViewSettingsViewController = segue.destinationViewController;
        webViewSettingsViewController.url = self.url;
    }
}

@end
