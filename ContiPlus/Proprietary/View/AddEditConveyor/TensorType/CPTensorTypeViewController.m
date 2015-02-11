//
//  CPTensorTypeViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/29/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPTensorTypeViewController.h"
#import "CPLanguajeUtils.h"
#import "BSKeyboardControls.h"
#import "CPTensorTypeArray.h"

static NSString *CPDismissAddEditViewControllerNotification = @"CPDismissAddEditViewControllerNotification";
static NSString *CPSaveInfoInAddEditViewControllerNotification = @"CPSaveInfoInAddEditViewControllerNotification";

@interface CPTensorTypeViewController ()
<UITextFieldDelegate, BSKeyboardControlsDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *tensorTypeLB;
@property (weak, nonatomic) IBOutlet UILabel *estimatedWeigthLB;
@property (weak, nonatomic) IBOutlet UILabel *careerLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerPickerHeightCNST;
@property (weak, nonatomic) IBOutlet UIButton *doneBT;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) UITextField *activeTextField;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UILabel *numerationLb;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSArray *pickerElements;
@property (strong, nonatomic) NSString *pickerSelection;

@end

@implementation CPTensorTypeViewController

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
    NSArray *fields = @[self.estimatedWeightTF, self.careerTF];
    self.pickerElements = [CPTensorTypeArray tensorTypeArray];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

- (void)setUpView
{
    self.titleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Tipo de Tensor"];
    self.tensorTypeLB.text = [CPLanguajeUtils languajeSelectedForString:@"Tipo de Tensor"];
    self.estimatedWeigthLB.text = [CPLanguajeUtils languajeSelectedForString:@"Peso estimado (lbs)"];
    self.careerLB.text = [CPLanguajeUtils languajeSelectedForString:@"Carrera (m)"];
    [self.doneBT setTitle:[CPLanguajeUtils languajeSelectedForString:@"Hecho"]
                 forState:UIControlStateNormal];
    
    self.numerationLb.text = [CPLanguajeUtils languajeSelectedForString:@"3 de 8"];
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
    return [dict objectForKey:@"Name"];
}

#pragma mark - UIPickerView Delegate Methods

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    NSDictionary *dict = self.pickerElements[row];
    self.pickerSelection = [dict objectForKey:@"Name"];
    self.tensorTypeID = dict[@"id"];
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

- (IBAction)closePickerAndSelectTensorType
{
    [self.view layoutIfNeeded];
    self.pickerView.hidden = YES;
    self.containerPickerHeightCNST.constant = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
    self.tensorTypeDescLB.text = self.pickerSelection;
}


@end
