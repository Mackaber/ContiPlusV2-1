//
//  CPVideoViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/9/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPVideoViewController.h"
#import "DejalActivityView.h"
#import "CPVideo.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CPLanguajeUtils.h"
#import "CPAddVideoViewController.h"
#import "MRProgress.h"
#import "CPUser.h"
#import "CPFileUtils.h"

@interface CPVideoViewController ()
@property (weak, nonatomic) IBOutlet UIView *movieContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIButton *playBT;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLB;
@property (weak, nonatomic) IBOutlet UILabel *titleVideoLB;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UIButton *editBT;
@end

@implementation CPVideoViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (self.isConveyorCache) {
        NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]] mutableCopy];
        for (CPObject *object in tempArray) {
            if ([object isKindOfClass:[CPVideo class]]) {
                CPVideo *vid = (CPVideo *)object;
                if (vid.createdAt == self.cpVideo.createdAt) {
                    self.cpVideo = vid;
                    break;
                }
            }
        }
    } else {
        NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"videosArray"]] mutableCopy];
        for (CPVideo *vid in tempArray) {
            if (vid.ID == self.cpVideo.ID) {
                self.cpVideo = vid;
                break;
            }
        }
    }
    [self setUpView];
}

- (void)setUpView
{
    self.navigationController.navigationBar.hidden = YES;
    self.playBT.hidden = YES;
    __block UIImage *image;
    [DejalKeyboardActivityView activityViewForView:self.thumbnailImageView
                                         withLabel:@""];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:self.cpVideo.thumbnailUrl];
        __block NSData *imageData = nil;
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            imageData = [NSData dataWithContentsOfURL:url];
            image = [UIImage imageWithData:imageData];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [DejalKeyboardActivityView removeViewAnimated:YES];
                self.playBT.hidden = NO;
                if (image) {
                    self.thumbnailImageView.image = image;
                }
                else {
                    self.thumbnailImageView.image = [UIImage imageNamed:@""];
                }
            });
        });
    });
    self.serialNumberLB.text = self.serialNumber;
    self.titleVideoLB.text = self.cpVideo.name;
    self.descriptionTV.text = self.cpVideo.descriptionStr;
    [self.editBT setTitle:[CPLanguajeUtils languajeSelectedForString:@"Editar"]
                 forState:UIControlStateNormal];
}

#pragma mark - IBAction Methods
- (IBAction)playMoview:(UIButton *)sender
{
    if (self.isConveyorCache) {
        NSURL *videoURL = [NSURL fileURLWithPath:[CPFileUtils stringPathForVideoWithName:[NSString stringWithFormat:@"%i%i_%i", self.cpVideo.conveyorID, self.cpVideo.bucketID, self.cpVideo.createdAt]]];
        MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
        self.moviePlayer = moviePlayerController;
        moviePlayerController.view.frame = self.movieContainerView.bounds;
        [self.moviePlayer.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self.movieContainerView addSubview:moviePlayerController.view];
        [self.moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
        [self.moviePlayer play];
    } else {
        self.thumbnailImageView.hidden = YES;
        sender.hidden = YES;
        MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.cpVideo.url]];
        self.moviePlayer = moviePlayerController;
        moviePlayerController.view.frame = self.movieContainerView.bounds;
        [self.moviePlayer.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self.movieContainerView addSubview:moviePlayerController.view];
        [self.moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
        [DejalKeyboardActivityView activityViewForView:self.moviePlayer.view
                                             withLabel:@""];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeLoading)
                                                     name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                   object:nil];
        self.moviePlayer.shouldAutoplay = NO;
        [self.moviePlayer play];
    }
}
- (void)removeLoading
{
    [DejalKeyboardActivityView removeViewAnimated:YES];
}

- (IBAction)eraseVideo
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"¡ATENCIÓN!"]
                                                                             message:[CPLanguajeUtils languajeSelectedForString:@"Al eliminar el video no se podrá recuperar la información. ¿Desea continuar?"]
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
                                                            if ([temp isKindOfClass:[CPVideo class] ]) {
                                                                CPVideo *tmpVideo = (CPVideo *)temp;
                                                                if (tmpVideo.createdAt == self.cpVideo.createdAt) {
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
                                                        [CPVideo deleteVideoWithWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                                   ID:self.cpVideo.ID
                                                                                    completionHandler:^(BOOL success) {
                                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                                            [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                                                                animated:YES];
                                                                                            if (success) {
                                                                                                [self.navigationController popViewControllerAnimated:YES];
                                                                                            } else {
                                                                                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al borrar el video"]
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

- (IBAction)returnToPreviousController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditVideoSegue"]) {
        CPAddVideoViewController *addVideoViewController = segue.destinationViewController;
        addVideoViewController.video = self.cpVideo;
        addVideoViewController.isEditable = YES;
        addVideoViewController.isCache = NO;
        addVideoViewController.isEditableConveyorChache = self.isConveyorCache;
    }
}

@end
