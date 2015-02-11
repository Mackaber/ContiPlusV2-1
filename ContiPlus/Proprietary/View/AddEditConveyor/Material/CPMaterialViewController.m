//
//  CPMaterialViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/2/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPMaterialViewController.h"
#import "CPLanguajeUtils.h"
#import "BSKeyboardControls.h"
#import "CPMaterialArray.h"

static NSString *CPDismissAddEditViewControllerNotification = @"CPDismissAddEditViewControllerNotification";
static NSString *CPSaveInfoInAddEditViewControllerNotification = @"CPSaveInfoInAddEditViewControllerNotification";

static NSString *CPPickerViewWillShowNotification = @"CPPickerViewWillShowNotification";
static NSString *CPPickerViewWillHideNotification = @"CPPickerViewWillHideNotification";

@interface CPMaterialViewController ()
<UITextFieldDelegate, BSKeyboardControlsDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLB;
@property (weak, nonatomic) IBOutlet UILabel *densityLB;
@property (weak, nonatomic) IBOutlet UILabel *maxSizeTerronLB;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLB;
@property (weak, nonatomic) IBOutlet UILabel *heightOfFallLB;
@property (weak, nonatomic) IBOutlet UILabel *finesLB;
@property (weak, nonatomic) IBOutlet UILabel *loadingConditionsLB;
@property (weak, nonatomic) IBOutlet UILabel *loadingFrecuencyLB;
@property (weak, nonatomic) IBOutlet UILabel *granularSizeLB;
@property (weak, nonatomic) IBOutlet UILabel *densityNewLB;
@property (weak, nonatomic) IBOutlet UILabel *aggresivityLB;
@property (weak, nonatomic) IBOutlet UILabel *materialConveyedLB;
@property (weak, nonatomic) IBOutlet UILabel *feedingConditionsLB;
@property (weak, nonatomic) IBOutlet UILabel *numerationLb;

@property (weak, nonatomic) IBOutlet UIView *pickerViewContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerPickerHeightCNST;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *doneBT;

@property (strong, nonatomic) NSArray *pickerElements;
@property (weak, nonatomic) UITextField *activeTextField;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (strong, nonatomic) NSNumber *materialDensitySelected;
@property (strong, nonatomic) NSString *pickerSelection;

@property (weak, nonatomic) UILabel *activeLabel;

@property (nonatomic) NSInteger tagButtonSelected;

@property (strong, nonatomic) NSArray *materialSortedArray;

@end

@implementation CPMaterialViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self setUpView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pickerWillShow)
                                                 name:CPPickerViewWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pickerWillHide)
                                                 name:CPPickerViewWillHideNotification
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
    
    NSArray *fields = @[self.maxSizeTerronTF, self.temperatureTF, self.heightOfFallTF, self.finesTF];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CPPickerViewWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CPPickerViewWillHideNotification
                                                  object:nil];
}

- (void)setUpView
{
    self.titleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Material"];
    self.descriptionLB.text = [CPLanguajeUtils languajeSelectedForString:@"Descripción"];
    self.densityLB.text = [CPLanguajeUtils languajeSelectedForString:@"Densidad (lbs/ft3)"];
    self.maxSizeTerronLB.text = [CPLanguajeUtils languajeSelectedForString:@"Tamaño max. terrón (Plg)"];
    self.temperatureLB.text = [CPLanguajeUtils languajeSelectedForString:@"Temperatura (°C)"];
    self.heightOfFallLB.text = [CPLanguajeUtils languajeSelectedForString:@"Altura de caída (m)"];
    self.finesLB.text = [CPLanguajeUtils languajeSelectedForString:@"Finos (%)"];
    self.loadingConditionsLB.text = [CPLanguajeUtils languajeSelectedForString:@"Condiciones de carga"];
    self.loadingFrecuencyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Frecuencia de carga"];
    self.granularSizeLB.text = [CPLanguajeUtils languajeSelectedForString:@"Tamaño granular"];
    self.densityNewLB.text = [CPLanguajeUtils languajeSelectedForString:@"Densidad"];
    self.aggresivityLB.text = [CPLanguajeUtils languajeSelectedForString:@"Agresividad"];
    self.materialConveyedLB.text = [CPLanguajeUtils languajeSelectedForString:@"Material transportado"];
    self.feedingConditionsLB.text = [CPLanguajeUtils languajeSelectedForString:@"Condiciones de alimentación"];
    [self.doneBT setTitle:[CPLanguajeUtils languajeSelectedForString:@"Hecho"]
                 forState:UIControlStateNormal];
    
    self.numerationLb.text = [CPLanguajeUtils languajeSelectedForString:@"4 de 8"];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"Name"
                                                         ascending:YES
                                                          selector:@selector(caseInsensitiveCompare:)];
    self.materialSortedArray = [[CPMaterialArray materialArray] sortedArrayUsingDescriptors:@[sort]];
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

