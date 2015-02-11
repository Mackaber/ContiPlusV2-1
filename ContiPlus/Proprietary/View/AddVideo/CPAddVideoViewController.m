//
//  CPAddVideoViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/10/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPAddVideoViewController.h"
#import "CPLanguajeUtils.h"
#import "BSKeyboardControls.h"
#import "CPVideo.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MRProgress.h"
#import "CPDateUtils.h"
#import "CPFileUtils.h"
#import "CPUser.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import <CoreMedia/CoreMedia.h>

@interface CPAddVideoViewController ()
<UITextFieldDelegate, UITextViewDelegate, BSKeyboardControlsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;
@property (weak, nonatomic) IBOutlet UIView *movieContainerView;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoBT;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@end

@implementation CPAddVideoViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    NSArray *fields = @[self.titleTF, self.descriptionTV];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.moviePlayer stop];
}

- (void)setUpView
{
    self.navigationController.navigationBar.hidden = NO;
    self.titleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Título"];
    if (self.isEditable && !self.isEditableConveyorChache) {
        self.titleTF.text = self.video.name;
        self.descriptionTV.text = self.video.descriptionStr;
        self.addPhotoBT.hidden = YES;
        self.movieContainerView.hidden = NO;
        
        self.videoURL = [NSURL URLWithString:self.video.url];
        
        MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:self.videoURL];
        self.moviePlayer = moviePlayerController;
        moviePlayerController.view.frame = self.movieContainerView.bounds;
        [self.moviePlayer.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self.movieContainerView addSubview:moviePlayerController.view];
        [self.moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
        [self.moviePlayer play];
        
    } else if (self.isCache || self.isEditableConveyorChache) {
        self.titleTF.text = self.video.name;
        self.descriptionTV.text = self.video.descriptionStr;
        self.addPhotoBT.hidden = YES;
        self.movieContainerView.hidden = NO;
        self.videoURL = [NSURL fileURLWithPath:[CPFileUtils stringPathForVideoWithName:[NSString stringWithFormat:@"%i%i_%i", self.video.conveyorID, self.video.bucketID, self.video.createdAt]]];
        MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:self.videoURL];
        self.moviePlayer = moviePlayerController;
        moviePlayerController.view.frame = self.movieContainerView.bounds;
        [self.moviePlayer.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self.movieContainerView addSubview:moviePlayerController.view];
        [self.moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
        [self.moviePlayer play];
    } else {
        self.descriptionTV.text = [CPLanguajeUtils languajeSelectedForString:@"Descripción"];
        self.movieContainerView.hidden = YES;
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
    self.videoURL = info[UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoURL options:nil];
    
    NSTimeInterval durationInSeconds = 0.0;
    if (asset)
        durationInSeconds = CMTimeGetSeconds(asset.duration);
    NSLog(@"%f", durationInSeconds);
    if (durationInSeconds > 30.0) {
        [self showAlertWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al selecionar video"]
                      andMessage:[CPLanguajeUtils languajeSelectedForString:@"La duración maxima del video debe ser de 30 segundos"]];
    } else {
        self.addPhotoBT.hidden = YES;
        self.movieContainerView.hidden = NO;
        MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:self.videoURL];
        self.moviePlayer = moviePlayerController;
        moviePlayerController.view.frame = self.movieContainerView.bounds;
        [self.moviePlayer.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self.movieContainerView addSubview:moviePlayerController.view];
        [self.moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
        self.moviePlayer.shouldAutoplay = NO;
        [self.moviePlayer play];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
}

#pragma mark - IBAction Methods
- (IBAction)openPickerVideo
{
    [self.titleTF resignFirstResponder];
    [self.descriptionTV resignFirstResponder];
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Agregar video"]
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Capturar video"]
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                           NSLog(@"There isn't a camera on the simulator");
                                                       } else {
                                                           UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                           picker.delegate = self;
                                                           picker.allowsEditing = YES;
                                                           picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                           picker.mediaTypes = @[(NSString *)kUTTypeMovie];
                                                           [picker setVideoMaximumDuration:30];
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
                                                      picker.mediaTypes = @[(NSString *)kUTTypeMovie];
                                                      
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


- (IBAction)saveVideo
{
    if ([self.titleTF.text isEqualToString:@""]) {
        [self showAlertWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al guardar"]
                      andMessage:[CPLanguajeUtils languajeSelectedForString:@"Debe proporcionar un título"]];
    } else if (!self.videoURL) {
        [self showAlertWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al guardar"]
                      andMessage:[CPLanguajeUtils languajeSelectedForString:@"Es necesario seleccionar al menos 1 archivo de video"]];
    } else {
        if (self.isCacheConveyor) {
            NSMutableArray *draftsConveyor = [NSMutableArray array];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]) {
                draftsConveyor = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]] mutableCopy];
            }
            int createdAt = [CPDateUtils timeStampFromDate:[NSDate date]];
            [draftsConveyor addObject:[CPVideo videoWithName:self.titleTF.text
                                    descriptionVideo:self.descriptionTV.text
                                          conveyorID:self.conveyorID
                                            bucketID:self.bucketID
                                           createdAt:createdAt
                                           updatedAt:createdAt]];
            NSData *encodeConveyorsCacheArray = [NSKeyedArchiver archivedDataWithRootObject:draftsConveyor];
            [[NSUserDefaults standardUserDefaults] setObject:encodeConveyorsCacheArray forKey:@"draftsConveyorArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [CPFileUtils saveDataToUserForder:[NSData dataWithContentsOfURL:self.videoURL]
                                     withName:[NSString stringWithFormat:@"%i%i_%i", self.conveyorID, self.bucketID, createdAt]
                                     dataType:CPVideoFile];
            [self.navigationController popViewControllerAnimated:YES];
        } else if (self.isEditableConveyorChache) {
            NSMutableArray *drafts = [NSMutableArray array];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]) {
                drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]] mutableCopy];
            }
            int index = 0;
            for (id temp in drafts) {
                if ([temp isKindOfClass:[CPVideo class] ]) {
                    CPVideo *tmp = (CPVideo *)temp;
                    if (tmp.createdAt == self.video.createdAt) {
                        break;
                    }
                }
                index++;
            }
            [drafts replaceObjectAtIndex:index
                              withObject:[CPVideo videoWithName:self.titleTF.text
                                               descriptionVideo:self.descriptionTV.text
                                                     conveyorID:self.video.conveyorID
                                                       bucketID:self.video.bucketID
                                                      createdAt:self.video.createdAt
                                                      updatedAt:self.video.updatedAt]];
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
                [CPVideo saveVideoWithAuthenticationKey:[CPUser sharedUser].authKey
                                              videoData:[NSData dataWithContentsOfURL:self.videoURL]
                                                   name:self.titleTF.text
                                         descriptionVid:self.descriptionTV.text
                                             conveyorID:self.isCache ? self.video.conveyorID : self.conveyorID
                                               bucketID:self.isCache ? self.video.bucketID : self.bucketID
                                              createdAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                              updatedAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                      completionHandler:^(NSURLResponse *response, NSError *error, NSString *name) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [MRProgressOverlayView  dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                   animated:YES];
                                              if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error) {
                                                  if (self.isCache) {
                                                      UIAlertController *alertCache = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al subir el video"]
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
                                                                                                          if ([temp isKindOfClass:[CPVideo class] ]) {
                                                                                                              CPVideo *tmpVid = (CPVideo *)temp;
                                                                                                              if (tmpVid.createdAt == self.video.createdAt) {
                                                                                                                  break;
                                                                                                              }
                                                                                                          }
                                                                                                          index++;
                                                                                                      }
                                                                                                      [drafts replaceObjectAtIndex:index
                                                                                                                        withObject:[CPVideo videoWithName:self.titleTF.text
                                                                                                                                         descriptionVideo:self.descriptionTV.text
                                                                                                                                               conveyorID:self.video.conveyorID
                                                                                                                                                 bucketID:self.video.bucketID
                                                                                                                                                createdAt:self.video.createdAt
                                                                                                                                                updatedAt:self.video.updatedAt]];
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
                                                      UIAlertController *alertCache = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al subir el video"]
                                                                                                                          message:[CPLanguajeUtils languajeSelectedForString:@"¿Desea guardar el video en borradores?"]
                                                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                                                      UIAlertAction *yes = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Sí"]
                                                                                                    style:UIAlertActionStyleDefault
                                                                                                  handler:^(UIAlertAction *action) {
                                                                                                      NSMutableArray *drafts = [NSMutableArray array];
                                                                                                      if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]) {
                                                                                                          drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                                                                      }
                                                                                                      int createdAt = [CPDateUtils timeStampFromDate:[NSDate date]];
                                                                                                      [drafts addObject:[CPVideo videoWithName:self.titleTF.text
                                                                                                                              descriptionVideo:self.descriptionTV.text
                                                                                                                                    conveyorID:self.conveyorID
                                                                                                                                      bucketID:self.bucketID
                                                                                                                                     createdAt:createdAt
                                                                                                                                     updatedAt:createdAt]];
                                                                                                      NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                                                                                      [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsArray"];
                                                                                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                      [CPFileUtils saveDataToUserForder:[NSData dataWithContentsOfURL:self.videoURL]
                                                                                                                               withName:[NSString stringWithFormat:@"%i%i_%i", self.conveyorID, self.bucketID, createdAt]
                                                                                                                               dataType:CPVideoFile];
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
                                                  if (self.isCache) {
                                                      NSMutableArray *drafts = [NSMutableArray array];
                                                      drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                      
                                                      int index = 0;
                                                      for (id temp in drafts) {
                                                          if ([temp isKindOfClass:[CPVideo class] ]) {
                                                              CPVideo *tmpVideo = (CPVideo *)temp;
                                                              if (tmpVideo.createdAt == self.video.createdAt) {
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
                [CPVideo updateVideoWithAuthenticationKey:[CPUser sharedUser].authKey
                                                       ID:self.video.ID
                                                     name:self.titleTF.text
                                         descriptionVideo:self.descriptionTV.text
                                                      url:self.video.url
                                            thumbanailUrl:self.video.thumbnailUrl
                                               conveyorID:self.video.conveyorID
                                                 bucketID:self.video.bucketID
                                                createdAt:self.video.createdAt
                                                updatedAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                        completionHandler:^(BOOL success) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [MRProgressOverlayView  dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                     animated:YES];
                                                if (success) {
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                } else {
                                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al actualizar el video"]
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
