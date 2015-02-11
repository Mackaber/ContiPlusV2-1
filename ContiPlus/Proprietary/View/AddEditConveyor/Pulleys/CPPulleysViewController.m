//
//  CPPulleysViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/3/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPPulleysViewController.h"
#import "CPLanguajeUtils.h"
#import "BSKeyboardControls.h"
#import "CPContactArcArray.h"

static NSString *CPDismissAddEditViewControllerNotification = @"CPDismissAddEditViewControllerNotification";
static NSString *CPSaveInfoInAddEditViewControllerNotification = @"CPSaveInfoInAddEditViewControllerNotification";

@interface CPPulleysViewController ()
<UITextFieldDelegate, BSKeyboardControlsDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *drivePulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *widthDrivePulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *coveringLB;
@property (weak, nonatomic) IBOutlet UILabel *contacArcLB;
@property (weak, nonatomic) IBOutlet UILabel *headPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *widthHeadPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *tailPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *widthTailPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *contactPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *widthContactPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *bendingPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *widthBendingPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *tensorPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *widthTensorPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *additionalPulley1LB;
@property (weak, nonatomic) IBOutlet UILabel *widthAdditionalPulley1LB;
@property (weak, nonatomic) IBOutlet UILabel *additionalPulley2LB;
@property (weak, nonatomic) IBOutlet UILabel *widthAdditionalPulley2LB;
@property (weak, nonatomic) IBOutlet UILabel *numerationLb;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerPickerHeightCNST;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *doneBT;

@property (strong, nonatomic) NSArray *pickerElements;
@property (weak, nonatomic) UITextField *activeTextField;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@property (strong, nonatomic) NSString *contactArcString;

@end

@implementation CPPulleysViewController

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
    
    self.pickerView.hidden = YES;
    self.containerPickerHeightCNST.constant = 0;
    self.pickerElements = [CPContactArcArray contactArcArray];
    
    NSArray *fields = @[self.drivePulleyTF, self.widthDrivePulleyTF, self.coveringTF, self.headPulleyTF, self.widthHeadPulleyTF, self.tailPulleyTF, self.widthTailPulleyTF, self.contactPulleyTF, self.widthContactPulleyTF, self.bendingPulleyTF, self.widthBendingPulleyTF, self.tensorPulleyTF, self.widthTensorPulleyTF, self.additionalPulley1TF, self.widthAdditionalPulley1TF, self.additionalPulley2TF, self.widthAdditionalPulley2TF];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

- (void)setUpView
{
    self.titleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Poleas"];
    self.drivePulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea motriz - Ø (Plg)"];
    self.widthDrivePulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.coveringLB.text = [CPLanguajeUtils languajeSelectedForString:@"Recubrimiento (Plg)"];
    self.contacArcLB.text = [CPLanguajeUtils languajeSelectedForString:@"Arco de contacto (°)"];
    self.headPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea de cabeza - Ø (Plg)"];
    self.widthHeadPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.tailPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea de cola - Ø (Plg)"];
    self.widthTailPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.contactPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea de contacto - Ø (Plg)"];
    self.widthContactPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.bendingPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea de doblez - Ø (Plg)"];
    self.widthBendingPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.tensorPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea tensora - Ø (Plg)"];
    self.widthTensorPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.additionalPulley1LB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea adicional1- Ø (Plg)"];
    self.widthAdditionalPulley1LB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.additionalPulley2LB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea adicional2- Ø (Plg)"];
    self.widthAdditionalPulley2LB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    [self.doneBT setTitle:[CPLanguajeUtils languajeSelectedForString:@"Hecho"]
                 forState:UIControlStateNormal];
    
    self.numerationLb.text = [CPLanguajeUtils languajeSelectedForString:@"6 de 8"];
}

#pragma mark - UIStatusBar White Color
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITextfield Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view layoutIfNeeded];
    self.pickerView.hidden = YES;
    self.containerPickerHeightCNST.constant = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
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

#pragma mark - UIPickerView Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerElements.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSDictionary *dict = self.pickerElements[row];
    return [dict objectForKey:@"Value"];
}

#pragma mark - UIPickerView Delegate Methods

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    NSDictionary *dict = self.pickerElements[row];
    self.contactArcString = [dict objectForKey:@"Value"];
    self.contactArcPulleyID = dict[@"id"];
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

- (IBAction)openPicker
{
    [self.activeTextField resignFirstResponder];
    [self.view layoutIfNeeded];
    self.pickerView.hidden = NO;
    self.containerPickerHeightCNST.constant = 207;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (IBAction)closePicker
{
    [self.view layoutIfNeeded];
    self.pickerView.hidden = YES;
    self.containerPickerHeightCNST.constant = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
    self.contactArcDescLB.text = self.contactArcString;
}

@end
