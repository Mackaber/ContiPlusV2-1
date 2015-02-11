//
//  CPRemarksViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/3/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPRemarksViewController.h"
#import "CPLanguajeUtils.h"
#import "BSKeyboardControls.h"

static NSString *CPDismissAddEditViewControllerNotification = @"CPDismissAddEditViewControllerNotification";
static NSString *CPSaveInfoInAddEditViewControllerNotification = @"CPSaveInfoInAddEditViewControllerNotification";

@interface CPRemarksViewController ()
<UITextViewDelegate, BSKeyboardControlsDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIView *statusBarView;
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UILabel *numerationLb;

@property (nonatomic) CGFloat initialHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightCNST;
@property (weak, nonatomic) IBOutlet UIButton *backBT;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation CPRemarksViewController

#pragma mark - UIViewController Lifecycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self setUpView];
    self.initialHeight = self.view.frame.size.height - self.statusBarView.frame.size.height - self.navigationBarView.frame.size.height;
    self.textViewHeightCNST.constant = self.initialHeight;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    NSArray *fields = @[self.textView];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)setUpView
{
    self.titleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Observaciones"];
    self.numerationLb.text = [CPLanguajeUtils languajeSelectedForString:@"8 de 8"];
}

#pragma mark - UIStatusBar White Color
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.keyboardControls setActiveField:textView];
}


#pragma mark - NSNotification Keyboard Methods
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    [self.view layoutIfNeeded];
    self.textViewHeightCNST.constant = self.initialHeight - kbRect.size.height;
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

#pragma mark - BSKeyboardControls Delegate Methods
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    [self.view layoutIfNeeded];
    self.textViewHeightCNST.constant = self.initialHeight;
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
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


@end
