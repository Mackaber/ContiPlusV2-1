//
//  CPActualBeltViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/3/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPActualBeltViewController.h"
#import "CPLanguajeUtils.h"
#import "BSKeyboardControls.h"
#import "CPActualBeltArray.h"

static NSString *CPDismissAddEditViewControllerNotification = @"CPDismissAddEditViewControllerNotification";
static NSString *CPSaveInfoInAddEditViewControllerNotification = @"CPSaveInfoInAddEditViewControllerNotification";

static NSString *CPPickerViewWillShowBeltNotification = @"CPPickerViewWillShowBeltNotification";
static NSString *CPPickerViewWillHideBeltNotification = @"CPPickerViewWillHideBeltNotification";

@interface CPActualBeltViewController ()
<UITextFieldDelegate, BSKeyboardControlsDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *widthPglLB;
@property (weak, nonatomic) IBOutlet UILabel *tensionLB;
@property (weak, nonatomic) IBOutlet UILabel *topCoverThicknessLB;
@property (weak, nonatomic) IBOutlet UILabel *bottomCoverThicknessLB;
@property (weak, nonatomic) IBOutlet UILabel *velocityLB;
@property (weak, nonatomic) IBOutlet UILabel *instalationDateLB;
@property (weak, nonatomic) IBOutlet UILabel *brandLB;
@property (weak, nonatomic) IBOutlet UILabel *totalDevelopmentLB;
@property (weak, nonatomic) IBOutlet UILabel *operationHrsLB;
@property (weak, nonatomic) IBOutlet UILabel *numerationLb;

@property (weak, nonatomic) IBOutlet UIView *pickerContainerView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerPickerHeightCNST;
@property (weak, nonatomic) IBOutlet UIButton *doneBT;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewData;

@property (weak, nonatomic) UITextField *activeTextField;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (strong, nonatomic) NSString *pickerSelection;
@property (strong, nonatomic) NSArray *pickerElements;
@property (nonatomic) NSInteger tagButtonSelected;

@property (weak, nonatomic) UILabel *activeLabel;
@end

@implementation CPActualBeltViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self setUpView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pickerWillShowBelt)
                                                 name:CPPickerViewWillShowBeltNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pickerWillHideBelt)
                                                 name:CPPickerViewWillHideBeltNotification
                                               object:nil];
    
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
    self.pickerViewData.hidden = YES;
    self.containerPickerHeightCNST.constant = 0;
    
    NSArray *fields = @[self.widhtPlgTF, self.tensionTF, self.velocityTF, self.brandTF, self.totalDevelopmentTF, self.operationHrsTF];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CPPickerViewWillShowBeltNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CPPickerViewWillHideBeltNotification
                                                  object:nil];
}

- (void)setUpView
{
    self.titleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Banda Actual"];
    self.widthPglLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.tensionLB.text = [CPLanguajeUtils languajeSelectedForString:@"Tensión (TU) (PIW)"];
    self.topCoverThicknessLB.text = [CPLanguajeUtils languajeSelectedForString:@"Espesor cubierta superior"];
    self.bottomCoverThicknessLB.text = [CPLanguajeUtils languajeSelectedForString:@"Espesor cubierta inferior"];
    self.velocityLB.text = [CPLanguajeUtils languajeSelectedForString:@"Velocidad (ft/min)"];
    self.instalationDateLB.text = [CPLanguajeUtils languajeSelectedForString:@"Fecha de instalación"];
    self.brandLB.text = [CPLanguajeUtils languajeSelectedForString:@"Marca"];
    self.totalDevelopmentLB.text = [CPLanguajeUtils languajeSelectedForString:@"Desarrollo total (m)"];
    self.operationHrsLB.text = [CPLanguajeUtils languajeSelectedForString:@"Operación hrs. por año"];
    [self.doneBT setTitle:[CPLanguajeUtils languajeSelectedForString:@"Hecho"]
                 forState:UIControlStateNormal];
    
    self.numerationLb.text = [CPLanguajeUtils languajeSelectedForString:@"5 de 8"];
}

#pragma mark - UIStatusBar White Color
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITextfield Delegate Methods
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
    
    if (textField == self.operationHrsTF) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 10) ? NO : YES;
    } else {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 8) ? NO : YES;
    }
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
    self.pickerSelection = [dict objectForKey:@"Value"];
    switch (self.tagButtonSelected) {
        case 0:
            self.topCoverThicknessID = dict[@"id"];
            break;
        case 1:
            self.bottomCoverThicknessID = dict[@"id"];
            break;
        default:
            break;
    }
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height + 44, 0.0);
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

- (void)pickerWillShowBelt
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, self.pickerContainerView.frame.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= self.pickerContainerView.frame.size.height;
    if (!CGRectContainsPoint(aRect, self.activeLabel.frame.origin)) {
        [self.scrollView scrollRectToVisible:self.activeLabel.frame
                                    animated:YES];
    }
}

- (void)pickerWillHideBelt
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

- (IBAction)openPicker:(UIButton *)sender
{
    self.pickerSelection = @"";
    switch (sender.tag) {
        case 0:
            self.pickerElements = [CPActualBeltArray thicknessCoverArray];
            self.pickerViewData.hidden = NO;
            self.pickerView.hidden = YES;
            [self.pickerViewData reloadAllComponents];
            [self.pickerViewData selectRow:0 inComponent:0 animated:YES];
            self.activeLabel = self.topCoverThicknessDescLB;
            break;
        case 1:
            self.pickerElements = [CPActualBeltArray thicknessCoverArray];
            self.pickerViewData.hidden = NO;
            self.pickerView.hidden = YES;
            [self.pickerViewData reloadAllComponents];
            [self.pickerViewData selectRow:0 inComponent:0 animated:YES];
            self.activeLabel = self.bottomCoverThicknessDescLB;
            break;
        case 2:
            self.pickerView.hidden = NO;
            self.pickerViewData.hidden = YES;
            self.activeLabel = self.instalationDateDescLB;
            break;
        default:
            break;
    }
    self.tagButtonSelected = sender.tag;
    [self.activeTextField resignFirstResponder];
    [self.view layoutIfNeeded];
    self.containerPickerHeightCNST.constant = 207;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
    [[NSNotificationCenter defaultCenter] postNotificationName:CPPickerViewWillShowBeltNotification
                                                        object:nil];
}

- (IBAction)closePicker
{
    [self.view layoutIfNeeded];
    self.pickerView.hidden = YES;
    self.pickerViewData.hidden = YES;
    self.containerPickerHeightCNST.constant = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
    switch (self.tagButtonSelected) {
        case 0:
        {
            self.topCoverThicknessDescLB.text = self.pickerSelection;
            break;
        }
        case 1:
        {
            self.bottomCoverThicknessDescLB.text = self.pickerSelection;
            break;
        }
        case 2:
        {
            self.installationDate = self.pickerView.date;
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MMM dd, YYYY"];
            NSString *dateString = [dateFormat stringFromDate:self.pickerView.date];
            self.instalationDateDescLB.text = dateString;
            break;
        }
            
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:CPPickerViewWillHideBeltNotification
                                                        object:nil];
}

@end
