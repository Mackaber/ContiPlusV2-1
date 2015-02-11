//
//  CPLoginViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/22/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPLoginViewController.h"
#import "CPLanguajeUtils.h"
#import "CPMessageUtils.h"
#import "DejalActivityView.h"
#import "BSKeyboardControls.h"
#import "CPUser.h"
#import "CPWebViewController.h"
#import <CommonCrypto/CommonCrypto.h>

#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

@interface CPLoginViewController ()
<UITextFieldDelegate, BSKeyboardControlsDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *logInBT;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordBT;
@property (weak, nonatomic) IBOutlet UILabel *signUpMessageLB;
@property (weak, nonatomic) IBOutlet UIButton *termsOfServiceBT;
@property (weak, nonatomic) IBOutlet UIButton *privacyPolicyBT;
@property (weak, nonatomic) IBOutlet UILabel *allRightsReservedLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceBetweenLogoAndSuperViewCSTR;
@property (nonatomic) CGFloat tempValueCSTR;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (strong, nonatomic) NSString *url;
@end

@implementation CPLoginViewController

#pragma mark - UIViewController Lifecycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    [self setNeedsStatusBarAppearanceUpdate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    NSArray *fields = @[self.usernameTF, self.passwordTF];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)setUpView
{
    self.usernameTF.text = @"";
    self.passwordTF.text = @"";
    // TextField PlaceHolder
    self.usernameTF.attributedPlaceholder = [[NSAttributedString alloc]
                                                initWithString:[CPLanguajeUtils languajeSelectedForString:@"Usuario"]
                                                    attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.passwordTF.attributedPlaceholder = [[NSAttributedString alloc]
                                                initWithString:[CPLanguajeUtils languajeSelectedForString:@"Contraseña"]
                                                    attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    // Buttons
    [self.logInBT.layer setBorderWidth:1.5f];
    [self.logInBT.layer setBorderColor:[UIColor colorWithRed:255.0/255.0
                                                       green:165.0/255.0
                                                        blue:0.0
                                                       alpha:1.0].CGColor];
    [self.logInBT.layer setCornerRadius:5.0f];
    [self.logInBT setTitle:[CPLanguajeUtils languajeSelectedForString:@"Entrar"]
                  forState:UIControlStateNormal];
    
    NSMutableAttributedString *titleBT = [[NSMutableAttributedString alloc]
                                    initWithString:[CPLanguajeUtils languajeSelectedForString:@"¿Olvidaste la contraseña?"]];
    [titleBT addAttribute:NSUnderlineStyleAttributeName
                    value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                    range:NSMakeRange(0, titleBT.length)];
    [titleBT addAttribute:NSForegroundColorAttributeName
                    value:[UIColor whiteColor]
                    range:NSMakeRange(0, titleBT.length)];
    
    [self.forgotPasswordBT setAttributedTitle:titleBT
                                     forState:UIControlStateNormal];
    
    self.signUpMessageLB.text = [CPLanguajeUtils languajeSelectedForString:@"Al iniciar la sesión, estás de acuerdo con los"];
    
    // Button bottom part
    titleBT = [[NSMutableAttributedString alloc] initWithString:[CPLanguajeUtils languajeSelectedForString:@"Términos de Servicio"]];
    [titleBT addAttribute:NSUnderlineStyleAttributeName
                    value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                    range:NSMakeRange(0, titleBT.length)];
    [titleBT addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithRed:1.0
                                          green:165.0/255.0
                                           blue:0.0
                                          alpha:1.0]
                    range:NSMakeRange(0, titleBT.length)];
    [self.termsOfServiceBT setAttributedTitle:titleBT
                                     forState:UIControlStateNormal];
    self.termsOfServiceBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    titleBT = [[NSMutableAttributedString alloc] initWithString:[CPLanguajeUtils languajeSelectedForString:@"Política de Privacidad"]];
    [titleBT addAttribute:NSUnderlineStyleAttributeName
                    value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                    range:NSMakeRange(0, titleBT.length)];
    [titleBT addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithRed:1.0
                                          green:165.0/255.0
                                           blue:0.0
                                          alpha:1.0]
                    range:NSMakeRange(0, titleBT.length)];
    [self.privacyPolicyBT setAttributedTitle:titleBT
                                    forState:UIControlStateNormal];
    self.privacyPolicyBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.allRightsReservedLB.text = [CPLanguajeUtils languajeSelectedForString:@"© 2015 ContiTech Mexicana, ALL RIGHTS RESERVED"];
    self.tempValueCSTR = self.verticalSpaceBetweenLogoAndSuperViewCSTR.constant;
}

