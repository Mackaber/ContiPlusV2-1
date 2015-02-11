//
//  CPConveyorViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/29/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPConveyorViewController.h"
#import "CPLanguajeUtils.h"
#import "BSKeyboardControls.h"

static NSString *CPDismissAddEditViewControllerNotification = @"CPDismissAddEditViewControllerNotification";
static NSString *CPSaveInfoInAddEditViewControllerNotification = @"CPSaveInfoInAddEditViewControllerNotification";

@interface CPConveyorViewController ()
<UITextFieldDelegate, BSKeyboardControlsDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *numerationLb;

@property (weak, nonatomic) IBOutlet UILabel *distanceLB;
@property (weak, nonatomic) IBOutlet UILabel *elevationLB;
@property (weak, nonatomic) IBOutlet UILabel *hpMotorLB;
@property (weak, nonatomic) IBOutlet UILabel *reductorRelationLB;
@property (weak, nonatomic) IBOutlet UILabel *rpmMotorLB;
@property (weak, nonatomic) IBOutlet UILabel *inclinationAngleLB;
@property (weak, nonatomic) IBOutlet UILabel *capacityLB;
@property (weak, nonatomic) IBOutlet UILabel *loadLB;
@property (weak, nonatomic) UITextField *activeTextField;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation CPConveyorViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self setUpView];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:rightConstraint];
    
    NSArray *fields = @[self.distanceTF, self.elevationTF, self.hpMotorTF, self.reductorRelationTF,
                        self.rpmMotorTF, self.inclinationAngleTF, self.capacityTF, self.loadTF];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

- (void)setUpView
{
    self.titleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Transportador"];
    self.distanceLB.text = [CPLanguajeUtils languajeSelectedForString:@"Distancia entre centros (m)"];
    self.elevationLB.text = [CPLanguajeUtils languajeSelectedForString:@"Elevación (m)"];
    self.hpMotorLB.text = [CPLanguajeUtils languajeSelectedForString:@"HP Motor"];
    self.reductorRelationLB.text = [CPLanguajeUtils languajeSelectedForString:@"Relación reductor"];
    self.rpmMotorLB.text = [CPLanguajeUtils languajeSelectedForString:@"RPM Motor"];
    self.inclinationAngleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ángulo de inclinación (°)"];
    self.capacityLB.text = [CPLanguajeUtils languajeSelectedForString:@"Capacidad (t/h)"];
    self.loadLB.text = [CPLanguajeUtils languajeSelectedForString:@"Carga (%)"];
    
    self.numerationLb.text = [CPLanguajeUtils languajeSelectedForString:@"2 de 8"];
}

#pragma mark - UIStatusBar White Color
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - IBAction Methods
- (IBAction)backTo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CPDismissAddEditViewControllerNotification
                                                        object:nil];
}

- (IBAction)save
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CPSaveInfoInAddEditViewControllerNotification
                                                        object:nil];
}

#pragma mark - UITextfield Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.activeTextField = textField;
    [self.keyboardControls setActiveField:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    self.activeTextField = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 8) ? NO : YES;
}

#pragma mark - BSKeyboardControls Delegate Methods
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
}

#pragma mark - NSNotification Keyboard Methods
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeTextField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
