//
//  CPDetailsViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/29/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPDetailsViewController.h"
#import "CPLanguajeUtils.h"
#import "CPProfilesViewController.h"

static NSString *CPDismissAddEditViewControllerNotification = @"CPDismissAddEditViewControllerNotification";
static NSString *CPSaveInfoInAddEditViewControllerNotification = @"CPSaveInfoInAddEditViewControllerNotification";

@interface CPDetailsViewController ()
<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CPProfilesViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *numberLB;
@property (weak, nonatomic) IBOutlet UILabel *profileLB;
@property (weak, nonatomic) IBOutlet UILabel *numerationLb;

@end

@implementation CPDetailsViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self setUpView];
}


- (void)setUpView
{
    self.titleView.text = [CPLanguajeUtils languajeSelectedForString:@"Detalles"];
    
    self.numberLB.text = [CPLanguajeUtils languajeSelectedForString:@"Número"];
    self.profileLB.text = [CPLanguajeUtils languajeSelectedForString:@"Perfil"];
    self.numerationLb.text = [CPLanguajeUtils languajeSelectedForString:@"1 de 8"];
    [self.profileBT setTitle:[CPLanguajeUtils languajeSelectedForString:@"Seleccionar perfil"]
                    forState:UIControlStateNormal];
    self.profileBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

#pragma mark - UIStatusBar White Color
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - IBAction Methods
- (IBAction)openSelectionPhoto
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Agregar imagen"]
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Capturar imagen"]
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                           NSLog(@"There isn't a camera on the simulator");
                                                       } else {
                                                           UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                           picker.delegate = self;
                                                           picker.allowsEditing = YES;
                                                           picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                           
                                                           [self presentViewController:picker animated:YES completion:nil];
                                                       }
                                                   }];
    UIAlertAction *album = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Seleccionar de galería"]
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {
                                                      UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                      picker.delegate = self;
                                                      picker.allowsEditing = YES;
                                                      picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                      
                                                      [self presentViewController:picker animated:YES completion:nil];
                                                  }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Cancelar"]
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
                                                       [actionSheet dismissViewControllerAnimated:YES
                                                                                       completion:nil];
                                                   }];
    [actionSheet addAction:camera];
    [actionSheet addAction:album];
    [actionSheet addAction:cancel];
    
    [self presentViewController:actionSheet
                       animated:YES
                     completion:nil];
}

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

#pragma mark - UIImagePickerView Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    self.photoBT.hidden = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - CPProfilesViewController Delegate Methods
- (void)returnSelectedProfileID:(int)profileID
{
    self.profileID = profileID;
    self.profileImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"profile_%i", self.profileID]];
    [self.profileBT setTitle:@""
                    forState:UIControlStateNormal];
}

#pragma mark - Navigation Methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"profilesSegue"]) {
        CPProfilesViewController *profilesViewController = segue.destinationViewController;
        profilesViewController.delegate = self;
    }
}


@end
