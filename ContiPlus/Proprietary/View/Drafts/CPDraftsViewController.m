//
//  CPDraftsViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/12/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPDraftsViewController.h"
#import "CPLanguajeUtils.h"
#import "CPConveyor.h"
#import "CPImage.h"
#import "CPVideo.h"
#import "CPNote.h"
#import "SWTableViewCell.h"
#import "CPDateUtils.h"
#import "CPAddEditConveyorViewController.h"
#import "CPAddImageViewController.h"
#import "CPAddVideoViewController.h"
#import "CPAddNoteViewController.h"
#import "MRProgress.h"
#import "CPFileUtils.h"
#import "CPEnum.h"
#import "CPUser.h"
#import "CPConveyorInfoViewController.h"

@interface CPDraftsViewController ()
<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *generalArray;
@property (strong, nonatomic) id globalObject;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *uploadAllBT;
@end

@implementation CPDraftsViewController

#pragma mark - UIViewController Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self obtainData];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self obtainData];
    [self.tableView reloadData];
}

- (void)obtainData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]) {
        self.generalArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
    } else {
        self.generalArray = [NSMutableArray arrayWithArray:@[]];
    }
    [self.tableView reloadData];
}

- (void)setUpView
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0
                                                                           green:165.0/255.0
                                                                            blue:0.0
                                                                           alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = [CPLanguajeUtils languajeSelectedForString:@"Borradores"];
    [self.uploadAllBT setTitle:[CPLanguajeUtils languajeSelectedForString:@"Subir Todo"]];
    if (self.generalArray.count == 0) {
        self.uploadAllBT.enabled = NO;
    }
    self.tableView.backgroundColor = [UIColor colorWithRed:243.0/255.0
                                                     green:243.0/255.0
                                                      blue:243.0/255.0
                                                     alpha:1.0];
}

#pragma mark - UITableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.generalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier
                                  containingTableView:tableView
                                   leftUtilityButtons:nil
                                  rightUtilityButtons:[self rightButtons]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.delegate = self;
    }
    id object = self.generalArray[indexPath.row];
    NSString *titleCell;
    NSString *subTitleCell;
    UIImage *image;
    
    if ([object isKindOfClass:[CPConveyor class]]) {
        titleCell = ((CPConveyor *)object).serialNumber;
        subTitleCell = [NSString stringWithFormat:@"%@: %@", [CPLanguajeUtils languajeSelectedForString:@"Editado"], [CPDateUtils stringFromTimeStamp:@(((CPConveyor *)object).updatedAt)]];
        image = [UIImage imageNamed:@"conveyorIcon"];
        cell.rightUtilityButtons = [self rightButtonsConveyor];
    } else if ([object isKindOfClass:[CPImage class]]) {
        titleCell = ((CPImage *)object).name;
        subTitleCell = [NSString stringWithFormat:@"%@: %@", [CPLanguajeUtils languajeSelectedForString:@"Editado"], [CPDateUtils stringFromTimeStamp:@(((CPImage *)object).updatedAt)]];
        image = [UIImage imageNamed:@"photoIcon"];
    } else if ([object isKindOfClass:[CPVideo class]]) {
        titleCell = ((CPVideo *)object).name;
        subTitleCell = [NSString stringWithFormat:@"%@: %@", [CPLanguajeUtils languajeSelectedForString:@"Editado"], [CPDateUtils stringFromTimeStamp:@(((CPVideo *)object).updatedAt)]];
        image = [UIImage imageNamed:@"videoIcon"];
    } else if ([object isKindOfClass:[CPNote class]]) {
        titleCell = ((CPNote *)object).name;
        subTitleCell = [NSString stringWithFormat:@"%@: %@", [CPLanguajeUtils languajeSelectedForString:@"Editado"], [CPDateUtils stringFromTimeStamp:@(((CPNote *)object).updatedAt)]];
        image = [UIImage imageNamed:@"noteIcon"];
    }
    
    cell.textLabel.text = titleCell;
    cell.textLabel.textColor = [UIColor colorWithRed:112.0/255.0
                                               green:117.0/255.0
                                                blue:113.0/255.0
                                               alpha:1.0];
    cell.detailTextLabel.text = subTitleCell;
    cell.detailTextLabel.textColor = [UIColor colorWithRed:112.0/255.0
                                               green:117.0/255.0
                                                blue:113.0/255.0
                                               alpha:1.0];
    cell.imageView.image = image;
    
    return cell;
}

#pragma mark - TableView Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableView.isEditing)
        [tableView deselectRowAtIndexPath:indexPath
                                 animated:YES];
    self.globalObject = self.generalArray[indexPath.row];
    if ([self.globalObject isKindOfClass:[CPConveyor class]]) {
        [self performSegueWithIdentifier:@"ConveyorDraft"
                                  sender:self];
    } else if ([self.globalObject isKindOfClass:[CPImage class]]) {
        [self performSegueWithIdentifier:@"EditImageSegue"
                                  sender:self];
    } else if ([self.globalObject isKindOfClass:[CPVideo class]]) {
        [self performSegueWithIdentifier:@"EditVideoSegue"
                                  sender:self];
    } else if ([self.globalObject isKindOfClass:[CPNote class]]) {
        [self performSegueWithIdentifier:@"EditNoteSegue"
                                  sender:self];
    }
    
}

#pragma mark - SWTableViewCell Methods and Buttons
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:243.0/255.0
                                           green:243.0/255.0
                                            blue:243.0/255.0
                                           alpha:1.0];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (NSMutableArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:42.0/255.0
                                                                      green:175.0/255.0
                                                                       blue:41.0/255.0
                                                                      alpha:1.0]
                                                title:[CPLanguajeUtils languajeSelectedForString:@"Subir"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:251.0/255.0
                                                                      green:15.0/255.0
                                                                       blue:42.0/255.0
                                                                      alpha:1.0]
                                                title:[CPLanguajeUtils languajeSelectedForString:@"Borrar"]];
    
    return rightUtilityButtons;
}

- (NSMutableArray *)rightButtonsConveyor
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:42.0/255.0
                                                                      green:175.0/255.0
                                                                       blue:41.0/255.0
                                                                      alpha:1.0]
                                                title:[CPLanguajeUtils languajeSelectedForString:@"Subir"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:251.0/255.0
                                                                      green:15.0/255.0
                                                                       blue:42.0/255.0
                                                                      alpha:1.0]
                                                title:[CPLanguajeUtils languajeSelectedForString:@"Borrar"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:187.0/255.0
                                                                      green:187.0/255.0
                                                                       blue:193.0/255.0
                                                                      alpha:1.0]
                                                title:[CPLanguajeUtils languajeSelectedForString:@"Editar"]];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell
didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    id object = self.generalArray[indexPath.row];
    self.globalObject = object;
    switch (index) {
        case 0:
        {
            [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                                title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                                 mode:MRProgressOverlayViewModeIndeterminate
                                             animated:YES];
            if ([object isKindOfClass:[CPImage class]]) {
                CPImage *uploadImg = (CPImage *)object;
                [CPImage saveImageWithAuthenticationKey:[CPUser sharedUser].authKey
                                              imageData:[CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", uploadImg.conveyorID, uploadImg.bucketID, uploadImg.createdAt] dataType:CPImageFile]
                                                   name:uploadImg.name
                                         descriptionImg:uploadImg.descriptionStr
                                             conveyorID:uploadImg.conveyorID
                                               bucketID:uploadImg.bucketID
                                              createdAt:uploadImg.createdAt
                                              updatedAt:uploadImg.updatedAt
                                      completionHandler:^(NSURLResponse *response, NSError *error, NSString *name, int coverID) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                  animated:YES];
                                              if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error) {
                                                  UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al subir la imagen"]
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
                                              } else {
                                                  [self.generalArray removeObject:object];
                                                  NSData *encodeDraftsArray = [NSKeyedArchiver archivedDataWithRootObject:self.generalArray];
                                                  [[NSUserDefaults standardUserDefaults] setObject:encodeDraftsArray forKey:@"draftsArray"];
                                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                                  [self.tableView reloadData];
                                              }
                                          });
                                      }];
            } else if ([object isKindOfClass:[CPVideo class]]) {
                CPVideo *videoUpload = (CPVideo *)object;
                [CPVideo saveVideoWithAuthenticationKey:[CPUser sharedUser].authKey
                                              videoData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[CPFileUtils stringPathForVideoWithName:[NSString stringWithFormat:@"%i%i_%i", videoUpload.conveyorID, videoUpload.bucketID, videoUpload.createdAt]]]]
                                                   name:videoUpload.name
                                         descriptionVid:videoUpload.descriptionStr
                                             conveyorID:videoUpload.conveyorID
                                               bucketID:videoUpload.bucketID
                                              createdAt:videoUpload.createdAt
                                              updatedAt:videoUpload.updatedAt
                                      completionHandler:^(NSURLResponse *response, NSError *error, NSString *name) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                  animated:YES];
                                              if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error) {
                                                  UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al subir el video"]
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
                                              } else {
                                                  [self.generalArray removeObject:object];
                                                  NSData *encodeDraftsArray = [NSKeyedArchiver archivedDataWithRootObject:self.generalArray];
                                                  [[NSUserDefaults standardUserDefaults] setObject:encodeDraftsArray forKey:@"draftsArray"];
                                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                                  [self.tableView reloadData];
                                              }
                                          });
                                      }];
            } else if ([object isKindOfClass:[CPNote class]]) {
                CPNote *noteUpload = (CPNote *)object;
                [CPNote saveNoteWithAuthenticationKey:[CPUser sharedUser].authKey
                                                 name:noteUpload.name
                                      descriptionNote:noteUpload.descriptionStr
                                           conveyorID:noteUpload.conveyorID
                                             bucketID:noteUpload.bucketID
                                            createdAt:noteUpload.createdAt
                                            updatedAt:noteUpload.updatedAt
                                    completionHandler:^(BOOL success) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                animated:YES];
                                            if (success) {
                                                [self.generalArray removeObject:object];
                                                NSData *encodeDraftsArray = [NSKeyedArchiver archivedDataWithRootObject:self.generalArray];
                                                [[NSUserDefaults standardUserDefaults] setObject:encodeDraftsArray forKey:@"draftsArray"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                [self.tableView reloadData];
                                            } else {
                                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al subir la nota"]
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
            } else if ([object isKindOfClass:[CPConveyor class]]) {
                CPConveyor *conveyorUpload = (CPConveyor *)object;
                [CPConveyor saveConveyorWithAuthenticationKey:[CPUser sharedUser].authKey
                                                     clientID:conveyorUpload.clientID
                                                 serialNumber:conveyorUpload.serialNumber
                                                    profileID:conveyorUpload.profileID
                                         transCentersDistance:conveyorUpload.transCentersDistance
                                                transRPMMotor:conveyorUpload.transRPMMotor
                                               transElevation:conveyorUpload.transElevation
                                        transInclinationAngle:conveyorUpload.transInclinationAngle
                                                 transHPMotor:conveyorUpload.transHPMotor
                                                transCapacity:conveyorUpload.transCapacity
                                     transReducerRelationship:conveyorUpload.transReducerRelationship
                                                    transLoad:conveyorUpload.transLoad
                                                   tensorType:conveyorUpload.tensorType
                                        tensorEstimatedWeight:conveyorUpload.tensorEstimatedWeight
                                                 tensorCareer:conveyorUpload.tensorCareer
                                               matDescription:conveyorUpload.matDescription
                                                matTerronSize:conveyorUpload.matTerronSize
                                               matTemperature:conveyorUpload.matTemperature
                                                matHeightFall:conveyorUpload.matHeightFall
                                           matFinosPercentage:conveyorUpload.matFinosPercentage
                                         matLoadingConditions:conveyorUpload.matLoadingConditions
                                          matLoadingFrequency:conveyorUpload.matLoadingFrequency
                                              matGranularSize:conveyorUpload.matGranularSize
                                                   matDensity:conveyorUpload.matDensity
                                               matAggresivity:conveyorUpload.matAggresivity
                                          matMaterialConveyed:conveyorUpload.matMaterialConveyed
                                         matFeedingConditions:conveyorUpload.matFeedingConditions
                                                    bandWidth:conveyorUpload.bandWidth
                                                  bandTension:conveyorUpload.bandTension
                                        bandTopThicknessCover:conveyorUpload.bandTopThicknessCover
                                     bandBottomThicknessCover:conveyorUpload.bandBottomThicknessCover
                                                    bandSpeed:conveyorUpload.bandSpeed
                                         bandInstallationDate:conveyorUpload.bandInstallationDate
                                                    bandBrand:conveyorUpload.bandBrand
                                         bandTotalDevelopment:conveyorUpload.bandTotalDevelopment
                                                bandOperation:conveyorUpload.bandOperation
                                                  drivePulley:conveyorUpload.drivePulley
                                             drivePulleyWidth:conveyorUpload.drivePulleyWidth
                                                  coverPulley:conveyorUpload.coverPulley
                                             contactArcPulley:conveyorUpload.contactArcPulley
                                                   headPulley:conveyorUpload.headPulley
                                              headPulleyWidth:conveyorUpload.headPulleyWidth
                                                   tailPulley:conveyorUpload.tailPulley
                                              tailPulleyWidth:conveyorUpload.tailPulleyWidth
                                                contactPulley:conveyorUpload.contactPulley
                                           contactPulleyWidth:conveyorUpload.contactPulleyWidth
                                                   foldPulley:conveyorUpload.foldPulley
                                              foldPulleyWidth:conveyorUpload.foldPulleyWidth
                                                 tensorPulley:conveyorUpload.tensorPulley
                                            tensorPulleyWidth:conveyorUpload.tensorPulleyWidth
                                          additionalOnePulley:conveyorUpload.additionalOnePulley
                                     additionalOnePulleyWidth:conveyorUpload.additionalOnePulleyWidth
                                          additionalTwoPulley:conveyorUpload.additionalTwoPulley
                                     additionalTwoPulleyWidth:conveyorUpload.additionalTwoPulleyWidth
                                            rodImpactDiameter:conveyorUpload.rodImpactDiameter
                                               rodImpactAngle:conveyorUpload.rodImpactAngle
                                              rodLoadDiameter:conveyorUpload.rodLoadDiameter
                                                 rodLoadAngle:conveyorUpload.rodLoadAngle
                                            rodReturnDiameter:conveyorUpload.rodReturnDiameter
                                               rodReturnAngle:conveyorUpload.rodReturnAngle
                                                  rodLDCSpace:conveyorUpload.rodLDCSpace
                                                  rodLDRSpace:conveyorUpload.rodLDRSpace
                                             rodPartTroughing:conveyorUpload.rodPartTroughing
                                                 observations:conveyorUpload.observations
                                                   coverImgID:0
                                                    createdAt:conveyorUpload.createdAt
                                                    updatedAt:conveyorUpload.updatedAt
                                            completionHandler:^(BOOL success, int conveyorID) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    if (success) {
                                                        [self.generalArray removeObject:object];
                                                        NSData *encodeDraftsArray = [NSKeyedArchiver archivedDataWithRootObject:self.generalArray];
                                                        [[NSUserDefaults standardUserDefaults] setObject:encodeDraftsArray forKey:@"draftsArray"];
                                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                                        [self.tableView reloadData];
                                                        
                                                        NSMutableArray *draftsConveyor = [NSMutableArray array];
                                                        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]) {
                                                            draftsConveyor = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]] mutableCopy];
                                                        }
                                                        
                                                        for (CPObject *draft in draftsConveyor) {
                                                            if (draft.conveyorID == conveyorUpload.createdAt) {
                                                                if ([draft isKindOfClass:[CPImage class]]) {
                                                                    CPImage *image = (CPImage *)draft;
                                                                    [CPImage saveImageWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                                  imageData:[CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", image.conveyorID, image.bucketID, image.createdAt] dataType:CPImageFile]
                                                                                                       name:image.name
                                                                                             descriptionImg:image.descriptionStr
                                                                                                 conveyorID:conveyorID
                                                                                                   bucketID:0
                                                                                                  createdAt:image.createdAt
                                                                                                  updatedAt:image.updatedAt
                                                                                          completionHandler:^(NSURLResponse *response, NSError *error, NSString *name, int coverID) {
                                                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                  if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error) {
                                                                                                      if ([draft isKindOfClass:[CPImage class]]) {
                                                                                                          CPImage *image = (CPImage *)draft;
                                                                                                          NSMutableArray *drafts = [NSMutableArray array];
                                                                                                          if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]) {
                                                                                                              drafts = [[NSKeyedUnarchiver  unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                                                                          }
                                                                                                          [drafts addObject:[CPImage imageWithName:image.name
                                                                                                                                    descriptionImg:image.descriptionStr
                                                                                                                                        conveyorID:conveyorID
                                                                                                                                          bucketID:0
                                                                                                                                         createdAt:image.createdAt
                                                                                                                                         updatedAt:image.updatedAt]];
                                                                                                          NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                                                                                          [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsArray"];
                                                                                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                          [CPFileUtils saveDataToUserForder:[CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", image.conveyorID, image.bucketID, image.createdAt] dataType:CPImageFile]
                                                                                                                                   withName:[NSString stringWithFormat:@"%i%i_%i", conveyorID, 0, image.createdAt]
                                                                                                                                   dataType:CPImageFile];
                                                                                                      } else if ([draft isKindOfClass:[CPVideo class]]) {
                                                                                                          CPVideo *video = (CPVideo *)draft;
                                                                                                          NSMutableArray *drafts = [NSMutableArray array];
                                                                                                          if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]) {
                                                                                                              drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                                                                          }
                                                                                                          [drafts addObject:[CPVideo videoWithName:video.name
                                                                                                                                  descriptionVideo:video.descriptionStr
                                                                                                                                        conveyorID:conveyorID
                                                                                                                                          bucketID:0
                                                                                                                                         createdAt:video.createdAt
                                                                                                                                         updatedAt:video.updatedAt]];
                                                                                                          NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                                                                                          [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsArray"];
                                                                                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                          [CPFileUtils saveDataToUserForder:[CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", video.conveyorID, video.bucketID, video.createdAt] dataType:CPVideoFile]
                                                                                                                                   withName:[NSString stringWithFormat:@"%i%i_%i", conveyorID, 0, video.createdAt]
                                                                                                                                   dataType:CPVideoFile];
                                                                                                      }
                                                                                                      [self obtainData];
                                                                                                  } else
                                                                                                      NSLog(@"Success");
                                                                                              });
                                                                                          }];
                                                                } else if ([draft isKindOfClass:[CPVideo class]]) {
                                                                    CPVideo *video = (CPVideo *)draft;
                                                                    [CPVideo saveVideoWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                                  videoData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[CPFileUtils stringPathForVideoWithName:[NSString stringWithFormat:@"%i%i_%i", video.conveyorID, video.bucketID, video.createdAt]]]]
                                                                                                       name:video.name
                                                                                             descriptionVid:video.descriptionStr
                                                                                                 conveyorID:conveyorID
                                                                                                   bucketID:0
                                                                                                  createdAt:video.createdAt
                                                                                                  updatedAt:video.updatedAt
                                                                                          completionHandler:^(NSURLResponse *response, NSError *error, NSString *name) {
                                                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                  if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error) {
                                                                                                      if ([draft isKindOfClass:[CPImage class]]) {
                                                                                                          CPImage *image = (CPImage *)draft;
                                                                                                          NSMutableArray *drafts = [NSMutableArray array];
                                                                                                          if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]) {
                                                                                                              drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                                                                          }
                                                                                                          [drafts addObject:[CPImage imageWithName:image.name
                                                                                                                                    descriptionImg:image.descriptionStr
                                                                                                                                        conveyorID:conveyorID
                                                                                                                                          bucketID:0
                                                                                                                                         createdAt:image.createdAt
                                                                                                                                         updatedAt:image.updatedAt]];
                                                                                                          NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                                                                                          [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsArray"];
                                                                                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                          [CPFileUtils saveDataToUserForder:[CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", image.conveyorID, image.bucketID, image.createdAt] dataType:CPImageFile]
                                                                                                                                   withName:[NSString stringWithFormat:@"%i%i_%i", conveyorID, 0, image.createdAt]
                                                                                                                                   dataType:CPImageFile];
                                                                                                      } else if ([draft isKindOfClass:[CPVideo class]]) {
                                                                                                          CPVideo *video = (CPVideo *)draft;
                                                                                                          NSMutableArray *drafts = [NSMutableArray array];
                                                                                                          if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]) {
                                                                                                              drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                                                                          }
                                                                                                          [drafts addObject:[CPVideo videoWithName:video.name
                                                                                                                                  descriptionVideo:video.descriptionStr
                                                                                                                                        conveyorID:conveyorID
                                                                                                                                          bucketID:0
                                                                                                                                         createdAt:video.createdAt
                                                                                                                                         updatedAt:video.updatedAt]];
                                                                                                          NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                                                                                          [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsArray"];
                                                                                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                          [CPFileUtils saveDataToUserForder:[CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", video.conveyorID, video.bucketID, video.createdAt] dataType:CPVideoFile]
                                                                                                                                   withName:[NSString stringWithFormat:@"%i%i_%i", conveyorID, 0, video.createdAt]
                                                                                                                                   dataType:CPVideoFile];
                                                                                                      }
                                                                                                  }
                                                                                                  else
                                                                                                      NSLog(@"Success");
                                                                                              });
                                                                                          }];
                                                                }
                                                            }
                                                        }
                                                        
                                                        NSLog(@"%@", draftsConveyor);
                                                        
                                                        NSData *imgData = [CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", 0, 0, conveyorUpload.createdAt]
                                                                                                         dataType:CPImageFile];
                                                        if (imgData) {
                                                            [CPImage saveImageWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                          imageData:imgData
                                                                                               name:[CPLanguajeUtils languajeSelectedForString:@"Imagen Principal"]
                                                                                     descriptionImg:[CPLanguajeUtils languajeSelectedForString:@"Imagen Principal"]
                                                                                         conveyorID:conveyorID
                                                                                           bucketID:0
                                                                                          createdAt:conveyorUpload.createdAt
                                                                                          updatedAt:conveyorUpload.createdAt
                                                                                  completionHandler:^(NSURLResponse *response, NSError *error, NSString *name, int coverID) {
                                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                                          if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error) {
                                                                                              [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                                                                  animated:YES];
                                                                                          } else {
                                                                                              [CPFileUtils saveDataToUserForder:imgData
                                                                                                                       withName:name
                                                                                                                       dataType:CPImageFile];
                                                                                              [CPConveyor updateConveyorWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                                                                   conveyorID:conveyorID
                                                                                                                                     clientID:conveyorUpload.clientID
                                                                                                                                 serialNumber:conveyorUpload.serialNumber
                                                                                                                                    profileID:conveyorUpload.profileID
                                                                                                                         transCentersDistance:conveyorUpload.transCentersDistance
                                                                                                                                transRPMMotor:conveyorUpload.transRPMMotor
                                                                                                                               transElevation:conveyorUpload.transElevation
                                                                                                                        transInclinationAngle:conveyorUpload.transInclinationAngle
                                                                                                                                 transHPMotor:conveyorUpload.transHPMotor
                                                                                                                                transCapacity:conveyorUpload.transCapacity
                                                                                                                     transReducerRelationship:conveyorUpload.transReducerRelationship
                                                                                                                                    transLoad:conveyorUpload.transLoad
                                                                                                                                   tensorType:conveyorUpload.tensorType
                                                                                                                        tensorEstimatedWeight:conveyorUpload.tensorEstimatedWeight
                                                                                                                                 tensorCareer:conveyorUpload.tensorCareer
                                                                                                                               matDescription:conveyorUpload.matDescription
                                                                                                                                matTerronSize:conveyorUpload.matTerronSize
                                                                                                                               matTemperature:conveyorUpload.matTemperature
                                                                                                                                matHeightFall:conveyorUpload.matHeightFall
                                                                                                                           matFinosPercentage:conveyorUpload.matFinosPercentage
                                                                                                                         matLoadingConditions:conveyorUpload.matLoadingConditions
                                                                                                                          matLoadingFrequency:conveyorUpload.matLoadingFrequency
                                                                                                                              matGranularSize:conveyorUpload.matGranularSize
                                                                                                                                   matDensity:conveyorUpload.matDensity
                                                                                                                               matAggresivity:conveyorUpload.matAggresivity
                                                                                                                          matMaterialConveyed:conveyorUpload.matMaterialConveyed
                                                                                                                         matFeedingConditions:conveyorUpload.matFeedingConditions
                                                                                                                                    bandWidth:conveyorUpload.bandWidth
                                                                                                                                  bandTension:conveyorUpload.bandTension
                                                                                                                        bandTopThicknessCover:conveyorUpload.bandTopThicknessCover
                                                                                                                     bandBottomThicknessCover:conveyorUpload.bandBottomThicknessCover
                                                                                                                                    bandSpeed:conveyorUpload.bandSpeed
                                                                                                                         bandInstallationDate:conveyorUpload.bandInstallationDate
                                                                                                                                    bandBrand:conveyorUpload.bandBrand
                                                                                                                         bandTotalDevelopment:conveyorUpload.bandTotalDevelopment
                                                                                                                                bandOperation:conveyorUpload.bandOperation
                                                                                                                                  drivePulley:conveyorUpload.drivePulley
                                                                                                                             drivePulleyWidth:conveyorUpload.drivePulleyWidth
                                                                                                                                  coverPulley:conveyorUpload.coverPulley
                                                                                                                             contactArcPulley:conveyorUpload.contactArcPulley
                                                                                                                                   headPulley:conveyorUpload.headPulley
                                                                                                                              headPulleyWidth:conveyorUpload.headPulleyWidth
                                                                                                                                   tailPulley:conveyorUpload.tailPulley
                                                                                                                              tailPulleyWidth:conveyorUpload.tailPulleyWidth
                                                                                                                                contactPulley:conveyorUpload.contactPulley
                                                                                                                           contactPulleyWidth:conveyorUpload.contactPulleyWidth
                                                                                                                                   foldPulley:conveyorUpload.foldPulley
                                                                                                                              foldPulleyWidth:conveyorUpload.foldPulleyWidth
                                                                                                                                 tensorPulley:conveyorUpload.tensorPulley
                                                                                                                            tensorPulleyWidth:conveyorUpload.tensorPulleyWidth
                                                                                                                          additionalOnePulley:conveyorUpload.additionalOnePulley
                                                                                                                     additionalOnePulleyWidth:conveyorUpload.additionalOnePulleyWidth
                                                                                                                          additionalTwoPulley:conveyorUpload.additionalTwoPulley
                                                                                                                     additionalTwoPulleyWidth:conveyorUpload.additionalTwoPulleyWidth
                                                                                                                            rodImpactDiameter:conveyorUpload.rodImpactDiameter
                                                                                                                               rodImpactAngle:conveyorUpload.rodImpactAngle
                                                                                                                              rodLoadDiameter:conveyorUpload.rodLoadDiameter
                                                                                                                                 rodLoadAngle:conveyorUpload.rodLoadAngle
                                                                                                                            rodReturnDiameter:conveyorUpload.rodReturnDiameter
                                                                                                                               rodReturnAngle:conveyorUpload.rodReturnAngle
                                                                                                                                  rodLDCSpace:conveyorUpload.rodLDCSpace
                                                                                                                                  rodLDRSpace:conveyorUpload.rodLDRSpace
                                                                                                                             rodPartTroughing:conveyorUpload.rodPartTroughing
                                                                                                                                 observations:conveyorUpload.observations
                                                                                                                                   coverImgID:coverID
                                                                                                                                    createdAt:conveyorUpload.createdAt
                                                                                                                                    updatedAt:conveyorUpload.updatedAt
                                                                                                                            completionHandler:^(BOOL success) {
                                                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                                                    [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                                                                                                        animated:YES];
                                                                                                                                });
                                                                                                                            }];
                                                                                          }
                                                                                      });
                                                                                  }];
                                                        } else { // No imageData
                                                            [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                                animated:YES];
                                                        }
                                                    } else { // Success conveyor
                                                        [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                            animated:YES];
                                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al subir el transportador"]
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
            break;
        }
        case 1:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"¡ATENCIÓN!"]
                                                                           message:[CPLanguajeUtils languajeSelectedForString:@"Al eliminar el elemento no se podrá recuperar la información y todos los elementos asociados se perderán. ¿Desea continuar?"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *yes = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Si"]
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [alert dismissViewControllerAnimated:YES
                                                                                        completion:nil];
                                                              [self.generalArray removeObject:object];
                                                              NSData *encodeDraftsArray = [NSKeyedArchiver archivedDataWithRootObject:self.generalArray];
                                                              [[NSUserDefaults standardUserDefaults] setObject:encodeDraftsArray forKey:@"draftsArray"];
                                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                                              [self.tableView reloadData];
                                                          }];
            UIAlertAction *no = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"No"]
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               [alert dismissViewControllerAnimated:YES
                                                                                         completion:nil];
                                                           }];
            [alert addAction:yes];
            [alert addAction:no];
            
            [self presentViewController:alert
                               animated:YES
                             completion:nil];
            break;
        }
        case 2:
        {
            [self performSegueWithIdentifier:@"EditConveyorSegue"
                                      sender:self];
            break;
        }
        default:
            break;
    }
}

