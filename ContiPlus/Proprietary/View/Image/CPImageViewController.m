//
//  CPImageViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/8/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPImageViewController.h"
#import "DejalActivityView.h"
#import "CPImage.h"
#import "CPLanguajeUtils.h"
#import "CPAddImageViewController.h"
#import "CPFileUtils.h"
#import "CPEnum.h"
#import "MRProgress.h"
#import "CPUser.h"

@interface CPImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLB;
@property (weak, nonatomic) IBOutlet UILabel *titleImageLB;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;
@property (nonatomic) BOOL isImageFullScreen;
@property (nonatomic) CGRect originalImageFrame;
@property (weak, nonatomic) IBOutlet UIButton *editBT;

@property (strong, nonatomic) UIImage *imageForView;

@property (weak, nonatomic) IBOutlet UILabel *eraseLB;
@property (weak, nonatomic) IBOutlet UIImageView *eraseIcon;
@property (weak, nonatomic) IBOutlet UIButton *eraseBT;
@end

@implementation CPImageViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    self.isImageFullScreen = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.imageView.transform = CGAffineTransformMakeRotation(0.0);
    self.isImageFullScreen = NO;
    if (self.isConveyorCache) {
        NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]] mutableCopy];
        for (CPObject *object in tempArray) {
            if ([object isKindOfClass:[CPImage class]]) {
                CPImage *img = (CPImage *)object;
                if (img.createdAt == self.cpImage.createdAt) {
                    self.cpImage = img;
                    break;
                }
            }
        }
    } else {
        NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"imagesArray"]] mutableCopy];
        for (CPImage *img in tempArray) {
            if (img.ID == self.cpImage.ID) {
                self.cpImage = img;
                break;
            }
        }
    }
    [self setUpView];
}

- (void)setUpView
{
    self.originalImageFrame = CGRectMake(0, 0, self.view.frame.size.width, self.imageView.frame.size.height);
    UITapGestureRecognizer *tapGestureImage = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(makeImageBig:)];
    tapGestureImage.numberOfTapsRequired = 1;
    tapGestureImage.cancelsTouchesInView = NO;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tapGestureImage];
    self.navigationController.navigationBar.hidden = YES;
    NSData *imgData = [CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", self.cpImage.conveyorID, self.cpImage.bucketID,self.cpImage.createdAt]
                                                     dataType:CPImageFile];
    if (imgData) {
        self.imageView.image = [UIImage imageWithData:imgData];
    } else {
        __block UIImage *image;
        [DejalKeyboardActivityView activityViewForView:self.imageView
                                             withLabel:@""];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:self.cpImage.url];
            __block NSData *imageData = nil;
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                imageData = [NSData dataWithContentsOfURL:url];
                image = [UIImage imageWithData:imageData];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [DejalKeyboardActivityView removeViewAnimated:YES];
                    if (image) {
                        self.imageView.image = image;
                        [CPFileUtils saveDataToUserForder:UIImageJPEGRepresentation(image, 1.0f)
                                                 withName:[NSString stringWithFormat:@"%i%i_%i", self.cpImage.conveyorID, self.cpImage.bucketID,self.cpImage.createdAt]
                                                 dataType:CPImageFile];
                    }
                    else {
                        self.imageView.image = [UIImage imageNamed:@"conveyorIcon"];
                    }
                });
            });
        });
    }
    self.serialNumberLB.text = self.serialNumber;
    self.titleImageLB.text = self.cpImage.name;
    self.descriptionTV.text = self.cpImage.descriptionStr;
    [self.editBT setTitle:[CPLanguajeUtils languajeSelectedForString:@"Editar"]
                 forState:UIControlStateNormal];
    if (self.cpImage.ID == self.coverImgID) {
        self.editBT.hidden = YES;
        self.eraseBT.hidden = YES;
        self.eraseIcon.hidden = YES;
        self.eraseLB.hidden = YES;
    }
}

#pragma mark - UITapGestureRecognizer Methods
- (void)makeImageBig:(UIGestureRecognizer *)sender
{
    if (!self.isImageFullScreen) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
                             self.imageView.frame = CGRectMake(0,
                                                               0,
                                                               self.view.frame.size.width,
                                                               self.view.frame.size.height);
                         }];
        self.isImageFullScreen = YES;
    } else {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.imageView.transform = CGAffineTransformMakeRotation(0.0);
                             self.imageView.frame = self.originalImageFrame;
                         }];
        self.isImageFullScreen = NO;
    }
}

#pragma mark - IBAction Methods
- (IBAction)eraseImage
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"¡ATENCIÓN!"]
                                                                             message:[CPLanguajeUtils languajeSelectedForString:@"Al eliminar la imagen no se podrá recuperar la información. ¿Desea continuar?"]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Sí"]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    if (self.isConveyorCache) {
                                                        NSMutableArray *drafts = [NSMutableArray array];
                                                        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]) {
                                                            drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]] mutableCopy];
                                                        }
                                                        int index = 0;
                                                        for (id temp in drafts) {
                                                            if ([temp isKindOfClass:[CPImage class] ]) {
                                                                CPImage *tmpImg = (CPImage *)temp;
                                                                if (tmpImg.createdAt == self.cpImage.createdAt) {
                                                                    break;
                                                                }
                                                            }
                                                            index++;
                                                        }
                                                        [drafts removeObjectAtIndex:index];
                                                        NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                                        [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsConveyorArray"];
                                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                                        [self.navigationController popViewControllerAnimated:YES];
                                                    } else {
                                                        [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                                                                            title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                                                                             mode:MRProgressOverlayViewModeIndeterminate
                                                                                         animated:YES];
                                                        [CPImage deleteImageWithWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                                   ID:self.cpImage.ID
                                                                                    completionHandler:^(BOOL success) {
                                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                                            [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                                                                animated:YES];
                                                                                            if (success) {
                                                                                                [self.navigationController popViewControllerAnimated:YES];
                                                                                            } else {
                                                                                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al borrar la imagen"]
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

- (IBAction)returnToPreviousView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditImageSegue"]) {
        CPAddImageViewController *addImageViewController = segue.destinationViewController;
        addImageViewController.image = self.cpImage;
        addImageViewController.isEditable = YES;
        addImageViewController.isCache = NO;
        addImageViewController.isCacheConveyor = NO;
        addImageViewController.isEditableConveyorChache = self.isConveyorCache;
    }
}

@end
