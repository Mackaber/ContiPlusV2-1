//
//  CPIdlersViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/3/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPIdlersViewController.h"
#import "CPLanguajeUtils.h"
#import "BSKeyboardControls.h"
#import "CPIdlersArray.h"

static NSString *CPDismissAddEditViewControllerNotification = @"CPDismissAddEditViewControllerNotification";
static NSString *CPSaveInfoInAddEditViewControllerNotification = @"CPSaveInfoInAddEditViewControllerNotification";

static NSString *CPPickerViewWillShowIdlersNotification = @"CPPickerViewWillShowIdlersNotification";
static NSString *CPPickerViewWillHideIdlersNotification = @"CPPickerViewWillHideIdlersNotification";

@interface CPIdlersViewController ()
<UITextFieldDelegate, BSKeyboardControlsDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *impactLCLB;
@property (weak, nonatomic) IBOutlet UILabel *loadLCLB;
@property (weak, nonatomic) IBOutlet UILabel *returnLCLB;
@property (weak, nonatomic) IBOutlet UILabel *spaceLCLB;
@property (weak, nonatomic) IBOutlet UILabel *spaceLRLB;
@property (weak, nonatomic) IBOutlet UILabel *impactLRLB;
@property (weak, nonatomic) IBOutlet UILabel *loadLRLB;
@property (weak, nonatomic) IBOutlet UILabel *returnLRLB;
@property (weak, nonatomic) IBOutlet UILabel *partTroghingLB;
@property (weak, nonatomic) IBOutlet UILabel *numerationLb;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerPickerHeightCNST;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *doneBT;

@property (strong, nonatomic) NSArray *pickerElements;
@property (weak, nonatomic) UITextField *activeTextField;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@property (nonatomic) NSInteger tagButtonSelected;
@property (strong, nonatomic) NSString *pickerSelection;
@property (weak, nonatomic) IBOutlet UIView *pickerContainerView;
@property (weak, nonatomic) UILabel *activeLabel;

@end

@implementation CPIdlersViewController

#pragma mark - UIViewController LifeCylcle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self setUpView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pickerWillShowIdlres)
                                                 name:CPPickerViewWillShowIdlersNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pickerWillHideIdlers)
                                                 name:CPPickerViewWillHideIdlersNotification
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
    self.containerPickerHeightCNST.constant = 0;
    
    NSArray *fields = @[self.impactLCTF, self.spaceLCTF, self.spaceLRTF, self.returnLRTF];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CPPickerViewWillShowIdlersNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CPPickerViewWillHideIdlersNotification
                                                  object:nil];
}

- (void)setUpView
{
    self.titleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Rodillos"];
    self.impactLCLB.text = [CPLanguajeUtils languajeSelectedForString:@"Impacto Ø (Plg)"];
    self.loadLCLB.text = [CPLanguajeUtils languajeSelectedForString:@"Carga Ø (Plg)"];
    self.returnLCLB.text = [CPLanguajeUtils languajeSelectedForString:@"Retorno Ø (Plg)"];
    self.spaceLCLB.text = [CPLanguajeUtils languajeSelectedForString:@"Espacio (LC) (m)"];
    self.spaceLRLB.text = [CPLanguajeUtils languajeSelectedForString:@"Espacio (LR) (m)"];
    self.impactLRLB.text = [CPLanguajeUtils languajeSelectedForString:@"Impacto (°)"];
    self.loadLRLB.text = [CPLanguajeUtils languajeSelectedForString:@"Carga (°)"];
    self.returnLRLB.text = [CPLanguajeUtils languajeSelectedForString:@"Retorno (°)"];
    self.partTroghingLB.text = [CPLanguajeUtils languajeSelectedForString:@"Partes por artesa"];
    [self.doneBT setTitle:[CPLanguajeUtils languajeSelectedForString:@"Hecho"]
                 forState:UIControlStateNormal];
    
    self.numerationLb.text = [CPLanguajeUtils languajeSelectedForString:@"7 de 8"];

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
    self.pickerSelection = [dict objectForKey:@"Value"];
    switch (self.tagButtonSelected) {
        case 1:
            self.loadDiameterID = dict[@"id"];
            break;
        case 3:
            self.returnDiameterID = dict[@"id"];
            break;
        case 4:
            self.impactAngleID = dict[@"id"];
            break;
        case 5:
            self.loadAngleID = dict[@"id"];
            break;
        default:
            break;
    }
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

#pragma mark - NSNotification PickerView Methods

- (void)pickerWillShowIdlres
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

- (void)pickerWillHideIdlers
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
        case 1:
            self.pickerElements = [CPIdlersArray diametersLoadArray];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            self.activeLabel = self.loadLCDescLB;
            break;
        case 2:
            self.pickerElements = [CPIdlersArray partTroughingArray];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            self.activeLabel = self.partTroghingDescLB;
            break;
        case 3:
            self.pickerElements = [CPIdlersArray diametersReturnArray];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            self.activeLabel = self.returnLCDescLB;
            break;
        case 4:
            self.pickerElements = [CPIdlersArray anglesImpactArray];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            self.activeLabel = self.impactLRDescLB;
            break;
        case 5:
            self.pickerElements = [CPIdlersArray anglesLoadArray];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            self.activeLabel = self.loadLRDescLB;
            break;
        default:
            break;
    }
    self.tagButtonSelected = sender.tag;
    [self.activeTextField resignFirstResponder];
    [self.view layoutIfNeeded];
    self.pickerView.hidden = NO;
    self.containerPickerHeightCNST.constant = 207;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CPPickerViewWillShowIdlersNotification
                                                        object:nil];
}

- (IBAction)closePicker
{
    [self.view layoutIfNeeded];
    self.activeLabel = nil;
    self.pickerView.hidden = YES;
    self.containerPickerHeightCNST.constant = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
    switch (self.tagButtonSelected) {
        case 1:
            self.loadLCDescLB.text = self.pickerSelection;
            break;
        case 2:
            self.partTroghingDescLB.text = self.pickerSelection;
            break;
        case 3:
            self.returnLCDescLB.text = self.pickerSelection;
            break;
        case 4:
            self.impactLRDescLB.text = self.pickerSelection;
            break;
        case 5:
            self.loadLRDescLB.text = self.pickerSelection;
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:CPPickerViewWillHideIdlersNotification
                                                        object:nil];
}

@end