#pragma mark - IBAction Methods
- (IBAction)uploadAll:(id)sender
{
    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                        title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                         mode:MRProgressOverlayViewModeIndeterminate
                                     animated:YES];
    __block int count = 0;
    int arrayCount = (int)self.generalArray.count;
    for (id object in self.generalArray) {
        if ([object isKindOfClass:[CPImage class]]) {
            CPImage *uploadImg = (CPImage *)object;
            [CPImage saveImageWithAuthenticationKey:[CPUser sharedUser].authKey
                                          imageData:[CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", uploadImg.conveyorID, uploadImg.bucketID, uploadImg.createdAt] dataType:CPImageFile]
                                               name:uploadImg.name
                                     descriptionImg:uploadImg.descriptionStr
                                         conveyorID:uploadImg.conveyorID
                                           bucketID:uploadImg.bucketID
                                          createdAt:uploadImg.createdAt
                                          updatedAt:uploadImg.updatedAt
                                  completionHandler:^(NSURLResponse *response, NSError *error, NSString *name, int coverID) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error) {
                                              count++;
                                              if (count == arrayCount) {
                                                  [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                      animated:YES];
                                                  [self showErrorAlert];
                                              }
                                          } else {
                                              [self.generalArray removeObject:object];
                                              NSData *encodeDraftsArray = [NSKeyedArchiver archivedDataWithRootObject:self.generalArray];
                                              [[NSUserDefaults standardUserDefaults] setObject:encodeDraftsArray forKey:@"draftsArray"];
                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                              [self.tableView reloadData];
                                              count++;
                                              if (count == arrayCount) {
                                                  [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                      animated:YES];
                                              }
                                          }
                                      });
                                  }];
        } else if ([object isKindOfClass:[CPVideo class]]) {
            CPVideo *videoUpload = (CPVideo *)object;
            [CPVideo saveVideoWithAuthenticationKey:[CPUser sharedUser].authKey
                                          videoData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[CPFileUtils stringPathForVideoWithName:[NSString stringWithFormat:@"%i%i_%i", videoUpload.conveyorID, videoUpload.bucketID, videoUpload.createdAt]]]]
                                               name:videoUpload.name
                                     descriptionVid:videoUpload.descriptionStr
                                         conveyorID:videoUpload.conveyorID
                                           bucketID:videoUpload.bucketID
                                          createdAt:videoUpload.createdAt
                                          updatedAt:videoUpload.updatedAt
                                  completionHandler:^(NSURLResponse *response, NSError *error, NSString *name) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                              animated:YES];
                                          if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error) {
                                              count++;
                                              if (count == arrayCount) {
                                                  [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                      animated:YES];
                                                  [self showErrorAlert];
                                              }
                                          } else {
                                              [self.generalArray removeObject:object];
                                              NSData *encodeDraftsArray = [NSKeyedArchiver archivedDataWithRootObject:self.generalArray];
                                              [[NSUserDefaults standardUserDefaults] setObject:encodeDraftsArray forKey:@"draftsArray"];
                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                              [self.tableView reloadData];
                                              count++;
                                              if (count == arrayCount) {
                                                  [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                      animated:YES];
                                              }
                                          }
                                      });
                                  }];
        } else if ([object isKindOfClass:[CPNote class]]) {
            CPNote *noteUpload = (CPNote *)object;
            [CPNote saveNoteWithAuthenticationKey:[CPUser sharedUser].authKey
                                             name:noteUpload.name
                                  descriptionNote:noteUpload.descriptionStr
                                       conveyorID:noteUpload.conveyorID
                                         bucketID:noteUpload.bucketID
                                        createdAt:noteUpload.createdAt
                                        updatedAt:noteUpload.updatedAt
                                completionHandler:^(BOOL success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (success) {
                                            [self.generalArray removeObject:object];
                                            NSData *encodeDraftsArray = [NSKeyedArchiver archivedDataWithRootObject:self.generalArray];
                                            [[NSUserDefaults standardUserDefaults] setObject:encodeDraftsArray forKey:@"draftsArray"];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                            [self.tableView reloadData];
                                            count++;
                                            if (count == arrayCount) {
                                                [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                    animated:YES];
                                            }
                                        } else {
                                            count++;
                                            if (count == arrayCount) {
                                                [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                    animated:YES];
                                                [self showErrorAlert];
                                            }
                                        }
                                    });
                                }];
        } else if ([object isKindOfClass:[CPConveyor class]]) {
            CPConveyor *conveyorUpload = (CPConveyor *)object;
            [CPConveyor saveConveyorWithAuthenticationKey:[CPUser sharedUser].authKey
                                                 clientID:conveyorUpload.clientID
                                             serialNumber:conveyorUpload.serialNumber
                                                profileID:conveyorUpload.profileID
                                     transCentersDistance:conveyorUpload.transCentersDistance
                                            transRPMMotor:conveyorUpload.transRPMMotor
                                           transElevation:conveyorUpload.transElevation
                                    transInclinationAngle:conveyorUpload.transInclinationAngle
                                             transHPMotor:conveyorUpload.transHPMotor
                                            transCapacity:conveyorUpload.transCapacity
                                 transReducerRelationship:conveyorUpload.transReducerRelationship
                                                transLoad:conveyorUpload.transLoad
                                               tensorType:conveyorUpload.tensorType
                                    tensorEstimatedWeight:conveyorUpload.tensorEstimatedWeight
                                             tensorCareer:conveyorUpload.tensorCareer
                                           matDescription:conveyorUpload.matDescription
                                            matTerronSize:conveyorUpload.matTerronSize
                                           matTemperature:conveyorUpload.matTemperature
                                            matHeightFall:conveyorUpload.matHeightFall
                                       matFinosPercentage:conveyorUpload.matFinosPercentage
                                     matLoadingConditions:conveyorUpload.matLoadingConditions
                                      matLoadingFrequency:conveyorUpload.matLoadingFrequency
                                          matGranularSize:conveyorUpload.matGranularSize
                                               matDensity:conveyorUpload.matDensity
                                           matAggresivity:conveyorUpload.matAggresivity
                                      matMaterialConveyed:conveyorUpload.matMaterialConveyed
                                     matFeedingConditions:conveyorUpload.matFeedingConditions
                                                bandWidth:conveyorUpload.bandWidth
                                              bandTension:conveyorUpload.bandTension
                                    bandTopThicknessCover:conveyorUpload.bandTopThicknessCover
                                 bandBottomThicknessCover:conveyorUpload.bandBottomThicknessCover
                                                bandSpeed:conveyorUpload.bandSpeed
                                     bandInstallationDate:conveyorUpload.bandInstallationDate
                                                bandBrand:conveyorUpload.bandBrand
                                     bandTotalDevelopment:conveyorUpload.bandTotalDevelopment
                                            bandOperation:conveyorUpload.bandOperation
                                              drivePulley:conveyorUpload.drivePulley
                                         drivePulleyWidth:conveyorUpload.drivePulleyWidth
                                              coverPulley:conveyorUpload.coverPulley
                                         contactArcPulley:conveyorUpload.contactArcPulley
                                               headPulley:conveyorUpload.headPulley
                                          headPulleyWidth:conveyorUpload.headPulleyWidth
                                               tailPulley:conveyorUpload.tailPulley
                                          tailPulleyWidth:conveyorUpload.tailPulleyWidth
                                            contactPulley:conveyorUpload.contactPulley
                                       contactPulleyWidth:conveyorUpload.contactPulleyWidth
                                               foldPulley:conveyorUpload.foldPulley
                                          foldPulleyWidth:conveyorUpload.foldPulleyWidth
                                             tensorPulley:conveyorUpload.tensorPulley
                                        tensorPulleyWidth:conveyorUpload.tensorPulleyWidth
                                      additionalOnePulley:conveyorUpload.additionalOnePulley
                                 additionalOnePulleyWidth:conveyorUpload.additionalOnePulleyWidth
                                      additionalTwoPulley:conveyorUpload.additionalTwoPulley
                                 additionalTwoPulleyWidth:conveyorUpload.additionalTwoPulleyWidth
                                        rodImpactDiameter:conveyorUpload.rodImpactDiameter
                                           rodImpactAngle:conveyorUpload.rodImpactAngle
                                          rodLoadDiameter:conveyorUpload.rodLoadDiameter
                                             rodLoadAngle:conveyorUpload.rodLoadAngle
                                        rodReturnDiameter:conveyorUpload.rodReturnDiameter
                                           rodReturnAngle:conveyorUpload.rodReturnAngle
                                              rodLDCSpace:conveyorUpload.rodLDCSpace
                                              rodLDRSpace:conveyorUpload.rodLDRSpace
                                         rodPartTroughing:conveyorUpload.rodPartTroughing
                                             observations:conveyorUpload.observations
                                               coverImgID:0
                                                createdAt:conveyorUpload.createdAt
                                                updatedAt:conveyorUpload.updatedAt
                                        completionHandler:^(BOOL success, int conveyorID) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (success) {
                                                    
                                                    NSMutableArray *draftsConveyor = [NSMutableArray array];
                                                    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]) {
                                                        draftsConveyor = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]] mutableCopy];
                                                    }
                                                    
                                                    for (CPObject *draft in draftsConveyor) {
                                                        if (draft.conveyorID == conveyorUpload.createdAt) {
                                                            if ([draft isKindOfClass:[CPImage class]]) {
                                                                CPImage *image = (CPImage *)draft;
                                                                [CPImage saveImageWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                              imageData:[CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", image.conveyorID, image.bucketID, image.createdAt] dataType:CPImageFile]
                                                                                                   name:image.name
                                                                                         descriptionImg:image.descriptionStr
                                                                                             conveyorID:conveyorID
                                                                                               bucketID:0
                                                                                              createdAt:image.createdAt
                                                                                              updatedAt:image.updatedAt
                                                                                      completionHandler:^(NSURLResponse *response, NSError *error, NSString *name, int coverID) {
                                                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                                                              if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error) {
                                                                                                  if ([draft isKindOfClass:[CPImage class]]) {
                                                                                                      CPImage *image = (CPImage *)draft;
                                                                                                      NSMutableArray *drafts = [NSMutableArray array];
                                                                                                      if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]) {
                                                                                                          drafts = [[NSKeyedUnarchiver  unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                                                                      }
                                                                                                      [drafts addObject:[CPImage imageWithName:image.name
                                                                                                                                descriptionImg:image.descriptionStr
                                                                                                                                    conveyorID:conveyorID
                                                                                                                                      bucketID:0
                                                                                                                                     createdAt:image.createdAt
                                                                                                                                     updatedAt:image.updatedAt]];
                                                                                                      NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                                                                                      [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsArray"];
                                                                                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                      [CPFileUtils saveDataToUserForder:[CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", image.conveyorID, image.bucketID, image.createdAt] dataType:CPImageFile]
                                                                                                                               withName:[NSString stringWithFormat:@"%i%i_%i", conveyorID, 0, image.createdAt]
                                                                                                                               dataType:CPImageFile];
                                                                                                  } else if ([draft isKindOfClass:[CPVideo class]]) {
                                                                                                      CPVideo *video = (CPVideo *)draft;
                                                                                                      NSMutableArray *drafts = [NSMutableArray array];
                                                                                                      if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]) {
                                                                                                          drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                                                                      }
                                                                                                      [drafts addObject:[CPVideo videoWithName:video.name
                                                                                                                              descriptionVideo:video.descriptionStr
                                                                                                                                    conveyorID:conveyorID
                                                                                                                                      bucketID:0
                                                                                                                                     createdAt:video.createdAt
                                                                                                                                     updatedAt:video.updatedAt]];
                                                                                                      NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                                                                                      [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsArray"];
                                                                                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                      [CPFileUtils saveDataToUserForder:[CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", video.conveyorID, video.bucketID, video.createdAt] dataType:CPVideoFile]
                                                                                                                               withName:[NSString stringWithFormat:@"%i%i_%i", conveyorID, 0, video.createdAt]
                                                                                                                               dataType:CPVideoFile];
                                                                                                  }
                                                                                                  [self obtainData];
                                                                                              } else
                                                                                                  NSLog(@"Success");
                                                                                          });
                                                                                      }];
                                                            } else if ([draft isKindOfClass:[CPVideo class]]) {
                                                                CPVideo *video = (CPVideo *)draft;
                                                                [CPVideo saveVideoWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                              videoData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[CPFileUtils stringPathForVideoWithName:[NSString stringWithFormat:@"%i%i_%i", video.conveyorID, video.bucketID, video.createdAt]]]]
                                                                                                   name:video.name
                                                                                         descriptionVid:video.descriptionStr
                                                                                             conveyorID:conveyorID
                                                                                               bucketID:0
                                                                                              createdAt:video.createdAt
                                                                                              updatedAt:video.updatedAt
                                                                                      completionHandler:^(NSURLResponse *response, NSError *error, NSString *name) {
                                                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                                                              if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error) {
                                                                                                  if ([draft isKindOfClass:[CPImage class]]) {
                                                                                                      CPImage *image = (CPImage *)draft;
                                                                                                      NSMutableArray *drafts = [NSMutableArray array];
                                                                                                      if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]) {
                                                                                                          drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                                                                      }
                                                                                                      [drafts addObject:[CPImage imageWithName:image.name
                                                                                                                                descriptionImg:image.descriptionStr
                                                                                                                                    conveyorID:conveyorID
                                                                                                                                      bucketID:0
                                                                                                                                     createdAt:image.createdAt
                                                                                                                                     updatedAt:image.updatedAt]];
                                                                                                      NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                                                                                      [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsArray"];
                                                                                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                      [CPFileUtils saveDataToUserForder:[CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", image.conveyorID, image.bucketID, image.createdAt] dataType:CPImageFile]
                                                                                                                               withName:[NSString stringWithFormat:@"%i%i_%i", conveyorID, 0, image.createdAt]
                                                                                                                               dataType:CPImageFile];
                                                                                                  } else if ([draft isKindOfClass:[CPVideo class]]) {
                                                                                                      CPVideo *video = (CPVideo *)draft;
                                                                                                      NSMutableArray *drafts = [NSMutableArray array];
                                                                                                      if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]) {
                                                                                                          drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                                                                      }
                                                                                                      [drafts addObject:[CPVideo videoWithName:video.name
                                                                                                                              descriptionVideo:video.descriptionStr
                                                                                                                                    conveyorID:conveyorID
                                                                                                                                      bucketID:0
                                                                                                                                     createdAt:video.createdAt
                                                                                                                                     updatedAt:video.updatedAt]];
                                                                                                      NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                                                                                      [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsArray"];
                                                                                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                      [CPFileUtils saveDataToUserForder:[CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", video.conveyorID, video.bucketID, video.createdAt] dataType:CPVideoFile]
                                                                                                                               withName:[NSString stringWithFormat:@"%i%i_%i", conveyorID, 0, video.createdAt]
                                                                                                                               dataType:CPVideoFile];
                                                                                                  }
                                                                                              }
                                                                                              else
                                                                                                  NSLog(@"Success");
                                                                                          });
                                                                                      }];
                                                            }
                                                        }
                                                    }
                                                    
                                                    NSData *imgData = [CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", 0, 0, conveyorUpload.createdAt]
                                                                                                     dataType:CPImageFile];
                                                    if (imgData) {
                                                        [CPImage saveImageWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                      imageData:imgData
                                                                                           name:[CPLanguajeUtils languajeSelectedForString:@"Imagen Principal"]
                                                                                 descriptionImg:[CPLanguajeUtils languajeSelectedForString:@"Imagen Principal"]
                                                                                     conveyorID:conveyorID
                                                                                       bucketID:0
                                                                                      createdAt:conveyorUpload.createdAt
                                                                                      updatedAt:conveyorUpload.createdAt
                                                                              completionHandler:^(NSURLResponse *response, NSError *error, NSString *name, int coverID) {
                                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                                      if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error) {
                                                                                          
                                                                                      } else {
                                                                                          [CPFileUtils saveDataToUserForder:imgData
                                                                                                                   withName:name
                                                                                                                   dataType:CPImageFile];
                                                                                          [CPConveyor updateConveyorWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                                                               conveyorID:conveyorID
                                                                                                                                 clientID:conveyorUpload.clientID
                                                                                                                             serialNumber:conveyorUpload.serialNumber
                                                                                                                                profileID:conveyorUpload.profileID
                                                                                                                     transCentersDistance:conveyorUpload.transCentersDistance
                                                                                                                            transRPMMotor:conveyorUpload.transRPMMotor
                                                                                                                           transElevation:conveyorUpload.transElevation
                                                                                                                    transInclinationAngle:conveyorUpload.transInclinationAngle
                                                                                                                             transHPMotor:conveyorUpload.transHPMotor
                                                                                                                            transCapacity:conveyorUpload.transCapacity
                                                                                                                 transReducerRelationship:conveyorUpload.transReducerRelationship
                                                                                                                                transLoad:conveyorUpload.transLoad
                                                                                                                               tensorType:conveyorUpload.tensorType
                                                                                                                    tensorEstimatedWeight:conveyorUpload.tensorEstimatedWeight
                                                                                                                             tensorCareer:conveyorUpload.tensorCareer
                                                                                                                           matDescription:conveyorUpload.matDescription
                                                                                                                            matTerronSize:conveyorUpload.matTerronSize
                                                                                                                           matTemperature:conveyorUpload.matTemperature
                                                                                                                            matHeightFall:conveyorUpload.matHeightFall
                                                                                                                       matFinosPercentage:conveyorUpload.matFinosPercentage
                                                                                                                     matLoadingConditions:conveyorUpload.matLoadingConditions
                                                                                                                      matLoadingFrequency:conveyorUpload.matLoadingFrequency
                                                                                                                          matGranularSize:conveyorUpload.matGranularSize
                                                                                                                               matDensity:conveyorUpload.matDensity
                                                                                                                           matAggresivity:conveyorUpload.matAggresivity
                                                                                                                      matMaterialConveyed:conveyorUpload.matMaterialConveyed
                                                                                                                     matFeedingConditions:conveyorUpload.matFeedingConditions
                                                                                                                                bandWidth:conveyorUpload.bandWidth
                                                                                                                              bandTension:conveyorUpload.bandTension
                                                                                                                    bandTopThicknessCover:conveyorUpload.bandTopThicknessCover
                                                                                                                 bandBottomThicknessCover:conveyorUpload.bandBottomThicknessCover
                                                                                                                                bandSpeed:conveyorUpload.bandSpeed
                                                                                                                     bandInstallationDate:conveyorUpload.bandInstallationDate
                                                                                                                                bandBrand:conveyorUpload.bandBrand
                                                                                                                     bandTotalDevelopment:conveyorUpload.bandTotalDevelopment
                                                                                                                            bandOperation:conveyorUpload.bandOperation
                                                                                                                              drivePulley:conveyorUpload.drivePulley
                                                                                                                         drivePulleyWidth:conveyorUpload.drivePulleyWidth
                                                                                                                              coverPulley:conveyorUpload.coverPulley
                                                                                                                         contactArcPulley:conveyorUpload.contactArcPulley
                                                                                                                               headPulley:conveyorUpload.headPulley
                                                                                                                          headPulleyWidth:conveyorUpload.headPulleyWidth
                                                                                                                               tailPulley:conveyorUpload.tailPulley
                                                                                                                          tailPulleyWidth:conveyorUpload.tailPulleyWidth
                                                                                                                            contactPulley:conveyorUpload.contactPulley
                                                                                                                       contactPulleyWidth:conveyorUpload.contactPulleyWidth
                                                                                                                               foldPulley:conveyorUpload.foldPulley
                                                                                                                          foldPulleyWidth:conveyorUpload.foldPulleyWidth
                                                                                                                             tensorPulley:conveyorUpload.tensorPulley
                                                                                                                        tensorPulleyWidth:conveyorUpload.tensorPulleyWidth
                                                                                                                      additionalOnePulley:conveyorUpload.additionalOnePulley
                                                                                                                 additionalOnePulleyWidth:conveyorUpload.additionalOnePulleyWidth
                                                                                                                      additionalTwoPulley:conveyorUpload.additionalTwoPulley
                                                                                                                 additionalTwoPulleyWidth:conveyorUpload.additionalTwoPulleyWidth
                                                                                                                        rodImpactDiameter:conveyorUpload.rodImpactDiameter
                                                                                                                           rodImpactAngle:conveyorUpload.rodImpactAngle
                                                                                                                          rodLoadDiameter:conveyorUpload.rodLoadDiameter
                                                                                                                             rodLoadAngle:conveyorUpload.rodLoadAngle
                                                                                                                        rodReturnDiameter:conveyorUpload.rodReturnDiameter
                                                                                                                           rodReturnAngle:conveyorUpload.rodReturnAngle
                                                                                                                              rodLDCSpace:conveyorUpload.rodLDCSpace
                                                                                                                              rodLDRSpace:conveyorUpload.rodLDRSpace
                                                                                                                         rodPartTroughing:conveyorUpload.rodPartTroughing
                                                                                                                             observations:conveyorUpload.observations
                                                                                                                               coverImgID:coverID
                                                                                                                                createdAt:conveyorUpload.createdAt
                                                                                                                                updatedAt:conveyorUpload.updatedAt
                                                                                                                        completionHandler:^(BOOL success) {
                                                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                                            });
                                                                                                                        }];
                                                                                      }
                                                                                  });
                                                                              }];
                                                    }
                                                    [self.generalArray removeObject:object];
                                                    NSData *encodeDraftsArray = [NSKeyedArchiver archivedDataWithRootObject:self.generalArray];
                                                    [[NSUserDefaults standardUserDefaults] setObject:encodeDraftsArray forKey:@"draftsArray"];
                                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                                    [self.tableView reloadData];
                                                    count++;
                                                    if (count == arrayCount) {
                                                        [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                            animated:YES];
                                                    }
                                                } else { // Success conveyor
                                                    count++;
                                                    if (count == arrayCount) {
                                                        [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                            animated:YES];
                                                        [self showErrorAlert];
                                                    }
                                                }
                                            });
                                        }];
        }
    }
}