#pragma mark - UIStatusBar White Color
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - NSNotification Keyboard Methods
- (void)keyboardWillShow:(NSNotification *)notification
{
    [self.view layoutIfNeeded];
    self.verticalSpaceBetweenLogoAndSuperViewCSTR.constant = -100;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.view layoutIfNeeded];
    self.verticalSpaceBetweenLogoAndSuperViewCSTR.constant = self.tempValueCSTR;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self login];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
}

#pragma mark - BSKeyboardControls Delegate Methods
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
}

#pragma mark - Hash Sha1 Method
- (NSString*)sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr
                                  length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

#pragma mark - IBAction Methods
- (IBAction)logInAction
{
    [self login];
}

- (IBAction)forgotPassword
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"¿Olvidaste la contraseña?"]
                                                                   message:[CPLanguajeUtils languajeSelectedForString:@"Si tienes problemas para entrar a tu cuenta, por favor repórtalo a login@contiplus.net"]
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

- (IBAction)goToWebView:(UIButton *)sender
{
    if (sender.tag == 100) self.url = @"http://www.contiplus.net/General/Terms";
    else if (sender.tag == 200) self.url = @"http://www.contiplus.net/General/Privacy";
    [self performSegueWithIdentifier:@"WebSegue"
                              sender:self];
}

#pragma mark - Login Method
- (void)login
{
    [self.usernameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    if ([self.usernameTF.text isEqualToString:@""])
        [CPMessageUtils showAlertViewWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Campo Incompleto"]
                                    andMessage:[CPLanguajeUtils languajeSelectedForString:@"Favor de ingresar tus datos correctamente"]];
    else if ([self.passwordTF.text isEqualToString:@""])
        [CPMessageUtils showAlertViewWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Campo Incompleto"]
                                    andMessage:[CPLanguajeUtils languajeSelectedForString:@"Favor de ingresar tus datos correctamente"]];
    else {
        [DejalBezelActivityView activityViewForView:self.view
                                          withLabel:[CPLanguajeUtils languajeSelectedForString:@"Validando Usuario..."]];
        [CPUser loginAndCreateCPUserWithUsername:self.usernameTF.text
                                     andPassword:[self sha1:self.passwordTF.text]
                               completionHandler:^(BOOL success, long response) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [DejalBezelActivityView removeViewAnimated:YES];
                                       if (success) {
                                           [self performSegueWithIdentifier:@"logInSuccessfull"
                                                                     sender:self];
                                       } else {
                                           if (response == 403)
                                               [CPMessageUtils showAlertViewWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Datos Incorrectos"]
                                                                           andMessage:[CPLanguajeUtils languajeSelectedForString:@"Usuario y/o Contraseña son incorrectos"]];
                                           else
                                               [CPMessageUtils showAlertViewWithTitle:[CPLanguajeUtils languajeSelectedForString:@"ERROR"]
                                                                           andMessage:[CPLanguajeUtils languajeSelectedForString:@"Favor de verificar tu conexión a internet o intentar más tarde"]];
                                       }
                                   });
                               }];
    }
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"WebSegue"]) {
        CPWebViewController *webViewController = segue.destinationViewController;
        webViewController.url = self.url;
    }
}

@end
