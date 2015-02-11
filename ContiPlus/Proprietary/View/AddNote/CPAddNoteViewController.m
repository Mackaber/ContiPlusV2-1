//
//  CPAddNoteViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/10/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPAddNoteViewController.h"
#import "CPLanguajeUtils.h"
#import "BSKeyboardControls.h"
#import "CPNote.h"
#import "MRProgress.h"
#import "CPDateUtils.h"
#import "CPUser.h"

@interface CPAddNoteViewController ()
<UITextFieldDelegate, UITextViewDelegate, BSKeyboardControlsDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (nonatomic) CGFloat initialHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightCNST;
@end

@implementation CPAddNoteViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    self.initialHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.titleLB.frame.size.height - self.titleTF.frame.size.height;
    self.textViewHeightCNST.constant = self.initialHeight;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    NSArray *fields = @[self.titleTF, self.descriptionTV];
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
    self.titleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Título"];
    
    if (self.isCache) {
        self.titleTF.text = self.note.name;
        self.descriptionTV.text = self.note.descriptionStr;
    } else {
        self.descriptionTV.text = [CPLanguajeUtils languajeSelectedForString:@"Nota"];
    }
}

#pragma mark - UITextfield Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
}

#pragma mark - UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.keyboardControls setActiveField:textView];
    if ([textView.text isEqualToString:[CPLanguajeUtils languajeSelectedForString:@"Nota"]]) {
        textView.text = @"";
        textView.textColor = [UIColor colorWithRed:127.0/255.0
                                             green:127.0/255.0
                                              blue:127.0/255.0
                                             alpha:1.0];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = [CPLanguajeUtils languajeSelectedForString:@"Nota"];
        textView.textColor = [UIColor colorWithRed:127.0/255.0
                                             green:127.0/255.0
                                              blue:127.0/255.0
                                             alpha:1.0];
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
    
    [self.view layoutIfNeeded];
    self.textViewHeightCNST.constant = self.initialHeight - kbRect.size.height - 64;
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
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
- (IBAction)saveNote
{
    if ([self.titleTF.text isEqualToString:@""]) {
        [self showAlertWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al guardar"]
                      andMessage:[CPLanguajeUtils languajeSelectedForString:@"Debe proporcionar un título"]];
    } else if ([self.descriptionTV.text isEqualToString:[CPLanguajeUtils languajeSelectedForString:@"Nota"]] || [self.descriptionTV.text isEqualToString:@""]) {
        [self showAlertWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al guardar"]
                      andMessage:[CPLanguajeUtils languajeSelectedForString:@"Es necesario agregar texto a la nota"]];
    } else {
        [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                            title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                             mode:MRProgressOverlayViewModeIndeterminate
                                         animated:YES];
        [CPNote saveNoteWithAuthenticationKey:[CPUser sharedUser].authKey
                                         name:self.titleTF.text
                              descriptionNote:self.descriptionTV.text
                                   conveyorID:self.isCache ? self.note.conveyorID :self.conveyorID
                                     bucketID:self.isCache ? self.note.bucketID : self.bucketID
                                    createdAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                    updatedAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                            completionHandler:^(BOOL success) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [MRProgressOverlayView  dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                         animated:YES];
                                    if (success) {
                                        if (self.isCache) {
                                            NSMutableArray *drafts = [NSMutableArray array];
                                            drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                            
                                            int index = 0;
                                            for (id temp in drafts) {
                                                if ([temp isKindOfClass:[CPNote class] ]) {
                                                    CPNote *tmpNote = (CPNote *)temp;
                                                    if (tmpNote.createdAt == self.note.createdAt) {
                                                        break;
                                                    }
                                                }
                                                index++;
                                            }
                                            
                                            [drafts removeObjectAtIndex:index];
                                            
                                            NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                            [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsArray"];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                        }
                                        [self.navigationController popViewControllerAnimated:YES];
                                    } else {
                                        if (self.isCache) {
                                            UIAlertController *alertCache = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al subir la nota"]
                                                                                                                message:[CPLanguajeUtils languajeSelectedForString:@"¿Desea guardar los cambios?"]
                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                            UIAlertAction *yes = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Sí"]
                                                                                          style:UIAlertActionStyleDefault
                                                                                        handler:^(UIAlertAction *action) {
                                                                                            NSMutableArray *drafts = [NSMutableArray array];
                                                                                            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]) {
                                                                                                drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                                                            }
                                                                                            int index = 0;
                                                                                            for (id temp in drafts) {
                                                                                                if ([temp isKindOfClass:[CPNote class] ]) {
                                                                                                    CPNote *tmpNote = (CPNote *)temp;
                                                                                                    if (tmpNote.createdAt == self.note.createdAt) {
                                                                                                        break;
                                                                                                    }
                                                                                                }
                                                                                                index++;
                                                                                            }
                                                                                            [drafts replaceObjectAtIndex:index
                                                                                                              withObject:[CPNote noteWithName:self.titleTF.text
                                                                                                                                  description:self.descriptionTV.text
                                                                                                                                   conveyorID:self.note.conveyorID
                                                                                                                                     bucketID:self.note.bucketID
                                                                                                                                    createdAt:self.note.createdAt
                                                                                                                                    updatedAt:self.note.updatedAt]];
                                                                                            NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                                                                            [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsArray"];
                                                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                            [self.navigationController popViewControllerAnimated:YES];
                                                                                        }];
                                            UIAlertAction *no = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"No"]
                                                                                         style:UIAlertActionStyleDefault
                                                                                       handler:^(UIAlertAction *action) {
                                                                                           [alertCache dismissViewControllerAnimated:YES
                                                                                                                          completion:nil];
                                                                                       }];
                                            [alertCache addAction:yes];
                                            [alertCache addAction:no];
                                            
                                            [self presentViewController:alertCache
                                                               animated:YES
                                                             completion:nil];
                                        } else {
                                            UIAlertController *alertCache = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al subir la nota"]
                                                                                                                message:[CPLanguajeUtils languajeSelectedForString:@"¿Desea guardar la nota en borradores?"]
                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                            UIAlertAction *yes = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Sí"]
                                                                                          style:UIAlertActionStyleDefault
                                                                                        handler:^(UIAlertAction *action) {
                                                                                            NSMutableArray *drafts = [NSMutableArray array];
                                                                                            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]) {
                                                                                                drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                                                            }
                                                                                            int createdAt = [CPDateUtils timeStampFromDate:[NSDate date]];
                                                                                            [drafts addObject:[CPNote noteWithName:self.titleTF.text
                                                                                                                       description:self.descriptionTV.text
                                                                                                                        conveyorID:self.conveyorID
                                                                                                                          bucketID:self.bucketID
                                                                                                                         createdAt:createdAt
                                                                                                                         updatedAt:createdAt]];
                                                                                            NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                                                                            [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsArray"];
                                                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                            [self.navigationController popViewControllerAnimated:YES];
                                                                                        }];
                                            UIAlertAction *no = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"No"]
                                                                                         style:UIAlertActionStyleDefault
                                                                                       handler:^(UIAlertAction *action) {
                                                                                           [alertCache dismissViewControllerAnimated:YES
                                                                                                                          completion:nil];
                                                                                       }];
                                            [alertCache addAction:yes];
                                            [alertCache addAction:no];
                                            
                                            [self presentViewController:alertCache
                                                               animated:YES
                                                             completion:nil];
                                        }
                                    }
                                });
                            }];
    }
}

#pragma mark - UIAlertController Message Method
- (void)showAlertWithTitle:(NSString *)title
                andMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
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

@end