#pragma mark - AlertView General
- (void)showErrorAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al subir los elementos"]
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

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditConveyorSegue"]) {
        CPAddEditConveyorViewController *addEditConveyorViewController = segue.destinationViewController;
        addEditConveyorViewController.conveyor = (CPConveyor *)self.globalObject;
        addEditConveyorViewController.isEditable = NO;
        addEditConveyorViewController.isCache = YES;
    } else if ([segue.identifier isEqualToString:@"EditImageSegue"]) {
        CPAddImageViewController *addImageViewController = segue.destinationViewController;
        addImageViewController.image = (CPImage *)self.globalObject;
        addImageViewController.isEditable = NO;
        addImageViewController.isCache = YES;
    } else if ([segue.identifier isEqualToString:@"EditVideoSegue"]) {
        CPAddVideoViewController *addVideoController = segue.destinationViewController;
        addVideoController.video = (CPVideo *)self.globalObject;
        addVideoController.isEditable = NO;
        addVideoController.isCache = YES;
    } else if ([segue.identifier isEqualToString:@"EditNoteSegue"]) {
        CPAddNoteViewController *addNoteViewController = segue.destinationViewController;
        addNoteViewController.note = (CPNote *)self.globalObject;
        addNoteViewController.isCache = YES;
    } else if ([segue.identifier isEqualToString:@"ConveyorDraft"]) {
        CPConveyorInfoViewController *conveyorInfoViewController = segue.destinationViewController;
        conveyorInfoViewController.conveyor = (CPConveyor *)self.globalObject;
    }
}

@end