-(UIView *)pickerView:(UIPickerView *)pickerView
           viewForRow:(NSInteger)row forComponent:(NSInteger)component
          reusingView:(UIView *)view
{
    NSDictionary *dictionary = self.pickerElements[row];
    NSString *name = dictionary[@"Name"];
    NSDictionary *attributeDict = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue"
                                                                         size:16.0]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:name
                                                                           attributes:attributeDict];
    
    // add the string to a label's attributedText property
    UILabel *labelView = [[UILabel alloc] init];
    labelView.attributedText = attributedString;
    labelView.textAlignment = NSTextAlignmentCenter;
    // return the label
    return labelView;
}

#pragma mark - UIPickerView Delegate Methods

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    NSDictionary *dict = self.pickerElements[row];
    self.pickerSelection = [dict objectForKey:@"Name"];
    switch (self.tagButtonSelected) {
        case 0:
            self.materialDensitySelected = [dict objectForKey:@"Value"];
            self.matDescriptionID = dict[@"id"];
            break;
        case 1:
            self.matLoadingConditionsID = dict[@"id"];
            break;
        case 2:
            self.matLoadingFrecuencyID = dict[@"id"];
            break;
        case 3:
            self.matGranularSizeID = dict[@"id"];
            break;
        case 4:
            self.matDensityNewID = dict[@"id"];
            break;
        case 5:
            self.matAggresivityID = dict[@"id"];
            break;
        case 6:
            self.matMaterialConveyedID = dict[@"id"];
            break;
        case 7:
            self.matFeedingConditionsID = dict[@"id"];
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
- (void)pickerWillShow
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, self.pickerViewContainer.frame.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= self.pickerViewContainer.frame.size.height;
    if (!CGRectContainsPoint(aRect, self.activeLabel.frame.origin)) {
        [self.scrollView scrollRectToVisible:self.activeLabel.frame
                                    animated:YES];
    }
}

- (void)pickerWillHide
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
            self.materialDensitySelected = 0;
            self.pickerElements = self.materialSortedArray;//[CPMaterialArray materialArray];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            self.activeLabel = self.descriptionDescLB;
            break;
        case 1:
            self.pickerElements = [CPMaterialArray conditionsArray];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            self.activeLabel = self.loadingConditionsDescLB;
            break;
        case 2:
            self.pickerElements = [CPMaterialArray loadingFrecuencyArray];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            self.activeLabel = self.loadingFrecuencyDescLB;
            break;
        case 3:
            self.pickerElements = [CPMaterialArray granularSizeArray];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            self.activeLabel = self.granularSizeDescLB;
            break;
        case 4:
            self.pickerElements = [CPMaterialArray densityArray];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            self.activeLabel = self.densityNewDescLB;
            break;
        case 5:
            self.pickerElements = [CPMaterialArray aggresivityArray];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            self.activeLabel = self.aggresivityDescLB;
            break;
        case 6:
            self.pickerElements = [CPMaterialArray materialConveyedArray];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            self.activeLabel = self.materialConveyedDescLB;
            break;
        case 7:
            self.pickerElements = [CPMaterialArray feedingConditionsArray];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            self.activeLabel = self.feedingConditionsDescLB;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:CPPickerViewWillShowNotification
                                                        object:nil];
}

- (IBAction)closePicker
{
    self.activeLabel = nil;
    [self.view layoutIfNeeded];
    self.pickerView.hidden = YES;
    self.containerPickerHeightCNST.constant = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
    switch (self.tagButtonSelected) {
        case 0:
            self.descriptionDescLB.text = self.pickerSelection;
            if ([self.materialDensitySelected intValue] == 0)
                self.densityDescLB.text = @"";
            else
                self.densityDescLB.text = [NSString stringWithFormat:@"%@", self.materialDensitySelected];
            break;
        case 1:
            self.loadingConditionsDescLB.text = self.pickerSelection;
            break;
        case 2:
            self.loadingFrecuencyDescLB.text = self.pickerSelection;
            break;
        case 3:
            self.granularSizeDescLB.text = self.pickerSelection;
            break;
        case 4:
            self.densityNewDescLB.text = self.pickerSelection;
            break;
        case 5:
            self.aggresivityDescLB.text = self.pickerSelection;
            break;
        case 6:
            self.materialConveyedDescLB.text = self.pickerSelection;
            break;
        case 7:
            self.feedingConditionsDescLB.text = self.pickerSelection;
            break;
            
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:CPPickerViewWillHideNotification
                                                        object:nil];
}


@end
