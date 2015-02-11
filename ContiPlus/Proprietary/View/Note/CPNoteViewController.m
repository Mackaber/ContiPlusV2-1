//
//  CPNoteViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/9/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPNoteViewController.h"
#import "CPNote.h"
#import "CPDateUtils.h"
#import "CPLanguajeUtils.h"
#import "MRProgress.h"
#import "CPUser.h"

@interface CPNoteViewController ()
@property (weak, nonatomic) IBOutlet UILabel *noteTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *editedDateLB;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;

@end

@implementation CPNoteViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void)setUpView
{
    self.navigationController.navigationBar.hidden = YES;
    self.noteTitleLB.text = self.cpNote.name;
    self.editedDateLB.text = [CPDateUtils stringFromTimeStamp:@(self.cpNote.updatedAt)];
    self.descriptionTV.text = self.cpNote.descriptionStr;
}

#pragma mark - IBAction Methods
- (IBAction)eraseNote
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"¡ATENCIÓN!"]
                                                                             message:[CPLanguajeUtils languajeSelectedForString:@"Al eliminar la nota no se podrá recuperar la información. ¿Desea continuar?"]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Sí"]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                                                                        title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                                                                         mode:MRProgressOverlayViewModeIndeterminate
                                                                                     animated:YES];
                                                    [CPNote deleteNoteWithWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                            ID:self.cpNote.ID
                                                                            completionHandler:^(BOOL success) {
                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                    [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                                                        animated:YES];
                                                                                    if (success) {
                                                                                        [self.navigationController popViewControllerAnimated:YES];
                                                                                    } else {
                                                                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al borrar la nota"]
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
                                                }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"No"]
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   [alertController dismissViewControllerAnimated:YES
                                                                                       completion:nil];
                                               }];
    [alertController addAction:yes];
    [alertController addAction:no];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (IBAction)returnToPrevController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
