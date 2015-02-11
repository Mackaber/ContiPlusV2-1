//
//  CPAddImageViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/9/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPAddImageViewController.h"
#import "CPLanguajeUtils.h"
#import "BSKeyboardControls.h"
#import "CPImage.h"
#import "CPDateUtils.h"
#import "MRProgress.h"
#import "CPFileUtils.h"
#import "DejalActivityView.h"
#import "CPUser.h"

@interface CPAddImageViewController ()
<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, BSKeyboardControlsDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoBT;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation CPAddImageViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    NSArray *fields = @[self.titleTF, self.descriptionTV];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

- (void)setUpView
{
    self.titleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Título"];
    self.navigationController.navigationBar.hidden = NO;
    if (self.isEditable || self.isCache) {
        self.titleTF.text = self.image.name;
        self.descriptionTV.text = self.image.descriptionStr;
        NSData *imgData = [CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", self.image.conveyorID, self.image.bucketID, self.image.createdAt]
                                                         dataType:CPImageFile];
        self.imageView.image = [UIImage imageWithData:imgData];
        self.addPhotoBT.hidden = YES;
    } else {
        self.descriptionTV.text = [CPLanguajeUtils languajeSelectedForString:@"Descripción"];
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
    if ([textView.text isEqualToString:[CPLanguajeUtils languajeSelectedForString:@"Descripción"]]) {
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
        textView.text = [CPLanguajeUtils languajeSelectedForString:@"Descripción"];
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

#pragma mark - UIImagePickerView Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    self.addPhotoBT.hidden = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - IBAction Methods
- (IBAction)openMenuPhoto
{
    [self.titleTF resignFirstResponder];
    [self.descriptionTV resignFirstResponder];
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

- (IBAction)saveImage
{
    if ([self.titleTF.text isEqualToString:@""]) {
        [self showAlertWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al guardar"]
                      andMessage:[CPLanguajeUtils languajeSelectedForString:@"Debe proporcionar un título"]];
    } else if (!self.imageView.image) {
        [self showAlertWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al guardar"]
                      andMessage:[CPLanguajeUtils languajeSelectedForString:@"Es necesario seleccionar al menos 1 archivo de imagen"]];
    } else {
        if (self.isCacheConveyor) {
            NSMutableArray *draftsConveyor = [NSMutableArray array];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]) {
                draftsConveyor = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]] mutableCopy];
            }
            int createdAt = [CPDateUtils timeStampFromDate:[NSDate date]];
            [draftsConveyor addObject:[CPImage imageWithName:self.titleTF.text
                                      descriptionImg:self.descriptionTV.text
                                          conveyorID:self.conveyorID
                                            bucketID:self.bucketID
                                           createdAt:createdAt
                                           updatedAt:createdAt]];
            NSData *encodeConveyorsCacheArray = [NSKeyedArchiver archivedDataWithRootObject:draftsConveyor];
            [[NSUserDefaults standardUserDefaults] setObject:encodeConveyorsCacheArray forKey:@"draftsConveyorArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [CPFileUtils saveDataToUserForder:UIImageJPEGRepresentation(self.imageView.image, 1.0f)
                                     withName:[NSString stringWithFormat:@"%i%i_%i", self.conveyorID, self.bucketID, createdAt]
                                     dataType:CPImageFile];
            [self.navigationController popViewControllerAnimated:YES];
        } else if (self.isEditableConveyorChache) {
            NSMutableArray *drafts = [NSMutableArray array];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]) {
                drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]] mutableCopy];
            }
            int index = 0;
            for (id temp in drafts) {
                if ([temp isKindOfClass:[CPImage class] ]) {
                    CPImage *tmpImg = (CPImage *)temp;
                    if (tmpImg.createdAt == self.image.createdAt) {
                        break;
                    }
                }
                index++;
            }
            [drafts replaceObjectAtIndex:index
                              withObject:[CPImage imageWithName:self.titleTF.text
                                                 descriptionImg:self.descriptionTV.text
                                                     conveyorID:self.image.conveyorID
                                                       bucketID:self.image.bucketID
                                                      createdAt:self.image.createdAt
                                                      updatedAt:self.image.updatedAt]];
            NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
            [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsConveyorArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                                title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                                 mode:MRProgressOverlayViewModeIndeterminate
                                             animated:YES];
            if (self.isCache || !self.isEditable) {
                [CPImage saveImageWithAuthenticationKey:[CPUser sharedUser].authKey
                                              imageData:UIImageJPEGRepresentation(self.imageView.image, 1.0f)
                                                   name:self.titleTF.text
                                         descriptionImg:self.descriptionTV.text
                                             conveyorID:self.isCache ? self.image.conveyorID : self.conveyorID
                                               bucketID:self.isCache ? self.image.bucketID : self.bucketID
                                              createdAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                              updatedAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                      completionHandler:^(NSURLResponse *response, NSError *error, NSString *name, int coverID) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [MRProgressOverlayView  dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                   animated:YES];
                                              if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error) {
                                                  if (self.isCache) {
                                                      UIAlertController *alertCache = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al subir la imagen"]
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
                                                                                                          if ([temp isKindOfClass:[CPImage class] ]) {
                                                                                                              CPImage *tmpImg = (CPImage *)temp;
                                                                                                              if (tmpImg.createdAt == self.image.createdAt) {
                                                                                                                  break;
                                                                                                              }
                                                                                                          }
                                                                                                          index++;
                                                                                                      }
                                                                                                      [drafts replaceObjectAtIndex:index
                                                                                                                        withObject:[CPImage imageWithName:self.titleTF.text
                                                                                                                                           descriptionImg:self.descriptionTV.text
                                                                                                                                               conveyorID:self.image.conveyorID
                                                                                                                                                 bucketID:self.image.bucketID
                                                                                                                                                createdAt:self.image.createdAt
                                                                                                                                                updatedAt:self.image.updatedAt]];
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
                                                      UIAlertController *alertCache = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al subir la imagen"]
                                                                                                                          message:[CPLanguajeUtils languajeSelectedForString:@"¿Desea guardar la imagen en borradores?"]
                                                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                                                      UIAlertAction *yes = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Sí"]
                                                                                                    style:UIAlertActionStyleDefault
                                                                                                  handler:^(UIAlertAction *action) {
                                                                                                      NSMutableArray *drafts = [NSMutableArray array];
                                                                                                      if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]) {
                                                                                                          drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                                                                      }
                                                                                                      int createdAt = [CPDateUtils timeStampFromDate:[NSDate date]];
                                                                                                      [drafts addObject:[CPImage imageWithName:self.titleTF.text
                                                                                                                                descriptionImg:self.descriptionTV.text
                                                                                                                                    conveyorID:self.conveyorID
                                                                                                                                      bucketID:self.bucketID
                                                                                                                                     createdAt:createdAt
                                                                                                                                     updatedAt:createdAt]];
                                                                                                      NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                                                                                      [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsArray"];
                                                                                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                      [CPFileUtils saveDataToUserForder:UIImageJPEGRepresentation(self.imageView.image, 1.0f)
                                                                                                                               withName:[NSString stringWithFormat:@"%i%i_%i", self.conveyorID, self.bucketID, createdAt]
                                                                                                                               dataType:CPImageFile];
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
                                              } else {
                                                  [CPFileUtils saveDataToUserForder:UIImageJPEGRepresentation(self.imageView.image, 1.0f)
                                                                           withName:name
                                                                           dataType:CPImageFile];
                                                  if (self.isCache) {
                                                      NSMutableArray *drafts = [NSMutableArray array];
                                                      drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                      
                                                      int index = 0;
                                                      for (id temp in drafts) {
                                                          if ([temp isKindOfClass:[CPImage class] ]) {
                                                              CPImage *tmpImg = (CPImage *)temp;
                                                              if (tmpImg.createdAt == self.image.createdAt) {
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
                                              }
                                          });
                                      }];
            } else if (self.isEditable) {
                [CPImage updateImageWithAuthenticationKey:[CPUser sharedUser].authKey
                                                       ID:self.image.ID
                                                     name:self.titleTF.text
                                           descriptionImg:self.descriptionTV.text
                                                      url:self.image.url
                                               conveyorID:self.conveyorID
                                                 bucketID:self.bucketID
                                                createdAt:self.image.createdAt
                                                updatedAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                        completionHandler:^(BOOL success) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [MRProgressOverlayView  dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                     animated:YES];
                                                if (success) {
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                } else {
                                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al actualizar la imagen"]
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
            }
        }
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
