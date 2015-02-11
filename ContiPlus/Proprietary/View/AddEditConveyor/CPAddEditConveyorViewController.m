//
//  CPAddEditConveyorViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/29/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPAddEditConveyorViewController.h"
#import "CPDetailsViewController.h"
#import "CPConveyorViewController.h"
#import "CPTensorTypeViewController.h"
#import "CPMaterialViewController.h"
#import "CPActualBeltViewController.h"
#import "CPPulleysViewController.h"
#import "CPIdlersViewController.h"
#import "CPRemarksViewController.h"
#import "CPDateUtils.h"
#import "CPTensorTypeArray.h"
#import "CPMaterialArray.h"
#import "CPLanguajeUtils.h"
#import "CPActualBeltArray.h"
#import "CPIdlersArray.h"
#import "DejalActivityView.h"
#import "CPFileUtils.h"
#import "CPImage.h"
#import "MRProgress.h"
#import "CPFileUtils.h"
#import "CPContactArcArray.h"
#import "CPUser.h"
#import "CPVideo.h"
#import "CPImage.h"

static NSString *CPDismissAddEditViewControllerNotification = @"CPDismissAddEditViewControllerNotification";
static NSString *CPSaveInfoInAddEditViewControllerNotification = @"CPSaveInfoInAddEditViewControllerNotification";

@interface CPAddEditConveyorViewController ()
<DDScrollViewDataSource>
@property (strong, nonatomic) NSMutableArray *viewControllerArray;
@property (strong, nonatomic) CPDetailsViewController *detailsViewController;
@property (strong, nonatomic) CPConveyorViewController *conveyorViewController;
@property (strong, nonatomic) CPTensorTypeViewController *tensorTypeViewController;
@property (strong, nonatomic) CPMaterialViewController *materialViewController;
@property (strong, nonatomic) CPActualBeltViewController *actualBeltViewController;
@property (strong, nonatomic) CPPulleysViewController *pulleysViewController;
@property (strong, nonatomic) CPIdlersViewController *idlersViewController;
@property (strong, nonatomic) CPRemarksViewController *remarksViewController;

@property (nonatomic) int coverImgID;
@property (nonatomic) int newConveyorID;
@end

@implementation CPAddEditConveyorViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    self.dataSource = self;
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissViewSelf)
                                                 name:CPDismissAddEditViewControllerNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveInfo)
                                                 name:CPSaveInfoInAddEditViewControllerNotification
                                               object:nil];
    self.coverImgID = 0;
    if (self.isEditable || self.isCache) {
        // 1
        self.detailsViewController.numberTF.text = self.conveyor.serialNumber;
        self.detailsViewController.profileID = [self.conveyor.profileID intValue];
        self.detailsViewController.profileImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"profile_%@", self.conveyor.profileID]];
        [self.detailsViewController.profileBT setTitle:@""
                                              forState:UIControlStateNormal];
        if (self.isCache || self.conveyor.coverImgID == 0) {
            NSData *imgData = [CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", 0, 0, self.conveyor.createdAt]
                                                             dataType:CPImageFile];
            if (imgData) {
                self.detailsViewController.photoBT.hidden = YES;
                self.detailsViewController.imageView.image = [UIImage imageWithData:imgData];
            }
        } else if (self.conveyor.coverImgID != 0) {
            self.detailsViewController.photoBT.hidden = YES;
            NSMutableArray *imagesArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"imagesArray"]] mutableCopy];
            CPImage *coverImage;
            for (CPImage *image in imagesArray) {
                if (self.conveyor.coverImgID == image.ID) {
                    coverImage = image;
                    break;
                }
            }
            NSData *imgData = [CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", self.conveyor.ID, coverImage.bucketID, coverImage.createdAt]
                                                             dataType:CPImageFile];
            if (imgData) {
                self.detailsViewController.imageView.image = [UIImage imageWithData:imgData];
            } else {
                __block UIImage *image;
                [DejalKeyboardActivityView activityViewForView:self.detailsViewController.imageView
                                                     withLabel:@""];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSURL *url = [NSURL URLWithString:coverImage.url];
                    __block NSData *imageData = nil;
                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        imageData = [NSData dataWithContentsOfURL:url];
                        image = [UIImage imageWithData:imageData];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [DejalKeyboardActivityView removeViewAnimated:YES];
                            if (image) {
                                self.detailsViewController.imageView.image = image;
                                [CPFileUtils saveDataToUserForder:UIImageJPEGRepresentation(image, 1.0f)
                                                         withName:[NSString stringWithFormat:@"%i%i_%i", self.conveyor.ID, coverImage.bucketID, coverImage.createdAt]
                                                         dataType:CPImageFile];
                            }
                            else {
                                self.detailsViewController.imageView.image = [UIImage imageNamed:@"conveyorIcon"];
                            }
                        });
                    });
                });
            }
        }
        // 2
        self.conveyorViewController.distanceTF.text = self.conveyor.transCentersDistance;
        self.conveyorViewController.elevationTF.text = self.conveyor.transElevation;
        self.conveyorViewController.hpMotorTF.text = self.conveyor.transHPMotor;
        self.conveyorViewController.reductorRelationTF.text = self.conveyor.transReducerRelationship;
        self.conveyorViewController.rpmMotorTF.text = self.conveyor.transRPMMotor;
        self.conveyorViewController.inclinationAngleTF.text = self.conveyor.transInclinationAngle;
        self.conveyorViewController.capacityTF.text = self.conveyor.transCapacity;
        self.conveyorViewController.loadTF.text = self.conveyor.transLoad;
        // 3
        NSString *tempTensorTypeName = [[NSString alloc] init];
        for (NSDictionary *dict in [CPTensorTypeArray tensorTypeArray]) {
            if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.tensorType intValue]) {
                tempTensorTypeName = [dict objectForKey:@"Name"];
                break;
            }
        }
        self.tensorTypeViewController.tensorTypeDescLB.text = tempTensorTypeName;
        self.tensorTypeViewController.estimatedWeightTF.text = self.conveyor.tensorEstimatedWeight;
        self.tensorTypeViewController.careerTF.text = self.conveyor.tensorCareer;
        // 4
        NSString *tempMaterialName = [[NSString alloc] init];
        NSString *tempDensity = [[NSString alloc] init];
        for (NSDictionary *dict in [CPMaterialArray materialArray]) {
            if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.matDescription intValue]) {
                tempMaterialName = [dict objectForKey:@"Name"];
                tempDensity = [[dict objectForKey:@"Value"] intValue] == 0 ? @"" : [NSString stringWithFormat:@"%@", dict[@"Value"]];
                break;
            }
        }
        self.materialViewController.descriptionDescLB.text = tempMaterialName;
        self.materialViewController.densityDescLB.text = tempDensity;
        self.materialViewController.maxSizeTerronTF.text = self.conveyor.matTerronSize;
        self.materialViewController.temperatureTF.text = self.conveyor.matTemperature;
        self.materialViewController.heightOfFallTF.text = self.conveyor.matHeightFall;
        self.materialViewController.finesTF.text = self.conveyor.matFinosPercentage;
        NSString *tempString = [[NSString alloc] init];
        for (NSDictionary *dict in [CPMaterialArray conditionsArray]) {
            if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.matLoadingConditions intValue]) {
                tempString = [dict objectForKey:@"Name"];
                break;
            }
        }
        self.materialViewController.loadingConditionsDescLB.text = tempString;
        
        tempString = [[NSString alloc] init];
        for (NSDictionary *dict in [CPMaterialArray loadingFrecuencyArray]) {
            if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.matLoadingFrequency intValue]) {
                tempString = [dict objectForKey:@"Name"];
                break;
            }
        }
        self.materialViewController.loadingFrecuencyDescLB.text = tempString;
        
        tempString = [[NSString alloc] init];
        for (NSDictionary *dict in [CPMaterialArray granularSizeArray]) {
            if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.matGranularSize intValue]) {
                tempString = [dict objectForKey:@"Name"];
                break;
            }
        }
        self.materialViewController.granularSizeDescLB.text = tempString;
        
        tempString = [[NSString alloc] init];
        for (NSDictionary *dict in [CPMaterialArray densityArray]) {
            if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.matDensity intValue]) {
                tempString = [dict objectForKey:@"Name"];
                break;
            }
        }
        self.materialViewController.densityNewDescLB.text = tempString;
        
        tempString = [[NSString alloc] init];
        for (NSDictionary *dict in [CPMaterialArray aggresivityArray]) {
            if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.matAggresivity intValue]) {
                tempString = [dict objectForKey:@"Name"];
                break;
            }
        }
        self.materialViewController.aggresivityDescLB.text = tempString;
        
        tempString = [[NSString alloc] init];
        for (NSDictionary *dict in [CPMaterialArray materialConveyedArray]) {
            if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.matMaterialConveyed intValue]) {
                tempString = [dict objectForKey:@"Name"];
                break;
            }
        }
        self.materialViewController.materialConveyedDescLB.text = tempString;
        
        tempString = [[NSString alloc] init];
        for (NSDictionary *dict in [CPMaterialArray feedingConditionsArray]) {
            if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.matFeedingConditions intValue]) {
                tempString = [dict objectForKey:@"Name"];
                break;
            }
        }
        self.materialViewController.feedingConditionsDescLB.text = tempString;
        
        // 5
        self.actualBeltViewController.widhtPlgTF.text = self.conveyor.bandWidth;
        self.actualBeltViewController.tensionTF.text = self.conveyor.bandTension;
        
        tempString = [[NSString alloc] init];
        for (NSDictionary *dict in [CPActualBeltArray thicknessCoverArray]) {
            if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.bandTopThicknessCover intValue]) {
                tempString = [dict objectForKey:@"Value"];
            }
        }
        self.actualBeltViewController.topCoverThicknessDescLB.text = tempString;
        
        tempString = [[NSString alloc] init];
        for (NSDictionary *dict in [CPActualBeltArray thicknessCoverArray]) {
            if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.bandBottomThicknessCover intValue]) {
                tempString = [dict objectForKey:@"Value"];
            }
        }
        self.actualBeltViewController.bottomCoverThicknessDescLB.text = tempString;
        
        self.actualBeltViewController.velocityTF.text = self.conveyor.bandSpeed;
        self.actualBeltViewController.instalationDateDescLB.text = self.conveyor.bandInstallationDate == 0 || self.conveyor.bandInstallationDate == 21600 ? @"" : [CPDateUtils stringFromTimeStamp:@(self.conveyor.bandInstallationDate)];
        self.actualBeltViewController.brandTF.text = self.conveyor.bandBrand;
        self.actualBeltViewController.totalDevelopmentTF.text = self.conveyor.bandTotalDevelopment;
        self.actualBeltViewController.operationHrsTF.text = self.conveyor.bandOperation;
        // 6
        self.pulleysViewController.drivePulleyTF.text = self.conveyor.drivePulley;
        self.pulleysViewController.widthDrivePulleyTF.text = self.conveyor.drivePulleyWidth;
        self.pulleysViewController.coveringTF.text = self.conveyor.coverPulley;
        
        tempString = [[NSString alloc] init];
        for (NSDictionary *dict in [CPContactArcArray contactArcArray]) {
            if ([dict[@"id"] intValue] == [self.conveyor.contactArcPulley intValue]) {
                self.pulleysViewController.contactArcDescLB.text = dict[@"Value"];
            }
        }
        
        self.pulleysViewController.headPulleyTF.text = self.conveyor.headPulley;
        self.pulleysViewController.widthHeadPulleyTF.text = self.conveyor.headPulleyWidth;
        self.pulleysViewController.tailPulleyTF.text = self.conveyor.tailPulley;
        self.pulleysViewController.widthTailPulleyTF.text = self.conveyor.tailPulleyWidth;
        self.pulleysViewController.contactPulleyTF.text = self.conveyor.contactPulley;
        self.pulleysViewController.widthContactPulleyTF.text = self.conveyor.contactPulleyWidth;
        self.pulleysViewController.bendingPulleyTF.text = self.conveyor.foldPulley;
        self.pulleysViewController.widthBendingPulleyTF.text = self.conveyor.foldPulleyWidth;
        self.pulleysViewController.tensorPulleyTF.text = self.conveyor.tensorPulley;
        self.pulleysViewController.widthTensorPulleyTF.text = self.conveyor.tensorPulleyWidth;
        self.pulleysViewController.additionalPulley1TF.text = self.conveyor.additionalOnePulley;
        self.pulleysViewController.widthAdditionalPulley1TF.text = self.conveyor.additionalOnePulleyWidth;
        self.pulleysViewController.additionalPulley2TF.text = self.conveyor.additionalTwoPulley;
        self.pulleysViewController.widthAdditionalPulley2TF.text = self.conveyor.additionalTwoPulleyWidth;
        // 7
        self.idlersViewController.impactLCTF.text = self.conveyor.rodImpactDiameter;
        
        tempString = [[NSString alloc] init];
        for (NSDictionary *dict in [CPIdlersArray diametersLoadArray]) {
            if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.rodLoadDiameter intValue]) {
                tempString = [dict objectForKey:@"Value"];
            }
        }
        self.idlersViewController.loadLCDescLB.text = tempString;
        
        self.idlersViewController.partTroghingDescLB.text = self.conveyor.rodPartTroughing;
        
        tempString = [[NSString alloc] init];
        for (NSDictionary *dict in [CPIdlersArray diametersReturnArray]) {
            if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.rodReturnDiameter intValue]) {
                tempString = [dict objectForKey:@"Value"];
            }
        }
        self.idlersViewController.returnLCDescLB.text = tempString;
        self.idlersViewController.spaceLCTF.text = self.conveyor.rodLDCSpace;
        self.idlersViewController.spaceLRTF.text = self.conveyor.rodLDRSpace;
        
        tempString = [[NSString alloc] init];
        for (NSDictionary *dict in [CPIdlersArray anglesImpactArray]) {
            if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.rodImpactAngle intValue]) {
                tempString = [dict objectForKey:@"Value"];
            }
        }
        self.idlersViewController.impactLRDescLB.text = tempString;
        
        tempString = [[NSString alloc] init];
        for (NSDictionary *dict in [CPIdlersArray anglesLoadArray]) {
            if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.rodLoadAngle intValue]) {
                tempString = [dict objectForKey:@"Value"];
            }
        }
        self.idlersViewController.loadLRDescLB.text = tempString;
        self.idlersViewController.returnLRTF.text = self.conveyor.rodReturnAngle;
        // 8
        self.remarksViewController.textView.text = self.conveyor.observations;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CPDismissAddEditViewControllerNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CPSaveInfoInAddEditViewControllerNotification
                                                  object:nil];
}

- (void)awakeFromNib
{
    NSUInteger numberOfPages = 8;
    self.viewControllerArray = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
    for (NSUInteger k = 0; k < numberOfPages; ++k)
    {
        [self.viewControllerArray addObject:[NSNull null]];
    }
    
    self.detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPDetailsViewController"];
    self.conveyorViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPConveyorViewController"];
    self.tensorTypeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPTensorTypeViewController"];
    self.materialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPMaterialViewController"];
    self.actualBeltViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPActualBeltViewController"];
    self.pulleysViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPPulleysViewController"];
    self.idlersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPIdlersViewController"];
    self.remarksViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPRemarksViewController"];
    
    
    
    [self.viewControllerArray replaceObjectAtIndex:0
                                        withObject:self.detailsViewController];
    [self.viewControllerArray replaceObjectAtIndex:1
                                        withObject:self.conveyorViewController];
    [self.viewControllerArray replaceObjectAtIndex:2
                                        withObject:self.tensorTypeViewController];
    [self.viewControllerArray replaceObjectAtIndex:3
                                        withObject:self.materialViewController];
    [self.viewControllerArray replaceObjectAtIndex:4
                                        withObject:self.actualBeltViewController];
    [self.viewControllerArray replaceObjectAtIndex:5
                                        withObject:self.pulleysViewController];
    [self.viewControllerArray replaceObjectAtIndex:6
                                        withObject:self.idlersViewController];
    [self.viewControllerArray replaceObjectAtIndex:7
                                        withObject:self.remarksViewController];
}

#pragma mark - UIStatusBar White Color
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - NSNotification Center Methods
- (void)dismissViewSelf
{
    if (self.isCache || self.isEditable) {
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"¡ATENCIÓN!"]
                                                                       message:[CPLanguajeUtils languajeSelectedForString:@"Al salir se perderán los cambios. ¿Desea Continuar?"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yes = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Sí"]
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       [alert dismissViewControllerAnimated:YES
                                                                                 completion:nil];
                                                       [self dismissViewControllerAnimated:YES
                                                                                completion:nil];
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
    }
}

- (void)saveInfo
{
    if ([self.detailsViewController.numberTF.text isEqualToString:@""]) {
        [self showAlertWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al guardar"]
                      andMessage:[CPLanguajeUtils languajeSelectedForString:@"Debe proporcionar un número de serie"]];
    } else if (!self.detailsViewController.profileID) {
        [self showAlertWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al guardar"]
                      andMessage:[CPLanguajeUtils languajeSelectedForString:@"Es necesario seleccionar al menos 1 perfil de banda"]];
    } else {
        [MRProgressOverlayView showOverlayAddedTo:self.view
                                            title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                             mode:MRProgressOverlayViewModeIndeterminate
                                         animated:YES];
        if (self.isCache || !self.isEditable) {
            [CPConveyor saveConveyorWithAuthenticationKey:[CPUser sharedUser].authKey
                                                 clientID:self.isCache ? self.conveyor.clientID : self.clientID
                                             serialNumber:self.detailsViewController.numberTF.text
                                                profileID:[NSString stringWithFormat:@"%i", self.detailsViewController.profileID]
                                     transCentersDistance:!self.conveyorViewController.distanceTF.text ? @"" : self.conveyorViewController.distanceTF.text
                                            transRPMMotor:!self.conveyorViewController.rpmMotorTF.text ? @"0" : self.conveyorViewController.rpmMotorTF.text
                                           transElevation:!self.conveyorViewController.elevationTF.text ? @"" : self.conveyorViewController.elevationTF.text
                                    transInclinationAngle:!self.conveyorViewController.inclinationAngleTF.text ? @"" : self.conveyorViewController.inclinationAngleTF.text
                                             transHPMotor:!self.conveyorViewController.hpMotorTF.text ? @"" : self.conveyorViewController.hpMotorTF.text
                                            transCapacity:!self.conveyorViewController.capacityTF.text ? @"" : self.conveyorViewController.capacityTF.text
                                 transReducerRelationship:!self.conveyorViewController.reductorRelationTF.text ? @"0" : self.conveyorViewController.reductorRelationTF.text
                                                transLoad:!self.conveyorViewController.loadTF.text ? @"0" : self.conveyorViewController.loadTF.text
                                               tensorType:!self.tensorTypeViewController.tensorTypeID ? @"" : self.tensorTypeViewController.tensorTypeID
                                    tensorEstimatedWeight:!self.tensorTypeViewController.estimatedWeightTF.text ? @"0" : self.tensorTypeViewController.estimatedWeightTF.text
                                             tensorCareer:!self.tensorTypeViewController.careerTF.text ? @"0" : self.tensorTypeViewController.careerTF.text
                                           matDescription:!self.materialViewController.matDescriptionID ? @"" : self.materialViewController.matDescriptionID
                                            matTerronSize:!self.materialViewController.maxSizeTerronTF.text ? @"" : self.materialViewController.maxSizeTerronTF.text
                                           matTemperature:!self.materialViewController.temperatureTF.text ? @"0" : self.materialViewController.temperatureTF.text
                                            matHeightFall:!self.materialViewController.heightOfFallTF.text ? @"0" : self.materialViewController.heightOfFallTF.text
                                       matFinosPercentage:!self.materialViewController.finesTF.text ? @"0" : self.materialViewController.finesTF.text
                                     matLoadingConditions:!self.materialViewController.matLoadingConditionsID ? @"" : self.materialViewController.matLoadingConditionsID
                                      matLoadingFrequency:!self.materialViewController.matLoadingFrecuencyID ? @"" : self.materialViewController.matLoadingFrecuencyID
                                          matGranularSize:!self.materialViewController.matGranularSizeID ? @"" : self.materialViewController.matGranularSizeID
                                               matDensity:!self.materialViewController.matDensityNewID ? @"" : self.materialViewController.matDensityNewID
                                           matAggresivity:!self.materialViewController.matAggresivityID ? @"" : self.materialViewController.matAggresivityID
                                      matMaterialConveyed:!self.materialViewController.matMaterialConveyedID ? @"" : self.materialViewController.matMaterialConveyedID
                                     matFeedingConditions:!self.materialViewController.matFeedingConditionsID ? @"" : self.materialViewController.matFeedingConditionsID
                                                bandWidth:!self.actualBeltViewController.widhtPlgTF.text ? @"" : self.actualBeltViewController.widhtPlgTF.text
                                              bandTension:!self.actualBeltViewController.tensionTF.text ? @"0" : self.actualBeltViewController.tensionTF.text
                                    bandTopThicknessCover:!self.actualBeltViewController.topCoverThicknessID ? @"" : self.actualBeltViewController.topCoverThicknessID
                                 bandBottomThicknessCover:!self.actualBeltViewController.bottomCoverThicknessID ? @"" : self.actualBeltViewController.bottomCoverThicknessID
                                                bandSpeed:!self.actualBeltViewController.velocityTF.text ? @"" : self.actualBeltViewController.velocityTF.text
                                     bandInstallationDate:![CPDateUtils timeStampFromDate:self.actualBeltViewController.installationDate] ? 0 : [CPDateUtils timeStampFromDate:self.actualBeltViewController.installationDate]
                                                bandBrand:!self.actualBeltViewController.brandTF.text ? @"0" : self.actualBeltViewController.brandTF.text
                                     bandTotalDevelopment:!self.actualBeltViewController.totalDevelopmentTF.text ? @"0" : self. actualBeltViewController.totalDevelopmentTF.text
                                            bandOperation:!self.actualBeltViewController.operationHrsTF.text ? @"0" : self.actualBeltViewController.operationHrsTF.text
                                              drivePulley:!self.pulleysViewController.drivePulleyTF.text ? @"0" : self.pulleysViewController.drivePulleyTF.text
                                         drivePulleyWidth:!self.pulleysViewController.widthDrivePulleyTF.text ? @"0" : self.pulleysViewController.widthDrivePulleyTF.text
                                              coverPulley:!self.pulleysViewController.coveringTF.text ? @"0" : self.pulleysViewController.coveringTF.text
                                         contactArcPulley:!self.pulleysViewController.contactArcPulleyID ? @"0" : self.pulleysViewController.contactArcPulleyID
                                               headPulley:!self.pulleysViewController.headPulleyTF.text ? @"0" : self.pulleysViewController.headPulleyTF.text
                                          headPulleyWidth:!self.pulleysViewController.widthHeadPulleyTF.text ? @"0" : self.pulleysViewController.widthHeadPulleyTF.text
                                               tailPulley:!self.pulleysViewController.tailPulleyTF.text ? @"0" : self.pulleysViewController.tailPulleyTF.text
                                          tailPulleyWidth:!self.pulleysViewController.widthTailPulleyTF.text ? @"0" : self.pulleysViewController.widthTailPulleyTF.text
                                            contactPulley:!self.pulleysViewController.contactPulleyTF.text ? @"0" : self.pulleysViewController.contactPulleyTF.text
                                       contactPulleyWidth:!self.pulleysViewController.widthContactPulleyTF.text ? @"0" : self.pulleysViewController.widthContactPulleyTF.text
                                               foldPulley:!self.pulleysViewController.bendingPulleyTF.text ? @"0" : self.pulleysViewController.bendingPulleyTF.text
                                          foldPulleyWidth:!self.pulleysViewController.widthBendingPulleyTF.text ? @"0" : self.pulleysViewController.widthBendingPulleyTF.text
                                             tensorPulley:!self.pulleysViewController.tensorPulleyTF.text ? @"0" : self.pulleysViewController.tensorPulleyTF.text
                                        tensorPulleyWidth:!self.pulleysViewController.widthTensorPulleyTF.text ? @"0" : self.pulleysViewController.widthTensorPulleyTF.text
                                      additionalOnePulley:!self.pulleysViewController.additionalPulley1TF.text ? @"0" : self.pulleysViewController.additionalPulley1TF.text
                                 additionalOnePulleyWidth:!self.pulleysViewController.widthAdditionalPulley1TF.text ? @"0" : self.pulleysViewController.widthAdditionalPulley1TF.text
                                      additionalTwoPulley:!self.pulleysViewController.additionalPulley2TF.text ? @"0" : self.pulleysViewController.additionalPulley2TF.text
                                 additionalTwoPulleyWidth:!self.pulleysViewController.widthAdditionalPulley2TF.text ? @"0" : self.pulleysViewController.widthAdditionalPulley2TF.text
                                        rodImpactDiameter:!self.idlersViewController.impactLCTF.text ? @"" : self.idlersViewController.impactLCTF.text
                                           rodImpactAngle:!self.idlersViewController.impactAngleID ? @"0" : self.idlersViewController.impactAngleID
                                          rodLoadDiameter:!self.idlersViewController.loadDiameterID ? @"" : self.idlersViewController.loadDiameterID
                                             rodLoadAngle:!self.idlersViewController.loadAngleID ? @"" : self.idlersViewController.loadAngleID
                                        rodReturnDiameter:!self.idlersViewController.returnDiameterID ? @"" : self.idlersViewController.returnDiameterID
                                           rodReturnAngle:!self.idlersViewController.returnLRTF.text ? @"" : self.idlersViewController.returnLRTF.text
                                              rodLDCSpace:!self.idlersViewController.spaceLCTF.text ? @"" : self.idlersViewController.spaceLCTF.text
                                              rodLDRSpace:!self.idlersViewController.spaceLRTF.text ? @"" : self.idlersViewController.spaceLRTF.text
                                         rodPartTroughing:!self.idlersViewController.partTroghingDescLB.text ? @"" : self.idlersViewController.partTroghingDescLB.text
                                             observations:!self.remarksViewController.textView.text ? @"0" : self.remarksViewController.textView.text
                                               coverImgID:0
                                                createdAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                                updatedAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                        completionHandler:^(BOOL success, int conveyorID) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (success) {
                                                    
                                                    NSMutableArray *draftsConveyor = [NSMutableArray array];
                                                    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]) {
                                                        draftsConveyor = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]] mutableCopy];
                                                    }
                                                    
                                                    for (CPObject *draft in draftsConveyor) {
                                                        if (draft.conveyorID == self.conveyor.createdAt) {
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
                                                    
                                                    self.newConveyorID = conveyorID;
                                                    if (self.detailsViewController.imageView.image) {
                                                        [CPImage saveImageWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                      imageData:UIImageJPEGRepresentation(self.detailsViewController.imageView.image, 1.0)
                                                                                           name:[CPLanguajeUtils languajeSelectedForString:@"Imagen Principal"]
                                                                                 descriptionImg:[CPLanguajeUtils languajeSelectedForString:@"Imagen Principal"]
                                                                                     conveyorID:conveyorID
                                                                                       bucketID:0
                                                                                      createdAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                                                                      updatedAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                                                              completionHandler:^(NSURLResponse *response, NSError *error, NSString *name, int coverID) {
                                                                                  if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error) {
                                                                                      NSMutableArray *covers = [NSMutableArray array];
                                                                                      if ([[NSUserDefaults standardUserDefaults] objectForKey:@"coversArray"]) {
                                                                                          covers = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"coversArray"]] mutableCopy];
                                                                                      }
                                                                                      int createdAt = [CPDateUtils timeStampFromDate:[NSDate date]];
                                                                                      [covers addObject:[CPImage imageWithName:[CPLanguajeUtils languajeSelectedForString:@"Imagen Principal"]
                                                                                                                descriptionImg:[CPLanguajeUtils languajeSelectedForString:@"Imagen Principal"]
                                                                                                                    conveyorID:self.conveyor.ID
                                                                                                                      bucketID:0
                                                                                                                     createdAt:createdAt
                                                                                                                     updatedAt:createdAt]];
                                                                                      NSData *encodeCoversArray = [NSKeyedArchiver archivedDataWithRootObject:covers];
                                                                                      [[NSUserDefaults standardUserDefaults] setObject:encodeCoversArray forKey:@"coversArray"];
                                                                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                      [CPFileUtils saveDataToUserForder:UIImageJPEGRepresentation(self.detailsViewController.imageView.image, 1.0f)
                                                                                                               withName:[NSString stringWithFormat:@"%i%i_%i", self.newConveyorID, 0, createdAt]
                                                                                                               dataType:CPImageFile];
                                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                                          [MRProgressOverlayView  dismissOverlayForView:self.view
                                                                                                                               animated:YES];
                                                                                          [self dismissViewControllerAnimated:YES
                                                                                                                   completion:nil];
                                                                                      });
                                                                                  } else {
                                                                                      [CPFileUtils saveDataToUserForder:UIImageJPEGRepresentation(self.detailsViewController.imageView.image, 1.0f)
                                                                                                               withName:name
                                                                                                               dataType:CPImageFile];
                                                                                      self.coverImgID = coverID;
                                                                                      [CPConveyor updateConveyorWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                                                           conveyorID:self.newConveyorID
                                                                                                                             clientID:self.clientID
                                                                                                                         serialNumber:self.detailsViewController.numberTF.text
                                                                                                                            profileID:[NSString stringWithFormat:@"%i", self.detailsViewController.profileID]
                                                                                                                 transCentersDistance:!self.conveyorViewController.distanceTF.text ? @"" : self.conveyorViewController.distanceTF.text
                                                                                                                        transRPMMotor:!self.conveyorViewController.rpmMotorTF.text ? @"0" : self.conveyorViewController.rpmMotorTF.text
                                                                                                                       transElevation:!self.conveyorViewController.elevationTF.text ? @"" : self.conveyorViewController.elevationTF.text
                                                                                                                transInclinationAngle:!self.conveyorViewController.inclinationAngleTF.text ? @"" : self.conveyorViewController.inclinationAngleTF.text
                                                                                                                         transHPMotor:!self.conveyorViewController.hpMotorTF.text ? @"" : self.conveyorViewController.hpMotorTF.text
                                                                                                                        transCapacity:!self.conveyorViewController.capacityTF.text ? @"" : self.conveyorViewController.capacityTF.text
                                                                                                             transReducerRelationship:!self.conveyorViewController.reductorRelationTF.text ? @"0" : self.conveyorViewController.reductorRelationTF.text
                                                                                                                            transLoad:!self.conveyorViewController.loadTF.text ? @"0" : self.conveyorViewController.loadTF.text
                                                                                                                           tensorType:!self.tensorTypeViewController.tensorTypeID ? @"" : self.tensorTypeViewController.tensorTypeID
                                                                                                                tensorEstimatedWeight:!self.tensorTypeViewController.estimatedWeightTF.text ? @"0" : self.tensorTypeViewController.estimatedWeightTF.text
                                                                                                                         tensorCareer:!self.tensorTypeViewController.careerTF.text ? @"0" : self.tensorTypeViewController.careerTF.text
                                                                                                                       matDescription:!self.materialViewController.matDescriptionID ? @"" : self.materialViewController.matDescriptionID
                                                                                                                        matTerronSize:!self.materialViewController.maxSizeTerronTF.text ? @"" : self.materialViewController.maxSizeTerronTF.text
                                                                                                                       matTemperature:!self.materialViewController.temperatureTF.text ? @"0" : self.materialViewController.temperatureTF.text
                                                                                                                        matHeightFall:!self.materialViewController.heightOfFallTF.text ? @"0" : self.materialViewController.heightOfFallTF.text
                                                                                                                   matFinosPercentage:!self.materialViewController.finesTF.text ? @"0" : self.materialViewController.finesTF.text
                                                                                                                 matLoadingConditions:!self.materialViewController.matLoadingConditionsID ? @"" : self.materialViewController.matLoadingConditionsID
                                                                                                                  matLoadingFrequency:!self.materialViewController.matLoadingFrecuencyID ? @"" : self.materialViewController.matLoadingFrecuencyID
                                                                                                                      matGranularSize:!self.materialViewController.matGranularSizeID ? @"" : self.materialViewController.matGranularSizeID
                                                                                                                           matDensity:!self.materialViewController.matDensityNewID ? @"" : self.materialViewController.matDensityNewID
                                                                                                                       matAggresivity:!self.materialViewController.matAggresivityID ? @"" : self.materialViewController.matAggresivityID
                                                                                                                  matMaterialConveyed:!self.materialViewController.matMaterialConveyedID ? @"" : self.materialViewController.matMaterialConveyedID
                                                                                                                 matFeedingConditions:!self.materialViewController.matFeedingConditionsID ? @"" : self.materialViewController.matFeedingConditionsID
                                                                                                                            bandWidth:!self.actualBeltViewController.widhtPlgTF.text ? @"" : self.actualBeltViewController.widhtPlgTF.text
                                                                                                                          bandTension:!self.actualBeltViewController.tensionTF.text ? @"0" : self.actualBeltViewController.tensionTF.text
                                                                                                                bandTopThicknessCover:!self.actualBeltViewController.topCoverThicknessID ? @"" : self.actualBeltViewController.topCoverThicknessID
                                                                                                             bandBottomThicknessCover:!self.actualBeltViewController.bottomCoverThicknessID ? @"" : self.actualBeltViewController.bottomCoverThicknessID
                                                                                                                            bandSpeed:!self.actualBeltViewController.velocityTF.text ? @"" : self.actualBeltViewController.velocityTF.text
                                                                                                                 bandInstallationDate:![CPDateUtils timeStampFromDate:self.actualBeltViewController.installationDate] ? 0 : [CPDateUtils timeStampFromDate:self.actualBeltViewController.installationDate]
                                                                                                                            bandBrand:!self.actualBeltViewController.brandTF.text ? @"0" : self.actualBeltViewController.brandTF.text
                                                                                                                 bandTotalDevelopment:!self.actualBeltViewController.totalDevelopmentTF.text ? @"0" : self. actualBeltViewController.totalDevelopmentTF.text
                                                                                                                        bandOperation:!self.actualBeltViewController.operationHrsTF.text ? @"0" : self.actualBeltViewController.operationHrsTF.text
                                                                                                                          drivePulley:!self.pulleysViewController.drivePulleyTF.text ? @"0" : self.pulleysViewController.drivePulleyTF.text
                                                                                                                     drivePulleyWidth:!self.pulleysViewController.widthDrivePulleyTF.text ? @"0" : self.pulleysViewController.widthDrivePulleyTF.text
                                                                                                                          coverPulley:!self.pulleysViewController.coveringTF.text ? @"0" : self.pulleysViewController.coveringTF.text
                                                                                                                     contactArcPulley:!self.pulleysViewController.contactArcPulleyID ? @"0" : self.pulleysViewController.contactArcPulleyID
                                                                                                                           headPulley:!self.pulleysViewController.headPulleyTF.text ? @"0" : self.pulleysViewController.headPulleyTF.text
                                                                                                                      headPulleyWidth:!self.pulleysViewController.widthHeadPulleyTF.text ? @"0" : self.pulleysViewController.widthHeadPulleyTF.text
                                                                                                                           tailPulley:!self.pulleysViewController.tailPulleyTF.text ? @"0" : self.pulleysViewController.tailPulleyTF.text
                                                                                                                      tailPulleyWidth:!self.pulleysViewController.widthTailPulleyTF.text ? @"0" : self.pulleysViewController.widthTailPulleyTF.text
                                                                                                                        contactPulley:!self.pulleysViewController.contactPulleyTF.text ? @"0" : self.pulleysViewController.contactPulleyTF.text
                                                                                                                   contactPulleyWidth:!self.pulleysViewController.widthContactPulleyTF.text ? @"0" : self.pulleysViewController.widthContactPulleyTF.text
                                                                                                                           foldPulley:!self.pulleysViewController.bendingPulleyTF.text ? @"0" : self.pulleysViewController.bendingPulleyTF.text
                                                                                                                      foldPulleyWidth:!self.pulleysViewController.widthBendingPulleyTF.text ? @"0" : self.pulleysViewController.widthBendingPulleyTF.text
                                                                                                                         tensorPulley:!self.pulleysViewController.tensorPulleyTF.text ? @"0" : self.pulleysViewController.tensorPulleyTF.text
                                                                                                                    tensorPulleyWidth:!self.pulleysViewController.widthTensorPulleyTF.text ? @"0" : self.pulleysViewController.widthTensorPulleyTF.text
                                                                                                                  additionalOnePulley:!self.pulleysViewController.additionalPulley1TF.text ? @"0" : self.pulleysViewController.additionalPulley1TF.text
                                                                                                             additionalOnePulleyWidth:!self.pulleysViewController.widthAdditionalPulley1TF.text ? @"0" : self.pulleysViewController.widthAdditionalPulley1TF.text
                                                                                                                  additionalTwoPulley:!self.pulleysViewController.additionalPulley2TF.text ? @"0" : self.pulleysViewController.additionalPulley2TF.text
                                                                                                             additionalTwoPulleyWidth:!self.pulleysViewController.widthAdditionalPulley2TF.text ? @"0" : self.pulleysViewController.widthAdditionalPulley2TF.text
                                                                                                                    rodImpactDiameter:!self.idlersViewController.impactLCTF.text ? @"" : self.idlersViewController.impactLCTF.text
                                                                                                                       rodImpactAngle:!self.idlersViewController.impactAngleID ? @"0" : self.idlersViewController.impactAngleID
                                                                                                                      rodLoadDiameter:!self.idlersViewController.loadDiameterID ? @"" : self.idlersViewController.loadDiameterID
                                                                                                                         rodLoadAngle:!self.idlersViewController.loadAngleID ? @"" : self.idlersViewController.loadAngleID
                                                                                                                    rodReturnDiameter:!self.idlersViewController.returnDiameterID ? @"" : self.idlersViewController.returnDiameterID
                                                                                                                       rodReturnAngle:!self.idlersViewController.returnLRTF.text ? @"" : self.idlersViewController.returnLRTF.text
                                                                                                                          rodLDCSpace:!self.idlersViewController.spaceLCTF.text ? @"" : self.idlersViewController.spaceLCTF.text
                                                                                                                          rodLDRSpace:!self.idlersViewController.spaceLRTF.text ? @"" : self.idlersViewController.spaceLRTF.text
                                                                                                                     rodPartTroughing:!self.idlersViewController.partTroghingDescLB.text ? @"" : self.idlersViewController.partTroghingDescLB.text
                                                                                                                         observations:!self.remarksViewController.textView.text ? @"0" : self.remarksViewController.textView.text
                                                                                                                           coverImgID:self.coverImgID
                                                                                                                            createdAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                                                                                                            updatedAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                                                                                                    completionHandler:^(BOOL success) {
                                                                                                                        if (success) {
                                                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                                                [MRProgressOverlayView  dismissOverlayForView:self.view
                                                                                                                                                                     animated:YES];
                                                                                                                                [self dismissViewControllerAnimated:YES
                                                                                                                                                         completion:nil];
                                                                                                                                if (self.isCache) {
                                                                                                                                    NSMutableArray *drafts = [NSMutableArray array];
                                                                                                                                    drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                                                                                                    
                                                                                                                                    int index = 0;
                                                                                                                                    for (id temp in drafts) {
                                                                                                                                        if ([temp isKindOfClass:[CPConveyor class] ]) {
                                                                                                                                            CPConveyor *tmpConveyor = (CPConveyor *)temp;
                                                                                                                                            if (tmpConveyor.createdAt == self.conveyor.createdAt) {
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
                                                                                                                            });
                                                                                                                        }
                                                                                                                    }];
                                                                                  }
                                                                              }];
                                                    } else {
                                                        if (self.isCache) {
                                                            NSMutableArray *drafts = [NSMutableArray array];
                                                            drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                            
                                                            int index = 0;
                                                            for (id temp in drafts) {
                                                                if ([temp isKindOfClass:[CPConveyor class] ]) {
                                                                    CPConveyor *tmpConveyor = (CPConveyor *)temp;
                                                                    if (tmpConveyor.createdAt == self.conveyor.createdAt) {
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
                                                        [self dismissViewControllerAnimated:YES
                                                                                 completion:nil];
                                                    }
                                                } else {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [MRProgressOverlayView  dismissOverlayForView:self.view
                                                                                             animated:YES];
                                                        if (self.isCache) {
                                                            UIAlertController *alertCache = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al subir el transportador"]
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
                                                                                                                if ([temp isKindOfClass:[CPConveyor class] ]) {
                                                                                                                    CPConveyor *tmpConveyor = (CPConveyor *)temp;
                                                                                                                    if (tmpConveyor.createdAt == self.conveyor.createdAt) {
                                                                                                                        break;
                                                                                                                    }
                                                                                                                }
                                                                                                                index++;
                                                                                                            }
                                                                                                            [drafts replaceObjectAtIndex:index withObject:[CPConveyor conveyorClientID:self.conveyor.clientID
                                                                                                                                              serialNumber:self.detailsViewController.numberTF.text
                                                                                                                                                 profileID:[NSString stringWithFormat:@"%i", self.detailsViewController.profileID]
                                                                                                                                      transCentersDistance:!self.conveyorViewController.distanceTF.text ? @"" : self.conveyorViewController.distanceTF.text
                                                                                                                                             transRPMMotor:!self.conveyorViewController.rpmMotorTF.text ? @"0" : self.conveyorViewController.rpmMotorTF.text
                                                                                                                                            transElevation:!self.conveyorViewController.elevationTF.text ? @"" : self.conveyorViewController.elevationTF.text
                                                                                                                                     transInclinationAngle:!self.conveyorViewController.inclinationAngleTF.text ? @"" : self.conveyorViewController.inclinationAngleTF.text
                                                                                                                                              transHPMotor:!self.conveyorViewController.hpMotorTF.text ? @"" : self.conveyorViewController.hpMotorTF.text
                                                                                                                                             transCapacity:!self.conveyorViewController.capacityTF.text ? @"" : self.conveyorViewController.capacityTF.text
                                                                                                                                  transReducerRelationship:!self.conveyorViewController.reductorRelationTF.text ? @"0" : self.conveyorViewController.reductorRelationTF.text
                                                                                                                                                 transLoad:!self.conveyorViewController.loadTF.text ? @"0" : self.conveyorViewController.loadTF.text
                                                                                                                                                tensorType:!self.tensorTypeViewController.tensorTypeID ? @"" : self.tensorTypeViewController.tensorTypeID
                                                                                                                                     tensorEstimatedWeight:!self.tensorTypeViewController.estimatedWeightTF.text ? @"0" : self.tensorTypeViewController.estimatedWeightTF.text
                                                                                                                                              tensorCareer:!self.tensorTypeViewController.careerTF.text ? @"0" : self.tensorTypeViewController.careerTF.text
                                                                                                                                            matDescription:!self.materialViewController.matDescriptionID ? @"" : self.materialViewController.matDescriptionID
                                                                                                                                             matTerronSize:!self.materialViewController.maxSizeTerronTF.text ? @"" : self.materialViewController.maxSizeTerronTF.text
                                                                                                                                            matTemperature:!self.materialViewController.temperatureTF.text ? @"0" : self.materialViewController.temperatureTF.text
                                                                                                                                             matHeightFall:!self.materialViewController.heightOfFallTF.text ? @"0" : self.materialViewController.heightOfFallTF.text
                                                                                                                                        matFinosPercentage:!self.materialViewController.finesTF.text ? @"0" : self.materialViewController.finesTF.text
                                                                                                                                      matLoadingConditions:!self.materialViewController.matLoadingConditionsID ? @"" : self.materialViewController.matLoadingConditionsID
                                                                                                                                       matLoadingFrequency:!self.materialViewController.matLoadingFrecuencyID ? @"" : self.materialViewController.matLoadingFrecuencyID
                                                                                                                                           matGranularSize:!self.materialViewController.matGranularSizeID ? @"" : self.materialViewController.matGranularSizeID
                                                                                                                                                matDensity:!self.materialViewController.matDensityNewID ? @"" : self.materialViewController.matDensityNewID
                                                                                                                                            matAggresivity:!self.materialViewController.matAggresivityID ? @"" : self.materialViewController.matAggresivityID
                                                                                                                                       matMaterialConveyed:!self.materialViewController.matMaterialConveyedID ? @"" : self.materialViewController.matMaterialConveyedID
                                                                                                                                      matFeedingConditions:!self.materialViewController.matFeedingConditionsID ? @"" : self.materialViewController.matFeedingConditionsID
                                                                                                                                                 bandWidth:!self.actualBeltViewController.widhtPlgTF.text ? @"" : self.actualBeltViewController.widhtPlgTF.text
                                                                                                                                               bandTension:!self.actualBeltViewController.tensionTF.text ? @"0" : self.actualBeltViewController.tensionTF.text
                                                                                                                                     bandTopThicknessCover:!self.actualBeltViewController.topCoverThicknessID ? @"" : self.actualBeltViewController.topCoverThicknessID
                                                                                                                                  bandBottomThicknessCover:!self.actualBeltViewController.bottomCoverThicknessID ? @"" : self.actualBeltViewController.bottomCoverThicknessID
                                                                                                                                                 bandSpeed:!self.actualBeltViewController.velocityTF.text ? @"" : self.actualBeltViewController.velocityTF.text
                                                                                                                                      bandInstallationDate:![CPDateUtils timeStampFromDate:self.actualBeltViewController.installationDate] ? 0 : [CPDateUtils timeStampFromDate:self.actualBeltViewController.installationDate]
                                                                                                                                                 bandBrand:!self.actualBeltViewController.brandTF.text ? @"0" : self.actualBeltViewController.brandTF.text
                                                                                                                                      bandTotalDevelopment:!self.actualBeltViewController.totalDevelopmentTF.text ? @"0" : self. actualBeltViewController.totalDevelopmentTF.text
                                                                                                                                             bandOperation:!self.actualBeltViewController.operationHrsTF.text ? @"0" : self.actualBeltViewController.operationHrsTF.text
                                                                                                                                               drivePulley:!self.pulleysViewController.drivePulleyTF.text ? @"0" : self.pulleysViewController.drivePulleyTF.text
                                                                                                                                          drivePulleyWidth:!self.pulleysViewController.widthDrivePulleyTF.text ? @"0" : self.pulleysViewController.widthDrivePulleyTF.text
                                                                                                                                               coverPulley:!self.pulleysViewController.coveringTF.text ? @"0" : self.pulleysViewController.coveringTF.text
                                                                                                                                          contactArcPulley:!self.pulleysViewController.contactArcPulleyID ? @"0" : self.pulleysViewController.contactArcPulleyID
                                                                                                                                                headPulley:!self.pulleysViewController.headPulleyTF.text ? @"0" : self.pulleysViewController.headPulleyTF.text
                                                                                                                                           headPulleyWidth:!self.pulleysViewController.widthHeadPulleyTF.text ? @"0" : self.pulleysViewController.widthHeadPulleyTF.text
                                                                                                                                                tailPulley:!self.pulleysViewController.tailPulleyTF.text ? @"0" : self.pulleysViewController.tailPulleyTF.text
                                                                                                                                           tailPulleyWidth:!self.pulleysViewController.widthTailPulleyTF.text ? @"0" : self.pulleysViewController.widthTailPulleyTF.text
                                                                                                                                             contactPulley:!self.pulleysViewController.contactPulleyTF.text ? @"0" : self.pulleysViewController.contactPulleyTF.text
                                                                                                                                        contactPulleyWidth:!self.pulleysViewController.widthContactPulleyTF.text ? @"0" : self.pulleysViewController.widthContactPulleyTF.text
                                                                                                                                                foldPulley:!self.pulleysViewController.bendingPulleyTF.text ? @"0" : self.pulleysViewController.bendingPulleyTF.text
                                                                                                                                           foldPulleyWidth:!self.pulleysViewController.widthBendingPulleyTF.text ? @"0" : self.pulleysViewController.widthBendingPulleyTF.text
                                                                                                                                              tensorPulley:!self.pulleysViewController.tensorPulleyTF.text ? @"0" : self.pulleysViewController.tensorPulleyTF.text
                                                                                                                                         tensorPulleyWidth:!self.pulleysViewController.widthTensorPulleyTF.text ? @"0" : self.pulleysViewController.widthTensorPulleyTF.text
                                                                                                                                       additionalOnePulley:!self.pulleysViewController.additionalPulley1TF.text ? @"0" : self.pulleysViewController.additionalPulley1TF.text
                                                                                                                                  additionalOnePulleyWidth:!self.pulleysViewController.widthAdditionalPulley1TF.text ? @"0" : self.pulleysViewController.widthAdditionalPulley1TF.text
                                                                                                                                       additionalTwoPulley:!self.pulleysViewController.additionalPulley2TF.text ? @"0" : self.pulleysViewController.additionalPulley2TF.text
                                                                                                                                  additionalTwoPulleyWidth:!self.pulleysViewController.widthAdditionalPulley2TF.text ? @"0" : self.pulleysViewController.widthAdditionalPulley2TF.text
                                                                                                                                         rodImpactDiameter:!self.idlersViewController.impactLCTF.text ? @"" : self.idlersViewController.impactLCTF.text
                                                                                                                                            rodImpactAngle:!self.idlersViewController.impactAngleID ? @"0" : self.idlersViewController.impactAngleID
                                                                                                                                           rodLoadDiameter:!self.idlersViewController.loadDiameterID ? @"" : self.idlersViewController.loadDiameterID
                                                                                                                                              rodLoadAngle:!self.idlersViewController.loadAngleID ? @"" : self.idlersViewController.loadAngleID
                                                                                                                                         rodReturnDiameter:!self.idlersViewController.returnDiameterID ? @"" : self.idlersViewController.returnDiameterID
                                                                                                                                            rodReturnAngle:!self.idlersViewController.returnLRTF.text ? @"" : self.idlersViewController.returnLRTF.text
                                                                                                                                               rodLDCSpace:!self.idlersViewController.spaceLCTF.text ? @"" : self.idlersViewController.spaceLCTF.text
                                                                                                                                               rodLDRSpace:!self.idlersViewController.spaceLRTF.text ? @"" : self.idlersViewController.spaceLRTF.text
                                                                                                                                          rodPartTroughing:!self.idlersViewController.partTroghingDescLB.text ? @"" : self.idlersViewController.partTroghingDescLB.text
                                                                                                                                              observations:!self.remarksViewController.textView.text ? @"0" : self.remarksViewController.textView.text
                                                                                                                                                coverImgID:self.conveyor.coverImgID
                                                                                                                                                 createdAt:self.conveyor.createdAt
                                                                                                                                                 updatedAt:self.conveyor.updatedAt]];
                                                                                                            NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                                                                                            [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsArray"];
                                                                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                            
                                                                                                            if (self.conveyor.coverImgID == 0 && self.detailsViewController.imageView.image) {
                                                                                                                [CPFileUtils saveDataToUserForder:UIImageJPEGRepresentation(self.detailsViewController.imageView.image, 1.0f)
                                                                                                                                         withName:[NSString stringWithFormat:@"%i%i_%i", 0, 0, self.conveyor.createdAt]
                                                                                                                                         dataType:CPImageFile];
                                                                                                                
                                                                                                            }
                                                                                                            [self dismissViewControllerAnimated:YES
                                                                                                                                     completion:nil];
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
                                                            UIAlertController *alertCache = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al subir el transportador"]
                                                                                                                                message:[CPLanguajeUtils languajeSelectedForString:@"¿Desea guardar el transportador en borradores?"]
                                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                            UIAlertAction *yes = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Sí"]
                                                                                                          style:UIAlertActionStyleDefault
                                                                                                        handler:^(UIAlertAction *action) {
                                                                                                            NSMutableArray *drafts = [NSMutableArray array];
                                                                                                            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]) {
                                                                                                                drafts = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsArray"]] mutableCopy];
                                                                                                            }
                                                                                                            int createdAt = [CPDateUtils timeStampFromDate:[NSDate date]];
                                                                                                            [drafts addObject:[CPConveyor conveyorClientID:self.clientID
                                                                                                                                              serialNumber:self.detailsViewController.numberTF.text
                                                                                                                                                 profileID:[NSString stringWithFormat:@"%i", self.detailsViewController.profileID]
                                                                                                                                      transCentersDistance:!self.conveyorViewController.distanceTF.text ? @"" : self.conveyorViewController.distanceTF.text
                                                                                                                                             transRPMMotor:!self.conveyorViewController.rpmMotorTF.text ? @"0" : self.conveyorViewController.rpmMotorTF.text
                                                                                                                                            transElevation:!self.conveyorViewController.elevationTF.text ? @"" : self.conveyorViewController.elevationTF.text
                                                                                                                                     transInclinationAngle:!self.conveyorViewController.inclinationAngleTF.text ? @"" : self.conveyorViewController.inclinationAngleTF.text
                                                                                                                                              transHPMotor:!self.conveyorViewController.hpMotorTF.text ? @"" : self.conveyorViewController.hpMotorTF.text
                                                                                                                                             transCapacity:!self.conveyorViewController.capacityTF.text ? @"" : self.conveyorViewController.capacityTF.text
                                                                                                                                  transReducerRelationship:!self.conveyorViewController.reductorRelationTF.text ? @"0" : self.conveyorViewController.reductorRelationTF.text
                                                                                                                                                 transLoad:!self.conveyorViewController.loadTF.text ? @"0" : self.conveyorViewController.loadTF.text
                                                                                                                                                tensorType:!self.tensorTypeViewController.tensorTypeID ? @"" : self.tensorTypeViewController.tensorTypeID
                                                                                                                                     tensorEstimatedWeight:!self.tensorTypeViewController.estimatedWeightTF.text ? @"0" : self.tensorTypeViewController.estimatedWeightTF.text
                                                                                                                                              tensorCareer:!self.tensorTypeViewController.careerTF.text ? @"0" : self.tensorTypeViewController.careerTF.text
                                                                                                                                            matDescription:!self.materialViewController.matDescriptionID ? @"" : self.materialViewController.matDescriptionID
                                                                                                                                             matTerronSize:!self.materialViewController.maxSizeTerronTF.text ? @"" : self.materialViewController.maxSizeTerronTF.text
                                                                                                                                            matTemperature:!self.materialViewController.temperatureTF.text ? @"0" : self.materialViewController.temperatureTF.text
                                                                                                                                             matHeightFall:!self.materialViewController.heightOfFallTF.text ? @"0" : self.materialViewController.heightOfFallTF.text
                                                                                                                                        matFinosPercentage:!self.materialViewController.finesTF.text ? @"0" : self.materialViewController.finesTF.text
                                                                                                                                      matLoadingConditions:!self.materialViewController.matLoadingConditionsID ? @"" : self.materialViewController.matLoadingConditionsID
                                                                                                                                       matLoadingFrequency:!self.materialViewController.matLoadingFrecuencyID ? @"" : self.materialViewController.matLoadingFrecuencyID
                                                                                                                                           matGranularSize:!self.materialViewController.matGranularSizeID ? @"" : self.materialViewController.matGranularSizeID
                                                                                                                                                matDensity:!self.materialViewController.matDensityNewID ? @"" : self.materialViewController.matDensityNewID
                                                                                                                                            matAggresivity:!self.materialViewController.matAggresivityID ? @"" : self.materialViewController.matAggresivityID
                                                                                                                                       matMaterialConveyed:!self.materialViewController.matMaterialConveyedID ? @"" : self.materialViewController.matMaterialConveyedID
                                                                                                                                      matFeedingConditions:!self.materialViewController.matFeedingConditionsID ? @"" : self.materialViewController.matFeedingConditionsID
                                                                                                                                                 bandWidth:!self.actualBeltViewController.widhtPlgTF.text ? @"" : self.actualBeltViewController.widhtPlgTF.text
                                                                                                                                               bandTension:!self.actualBeltViewController.tensionTF.text ? @"0" : self.actualBeltViewController.tensionTF.text
                                                                                                                                     bandTopThicknessCover:!self.actualBeltViewController.topCoverThicknessID ? @"" : self.actualBeltViewController.topCoverThicknessID
                                                                                                                                  bandBottomThicknessCover:!self.actualBeltViewController.bottomCoverThicknessID ? @"" : self.actualBeltViewController.bottomCoverThicknessID
                                                                                                                                                 bandSpeed:!self.actualBeltViewController.velocityTF.text ? @"" : self.actualBeltViewController.velocityTF.text
                                                                                                                                      bandInstallationDate:![CPDateUtils timeStampFromDate:self.actualBeltViewController.installationDate] ? 0 : [CPDateUtils timeStampFromDate:self.actualBeltViewController.installationDate]
                                                                                                                                                 bandBrand:!self.actualBeltViewController.brandTF.text ? @"0" : self.actualBeltViewController.brandTF.text
                                                                                                                                      bandTotalDevelopment:!self.actualBeltViewController.totalDevelopmentTF.text ? @"0" : self. actualBeltViewController.totalDevelopmentTF.text
                                                                                                                                             bandOperation:!self.actualBeltViewController.operationHrsTF.text ? @"0" : self.actualBeltViewController.operationHrsTF.text
                                                                                                                                               drivePulley:!self.pulleysViewController.drivePulleyTF.text ? @"0" : self.pulleysViewController.drivePulleyTF.text
                                                                                                                                          drivePulleyWidth:!self.pulleysViewController.widthDrivePulleyTF.text ? @"0" : self.pulleysViewController.widthDrivePulleyTF.text
                                                                                                                                               coverPulley:!self.pulleysViewController.coveringTF.text ? @"0" : self.pulleysViewController.coveringTF.text
                                                                                                                                          contactArcPulley:!self.pulleysViewController.contactArcPulleyID ? @"0" : self.pulleysViewController.contactArcPulleyID
                                                                                                                                                headPulley:!self.pulleysViewController.headPulleyTF.text ? @"0" : self.pulleysViewController.headPulleyTF.text
                                                                                                                                           headPulleyWidth:!self.pulleysViewController.widthHeadPulleyTF.text ? @"0" : self.pulleysViewController.widthHeadPulleyTF.text
                                                                                                                                                tailPulley:!self.pulleysViewController.tailPulleyTF.text ? @"0" : self.pulleysViewController.tailPulleyTF.text
                                                                                                                                           tailPulleyWidth:!self.pulleysViewController.widthTailPulleyTF.text ? @"0" : self.pulleysViewController.widthTailPulleyTF.text
                                                                                                                                             contactPulley:!self.pulleysViewController.contactPulleyTF.text ? @"0" : self.pulleysViewController.contactPulleyTF.text
                                                                                                                                        contactPulleyWidth:!self.pulleysViewController.widthContactPulleyTF.text ? @"0" : self.pulleysViewController.widthContactPulleyTF.text
                                                                                                                                                foldPulley:!self.pulleysViewController.bendingPulleyTF.text ? @"0" : self.pulleysViewController.bendingPulleyTF.text
                                                                                                                                           foldPulleyWidth:!self.pulleysViewController.widthBendingPulleyTF.text ? @"0" : self.pulleysViewController.widthBendingPulleyTF.text
                                                                                                                                              tensorPulley:!self.pulleysViewController.tensorPulleyTF.text ? @"0" : self.pulleysViewController.tensorPulleyTF.text
                                                                                                                                         tensorPulleyWidth:!self.pulleysViewController.widthTensorPulleyTF.text ? @"0" : self.pulleysViewController.widthTensorPulleyTF.text
                                                                                                                                       additionalOnePulley:!self.pulleysViewController.additionalPulley1TF.text ? @"0" : self.pulleysViewController.additionalPulley1TF.text
                                                                                                                                  additionalOnePulleyWidth:!self.pulleysViewController.widthAdditionalPulley1TF.text ? @"0" : self.pulleysViewController.widthAdditionalPulley1TF.text
                                                                                                                                       additionalTwoPulley:!self.pulleysViewController.additionalPulley2TF.text ? @"0" : self.pulleysViewController.additionalPulley2TF.text
                                                                                                                                  additionalTwoPulleyWidth:!self.pulleysViewController.widthAdditionalPulley2TF.text ? @"0" : self.pulleysViewController.widthAdditionalPulley2TF.text
                                                                                                                                         rodImpactDiameter:!self.idlersViewController.impactLCTF.text ? @"" : self.idlersViewController.impactLCTF.text
                                                                                                                                            rodImpactAngle:!self.idlersViewController.impactAngleID ? @"0" : self.idlersViewController.impactAngleID
                                                                                                                                           rodLoadDiameter:!self.idlersViewController.loadDiameterID ? @"" : self.idlersViewController.loadDiameterID
                                                                                                                                              rodLoadAngle:!self.idlersViewController.loadAngleID ? @"" : self.idlersViewController.loadAngleID
                                                                                                                                         rodReturnDiameter:!self.idlersViewController.returnDiameterID ? @"" : self.idlersViewController.returnDiameterID
                                                                                                                                            rodReturnAngle:!self.idlersViewController.returnLRTF.text ? @"" : self.idlersViewController.returnLRTF.text
                                                                                                                                               rodLDCSpace:!self.idlersViewController.spaceLCTF.text ? @"" : self.idlersViewController.spaceLCTF.text
                                                                                                                                               rodLDRSpace:!self.idlersViewController.spaceLRTF.text ? @"" : self.idlersViewController.spaceLRTF.text
                                                                                                                                          rodPartTroughing:!self.idlersViewController.partTroghingDescLB.text ? @"" : self.idlersViewController.partTroghingDescLB.text
                                                                                                                                              observations:!self.remarksViewController.textView.text ? @"0" : self.remarksViewController.textView.text
                                                                                                                                                coverImgID:0
                                                                                                                                                 createdAt:createdAt
                                                                                                                                                 updatedAt:createdAt]];
                                                                                                            NSData *encodeCacheArray = [NSKeyedArchiver archivedDataWithRootObject:drafts];
                                                                                                            [[NSUserDefaults standardUserDefaults] setObject:encodeCacheArray forKey:@"draftsArray"];
                                                                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                                            
                                                                                                            if (self.detailsViewController.imageView.image) {
                                                                                                                [CPFileUtils saveDataToUserForder:UIImageJPEGRepresentation(self.detailsViewController.imageView.image, 1.0f)
                                                                                                                                         withName:[NSString stringWithFormat:@"%i%i_%i", 0, 0, createdAt]
                                                                                                                                         dataType:CPImageFile];
                                                                                                                
                                                                                                            }
                                                                                                            [self dismissViewControllerAnimated:YES
                                                                                                                                     completion:nil];
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
                                                    });
                                                }
                                            });
                                        }];
        } else if (self.isEditable) {
            if (self.conveyor.coverImgID == 0) {
                if (self.detailsViewController.imageView.image) {
                    [CPImage saveImageWithAuthenticationKey:[CPUser sharedUser].authKey
                                                  imageData:UIImageJPEGRepresentation(self.detailsViewController.imageView.image, 1.0f)
                                                       name:[CPLanguajeUtils languajeSelectedForString:@"Imagen Principal"]
                                             descriptionImg:[CPLanguajeUtils languajeSelectedForString:@"Imagen Principal"]
                                                 conveyorID:self.conveyor.ID
                                                   bucketID:0
                                                  createdAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                                  updatedAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                          completionHandler:^(NSURLResponse *response, NSError *error, NSString *name, int coverID) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [MRProgressOverlayView  dismissOverlayForView:self.view
                                                                                       animated:YES];
                                                  if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error) {
                                                      UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al actualizar el transportador"]
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
                                                      [CPFileUtils saveDataToUserForder:UIImageJPEGRepresentation(self.detailsViewController.imageView.image, 1.0f)
                                                                               withName:name
                                                                               dataType:CPImageFile];
                                                      [CPConveyor updateConveyorWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                           conveyorID:self.conveyor.ID
                                                                                             clientID:self.conveyor.clientID
                                                                                         serialNumber:self.detailsViewController.numberTF.text
                                                                                            profileID:![NSString stringWithFormat:@"%i", self.detailsViewController.profileID] ? self.conveyor.profileID : [NSString stringWithFormat:@"%i", self.detailsViewController.profileID]
                                                                                 transCentersDistance:!self.conveyorViewController.distanceTF.text ? @"" : self.conveyorViewController.distanceTF.text
                                                                                        transRPMMotor:!self.conveyorViewController.rpmMotorTF.text ? @"0" : self.conveyorViewController.rpmMotorTF.text
                                                                                       transElevation:!self.conveyorViewController.elevationTF.text ? @"" : self.conveyorViewController.elevationTF.text
                                                                                transInclinationAngle:!self.conveyorViewController.inclinationAngleTF.text ? @"" : self.conveyorViewController.inclinationAngleTF.text
                                                                                         transHPMotor:!self.conveyorViewController.hpMotorTF.text ? @"" : self.conveyorViewController.hpMotorTF.text
                                                                                        transCapacity:!self.conveyorViewController.capacityTF.text ? @"" : self.conveyorViewController.capacityTF.text
                                                                             transReducerRelationship:!self.conveyorViewController.reductorRelationTF.text ? @"0" : self.conveyorViewController.reductorRelationTF.text
                                                                                            transLoad:!self.conveyorViewController.loadTF.text ? @"0" : self.conveyorViewController.loadTF.text
                                                                                           tensorType:!self.tensorTypeViewController.tensorTypeID ? self.conveyor.tensorType : self.tensorTypeViewController.tensorTypeID
                                                                                tensorEstimatedWeight:!self.tensorTypeViewController.estimatedWeightTF.text ? @"0" : self.tensorTypeViewController.estimatedWeightTF.text
                                                                                         tensorCareer:!self.tensorTypeViewController.careerTF.text ? @"0" : self.tensorTypeViewController.careerTF.text
                                                                                       matDescription:!self.materialViewController.matDescriptionID ? self.conveyor.matDescription : self.materialViewController.matDescriptionID
                                                                                        matTerronSize:!self.materialViewController.maxSizeTerronTF.text ? @"" : self.materialViewController.maxSizeTerronTF.text
                                                                                       matTemperature:!self.materialViewController.temperatureTF.text ? @"0" : self.materialViewController.temperatureTF.text
                                                                                        matHeightFall:!self.materialViewController.heightOfFallTF.text ? @"0" : self.materialViewController.heightOfFallTF.text
                                                                                   matFinosPercentage:!self.materialViewController.finesTF.text ? @"0" : self.materialViewController.finesTF.text
                                                                                 matLoadingConditions:!self.materialViewController.matLoadingConditionsID ? self.conveyor.matLoadingConditions : self.materialViewController.matLoadingConditionsID
                                                                                  matLoadingFrequency:!self.materialViewController.matLoadingFrecuencyID ? self.conveyor.matLoadingFrequency : self.materialViewController.matLoadingFrecuencyID
                                                                                      matGranularSize:!self.materialViewController.matGranularSizeID ? self.conveyor.matGranularSize : self.materialViewController.matGranularSizeID
                                                                                           matDensity:!self.materialViewController.matDensityNewID ? self.conveyor.matDensity : self.materialViewController.matDensityNewID
                                                                                       matAggresivity:!self.materialViewController.matAggresivityID ? self.conveyor.matAggresivity : self.materialViewController.matAggresivityID
                                                                                  matMaterialConveyed:!self.materialViewController.matMaterialConveyedID ? self.conveyor.matMaterialConveyed : self.materialViewController.matMaterialConveyedID
                                                                                 matFeedingConditions:!self.materialViewController.matFeedingConditionsID ? self.conveyor.matFeedingConditions : self.materialViewController.matFeedingConditionsID
                                                                                            bandWidth:!self.actualBeltViewController.widhtPlgTF.text ? @"" : self.actualBeltViewController.widhtPlgTF.text
                                                                                          bandTension:!self.actualBeltViewController.tensionTF.text ? @"0" : self.actualBeltViewController.tensionTF.text
                                                                                bandTopThicknessCover:!self.actualBeltViewController.topCoverThicknessID ? self.conveyor.bandTopThicknessCover : self.actualBeltViewController.topCoverThicknessID
                                                                             bandBottomThicknessCover:!self.actualBeltViewController.bottomCoverThicknessID ? self.conveyor.bandBottomThicknessCover : self.actualBeltViewController.bottomCoverThicknessID
                                                                                            bandSpeed:!self.actualBeltViewController.velocityTF.text ? @"" : self.actualBeltViewController.velocityTF.text
                                                                                 bandInstallationDate:![CPDateUtils timeStampFromDate:self.actualBeltViewController.installationDate] ? self.conveyor.bandInstallationDate : [CPDateUtils timeStampFromDate:self.actualBeltViewController.installationDate]
                                                                                            bandBrand:!self.actualBeltViewController.brandTF.text ? @"0" : self.actualBeltViewController.brandTF.text
                                                                                 bandTotalDevelopment:!self.actualBeltViewController.totalDevelopmentTF.text ? @"0" : self. actualBeltViewController.totalDevelopmentTF.text
                                                                                        bandOperation:!self.actualBeltViewController.operationHrsTF.text ? @"0" : self.actualBeltViewController.operationHrsTF.text
                                                                                          drivePulley:!self.pulleysViewController.drivePulleyTF.text ? @"0" : self.pulleysViewController.drivePulleyTF.text
                                                                                     drivePulleyWidth:!self.pulleysViewController.widthDrivePulleyTF.text ? @"0" : self.pulleysViewController.widthDrivePulleyTF.text
                                                                                          coverPulley:!self.pulleysViewController.coveringTF.text ? @"0" : self.pulleysViewController.coveringTF.text
                                                                                     contactArcPulley:!self.pulleysViewController.contactArcPulleyID ? self.conveyor.contactArcPulley : self.pulleysViewController.contactArcPulleyID
                                                                                           headPulley:!self.pulleysViewController.headPulleyTF.text ? @"0" : self.pulleysViewController.headPulleyTF.text
                                                                                      headPulleyWidth:!self.pulleysViewController.widthHeadPulleyTF.text ? @"0" : self.pulleysViewController.widthHeadPulleyTF.text
                                                                                           tailPulley:!self.pulleysViewController.tailPulleyTF.text ? @"0" : self.pulleysViewController.tailPulleyTF.text
                                                                                      tailPulleyWidth:!self.pulleysViewController.widthTailPulleyTF.text ? @"0" : self.pulleysViewController.widthTailPulleyTF.text
                                                                                        contactPulley:!self.pulleysViewController.contactPulleyTF.text ? @"0" : self.pulleysViewController.contactPulleyTF.text
                                                                                   contactPulleyWidth:!self.pulleysViewController.widthContactPulleyTF.text ? @"0" : self.pulleysViewController.widthContactPulleyTF.text
                                                                                           foldPulley:!self.pulleysViewController.bendingPulleyTF.text ? @"0" : self.pulleysViewController.bendingPulleyTF.text
                                                                                      foldPulleyWidth:!self.pulleysViewController.widthBendingPulleyTF.text ? @"0" : self.pulleysViewController.widthBendingPulleyTF.text
                                                                                         tensorPulley:!self.pulleysViewController.tensorPulleyTF.text ? @"0" : self.pulleysViewController.tensorPulleyTF.text
                                                                                    tensorPulleyWidth:!self.pulleysViewController.widthTensorPulleyTF.text ? @"0" : self.pulleysViewController.widthTensorPulleyTF.text
                                                                                  additionalOnePulley:!self.pulleysViewController.additionalPulley1TF.text ? @"0" : self.pulleysViewController.additionalPulley1TF.text
                                                                             additionalOnePulleyWidth:!self.pulleysViewController.widthAdditionalPulley1TF.text ? @"0" : self.pulleysViewController.widthAdditionalPulley1TF.text
                                                                                  additionalTwoPulley:!self.pulleysViewController.additionalPulley2TF.text ? @"0" : self.pulleysViewController.additionalPulley2TF.text
                                                                             additionalTwoPulleyWidth:!self.pulleysViewController.widthAdditionalPulley2TF.text ? @"0" : self.pulleysViewController.widthAdditionalPulley2TF.text
                                                                                    rodImpactDiameter:!self.idlersViewController.impactLCTF.text ? @"" : self.idlersViewController.impactLCTF.text
                                                                                       rodImpactAngle:!self.idlersViewController.impactAngleID ? self.conveyor.rodImpactAngle : self.idlersViewController.impactAngleID
                                                                                      rodLoadDiameter:!self.idlersViewController.loadDiameterID ? self.conveyor.rodLoadDiameter : self.idlersViewController.loadDiameterID
                                                                                         rodLoadAngle:!self.idlersViewController.loadAngleID ? self.conveyor.rodLoadAngle : self.idlersViewController.loadAngleID
                                                                                    rodReturnDiameter:!self.idlersViewController.returnDiameterID ? self.conveyor.rodReturnDiameter : self.idlersViewController.returnDiameterID
                                                                                       rodReturnAngle:!self.idlersViewController.returnLRTF.text ? @"" : self.idlersViewController.returnLRTF.text
                                                                                          rodLDCSpace:!self.idlersViewController.spaceLCTF.text ? @"" : self.idlersViewController.spaceLCTF.text
                                                                                          rodLDRSpace:!self.idlersViewController.spaceLRTF.text ? @"" : self.idlersViewController.spaceLRTF.text
                                                                                     rodPartTroughing:!self.idlersViewController.partTroghingDescLB.text ? @"" : self.idlersViewController.partTroghingDescLB.text
                                                                                         observations:!self.remarksViewController.textView.text ? @"0" : self.remarksViewController.textView.text
                                                                                           coverImgID:coverID
                                                                                            createdAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                                                                            updatedAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                                                                    completionHandler:^(BOOL success) {
                                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                                            [MRProgressOverlayView  dismissOverlayForView:self.view
                                                                                                                                 animated:YES];
                                                                                            if (success) {
                                                                                                [self dismissViewControllerAnimated:YES
                                                                                                                         completion:nil];
                                                                                            } else {
                                                                                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al actualizar el transportador"]
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
                                              });
                                          }];
                } else {
                    [CPConveyor updateConveyorWithAuthenticationKey:[CPUser sharedUser].authKey
                                                         conveyorID:self.conveyor.ID
                                                           clientID:self.conveyor.clientID
                                                       serialNumber:self.detailsViewController.numberTF.text
                                                          profileID:![NSString stringWithFormat:@"%i", self.detailsViewController.profileID] ? self.conveyor.profileID : [NSString stringWithFormat:@"%i", self.detailsViewController.profileID]
                                               transCentersDistance:!self.conveyorViewController.distanceTF.text ? @"" : self.conveyorViewController.distanceTF.text
                                                      transRPMMotor:!self.conveyorViewController.rpmMotorTF.text ? @"0" : self.conveyorViewController.rpmMotorTF.text
                                                     transElevation:!self.conveyorViewController.elevationTF.text ? @"" : self.conveyorViewController.elevationTF.text
                                              transInclinationAngle:!self.conveyorViewController.inclinationAngleTF.text ? @"" : self.conveyorViewController.inclinationAngleTF.text
                                                       transHPMotor:!self.conveyorViewController.hpMotorTF.text ? @"" : self.conveyorViewController.hpMotorTF.text
                                                      transCapacity:!self.conveyorViewController.capacityTF.text ? @"" : self.conveyorViewController.capacityTF.text
                                           transReducerRelationship:!self.conveyorViewController.reductorRelationTF.text ? @"0" : self.conveyorViewController.reductorRelationTF.text
                                                          transLoad:!self.conveyorViewController.loadTF.text ? @"0" : self.conveyorViewController.loadTF.text
                                                         tensorType:!self.tensorTypeViewController.tensorTypeID ? self.conveyor.tensorType : self.tensorTypeViewController.tensorTypeID
                                              tensorEstimatedWeight:!self.tensorTypeViewController.estimatedWeightTF.text ? @"0" : self.tensorTypeViewController.estimatedWeightTF.text
                                                       tensorCareer:!self.tensorTypeViewController.careerTF.text ? @"0" : self.tensorTypeViewController.careerTF.text
                                                     matDescription:!self.materialViewController.matDescriptionID ? self.conveyor.matDescription : self.materialViewController.matDescriptionID
                                                      matTerronSize:!self.materialViewController.maxSizeTerronTF.text ? @"" : self.materialViewController.maxSizeTerronTF.text
                                                     matTemperature:!self.materialViewController.temperatureTF.text ? @"0" : self.materialViewController.temperatureTF.text
                                                      matHeightFall:!self.materialViewController.heightOfFallTF.text ? @"0" : self.materialViewController.heightOfFallTF.text
                                                 matFinosPercentage:!self.materialViewController.finesTF.text ? @"0" : self.materialViewController.finesTF.text
                                               matLoadingConditions:!self.materialViewController.matLoadingConditionsID ? self.conveyor.matLoadingConditions : self.materialViewController.matLoadingConditionsID
                                                matLoadingFrequency:!self.materialViewController.matLoadingFrecuencyID ? self.conveyor.matLoadingFrequency : self.materialViewController.matLoadingFrecuencyID
                                                    matGranularSize:!self.materialViewController.matGranularSizeID ? self.conveyor.matGranularSize : self.materialViewController.matGranularSizeID
                                                         matDensity:!self.materialViewController.matDensityNewID ? self.conveyor.matDensity : self.materialViewController.matDensityNewID
                                                     matAggresivity:!self.materialViewController.matAggresivityID ? self.conveyor.matAggresivity : self.materialViewController.matAggresivityID
                                                matMaterialConveyed:!self.materialViewController.matMaterialConveyedID ? self.conveyor.matMaterialConveyed : self.materialViewController.matMaterialConveyedID
                                               matFeedingConditions:!self.materialViewController.matFeedingConditionsID ? self.conveyor.matFeedingConditions : self.materialViewController.matFeedingConditionsID
                                                          bandWidth:!self.actualBeltViewController.widhtPlgTF.text ? @"" : self.actualBeltViewController.widhtPlgTF.text
                                                        bandTension:!self.actualBeltViewController.tensionTF.text ? @"0" : self.actualBeltViewController.tensionTF.text
                                              bandTopThicknessCover:!self.actualBeltViewController.topCoverThicknessID ? self.conveyor.bandTopThicknessCover : self.actualBeltViewController.topCoverThicknessID
                                           bandBottomThicknessCover:!self.actualBeltViewController.bottomCoverThicknessID ? self.conveyor.bandBottomThicknessCover : self.actualBeltViewController.bottomCoverThicknessID
                                                          bandSpeed:!self.actualBeltViewController.velocityTF.text ? @"" : self.actualBeltViewController.velocityTF.text
                                               bandInstallationDate:![CPDateUtils timeStampFromDate:self.actualBeltViewController.installationDate] ? self.conveyor.bandInstallationDate : [CPDateUtils timeStampFromDate:self.actualBeltViewController.installationDate]
                                                          bandBrand:!self.actualBeltViewController.brandTF.text ? @"0" : self.actualBeltViewController.brandTF.text
                                               bandTotalDevelopment:!self.actualBeltViewController.totalDevelopmentTF.text ? @"0" : self. actualBeltViewController.totalDevelopmentTF.text
                                                      bandOperation:!self.actualBeltViewController.operationHrsTF.text ? @"0" : self.actualBeltViewController.operationHrsTF.text
                                                        drivePulley:!self.pulleysViewController.drivePulleyTF.text ? @"0" : self.pulleysViewController.drivePulleyTF.text
                                                   drivePulleyWidth:!self.pulleysViewController.widthDrivePulleyTF.text ? @"0" : self.pulleysViewController.widthDrivePulleyTF.text
                                                        coverPulley:!self.pulleysViewController.coveringTF.text ? @"0" : self.pulleysViewController.coveringTF.text
                                                   contactArcPulley:!self.pulleysViewController.contactArcPulleyID ? self.conveyor.contactArcPulley : self.pulleysViewController.contactArcPulleyID
                                                         headPulley:!self.pulleysViewController.headPulleyTF.text ? @"0" : self.pulleysViewController.headPulleyTF.text
                                                    headPulleyWidth:!self.pulleysViewController.widthHeadPulleyTF.text ? @"0" : self.pulleysViewController.widthHeadPulleyTF.text
                                                         tailPulley:!self.pulleysViewController.tailPulleyTF.text ? @"0" : self.pulleysViewController.tailPulleyTF.text
                                                    tailPulleyWidth:!self.pulleysViewController.widthTailPulleyTF.text ? @"0" : self.pulleysViewController.widthTailPulleyTF.text
                                                      contactPulley:!self.pulleysViewController.contactPulleyTF.text ? @"0" : self.pulleysViewController.contactPulleyTF.text
                                                 contactPulleyWidth:!self.pulleysViewController.widthContactPulleyTF.text ? @"0" : self.pulleysViewController.widthContactPulleyTF.text
                                                         foldPulley:!self.pulleysViewController.bendingPulleyTF.text ? @"0" : self.pulleysViewController.bendingPulleyTF.text
                                                    foldPulleyWidth:!self.pulleysViewController.widthBendingPulleyTF.text ? @"0" : self.pulleysViewController.widthBendingPulleyTF.text
                                                       tensorPulley:!self.pulleysViewController.tensorPulleyTF.text ? @"0" : self.pulleysViewController.tensorPulleyTF.text
                                                  tensorPulleyWidth:!self.pulleysViewController.widthTensorPulleyTF.text ? @"0" : self.pulleysViewController.widthTensorPulleyTF.text
                                                additionalOnePulley:!self.pulleysViewController.additionalPulley1TF.text ? @"0" : self.pulleysViewController.additionalPulley1TF.text
                                           additionalOnePulleyWidth:!self.pulleysViewController.widthAdditionalPulley1TF.text ? @"0" : self.pulleysViewController.widthAdditionalPulley1TF.text
                                                additionalTwoPulley:!self.pulleysViewController.additionalPulley2TF.text ? @"0" : self.pulleysViewController.additionalPulley2TF.text
                                           additionalTwoPulleyWidth:!self.pulleysViewController.widthAdditionalPulley2TF.text ? @"0" : self.pulleysViewController.widthAdditionalPulley2TF.text
                                                  rodImpactDiameter:!self.idlersViewController.impactLCTF.text ? @"" : self.idlersViewController.impactLCTF.text
                                                     rodImpactAngle:!self.idlersViewController.impactAngleID ? self.conveyor.rodImpactAngle : self.idlersViewController.impactAngleID
                                                    rodLoadDiameter:!self.idlersViewController.loadDiameterID ? self.conveyor.rodLoadDiameter : self.idlersViewController.loadDiameterID
                                                       rodLoadAngle:!self.idlersViewController.loadAngleID ? self.conveyor.rodLoadAngle : self.idlersViewController.loadAngleID
                                                  rodReturnDiameter:!self.idlersViewController.returnDiameterID ? self.conveyor.rodReturnDiameter : self.idlersViewController.returnDiameterID
                                                     rodReturnAngle:!self.idlersViewController.returnLRTF.text ? @"" : self.idlersViewController.returnLRTF.text
                                                        rodLDCSpace:!self.idlersViewController.spaceLCTF.text ? @"" : self.idlersViewController.spaceLCTF.text
                                                        rodLDRSpace:!self.idlersViewController.spaceLRTF.text ? @"" : self.idlersViewController.spaceLRTF.text
                                                   rodPartTroughing:!self.idlersViewController.partTroghingDescLB.text ? @"" : self.idlersViewController.partTroghingDescLB.text
                                                       observations:!self.remarksViewController.textView.text ? @"0" : self.remarksViewController.textView.text
                                                         coverImgID:0
                                                          createdAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                                          updatedAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                                  completionHandler:^(BOOL success) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [MRProgressOverlayView  dismissOverlayForView:self.view
                                                                                               animated:YES];
                                                          if (success) {
                                                              [self dismissViewControllerAnimated:YES
                                                                                       completion:nil];
                                                          } else {
                                                              UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al actualizar el transportador"]
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
            } else {
                [CPConveyor updateConveyorWithAuthenticationKey:[CPUser sharedUser].authKey
                                                     conveyorID:self.conveyor.ID
                                                       clientID:self.conveyor.clientID
                                                   serialNumber:self.detailsViewController.numberTF.text
                                                      profileID:![NSString stringWithFormat:@"%i", self.detailsViewController.profileID] ? self.conveyor.profileID : [NSString stringWithFormat:@"%i", self.detailsViewController.profileID]
                                           transCentersDistance:!self.conveyorViewController.distanceTF.text ? @"" : self.conveyorViewController.distanceTF.text
                                                  transRPMMotor:!self.conveyorViewController.rpmMotorTF.text ? @"0" : self.conveyorViewController.rpmMotorTF.text
                                                 transElevation:!self.conveyorViewController.elevationTF.text ? @"" : self.conveyorViewController.elevationTF.text
                                          transInclinationAngle:!self.conveyorViewController.inclinationAngleTF.text ? @"" : self.conveyorViewController.inclinationAngleTF.text
                                                   transHPMotor:!self.conveyorViewController.hpMotorTF.text ? @"" : self.conveyorViewController.hpMotorTF.text
                                                  transCapacity:!self.conveyorViewController.capacityTF.text ? @"" : self.conveyorViewController.capacityTF.text
                                       transReducerRelationship:!self.conveyorViewController.reductorRelationTF.text ? @"0" : self.conveyorViewController.reductorRelationTF.text
                                                      transLoad:!self.conveyorViewController.loadTF.text ? @"0" : self.conveyorViewController.loadTF.text
                                                     tensorType:!self.tensorTypeViewController.tensorTypeID ? self.conveyor.tensorType : self.tensorTypeViewController.tensorTypeID
                                          tensorEstimatedWeight:!self.tensorTypeViewController.estimatedWeightTF.text ? @"0" : self.tensorTypeViewController.estimatedWeightTF.text
                                                   tensorCareer:!self.tensorTypeViewController.careerTF.text ? @"0" : self.tensorTypeViewController.careerTF.text
                                                 matDescription:!self.materialViewController.matDescriptionID ? self.conveyor.matDescription : self.materialViewController.matDescriptionID
                                                  matTerronSize:!self.materialViewController.maxSizeTerronTF.text ? @"" : self.materialViewController.maxSizeTerronTF.text
                                                 matTemperature:!self.materialViewController.temperatureTF.text ? @"0" : self.materialViewController.temperatureTF.text
                                                  matHeightFall:!self.materialViewController.heightOfFallTF.text ? @"0" : self.materialViewController.heightOfFallTF.text
                                             matFinosPercentage:!self.materialViewController.finesTF.text ? @"0" : self.materialViewController.finesTF.text
                                           matLoadingConditions:!self.materialViewController.matLoadingConditionsID ? self.conveyor.matLoadingConditions : self.materialViewController.matLoadingConditionsID
                                            matLoadingFrequency:!self.materialViewController.matLoadingFrecuencyID ? self.conveyor.matLoadingFrequency : self.materialViewController.matLoadingFrecuencyID
                                                matGranularSize:!self.materialViewController.matGranularSizeID ? self.conveyor.matGranularSize : self.materialViewController.matGranularSizeID
                                                     matDensity:!self.materialViewController.matDensityNewID ? self.conveyor.matDensity : self.materialViewController.matDensityNewID
                                                 matAggresivity:!self.materialViewController.matAggresivityID ? self.conveyor.matAggresivity : self.materialViewController.matAggresivityID
                                            matMaterialConveyed:!self.materialViewController.matMaterialConveyedID ? self.conveyor.matMaterialConveyed : self.materialViewController.matMaterialConveyedID
                                           matFeedingConditions:!self.materialViewController.matFeedingConditionsID ? self.conveyor.matFeedingConditions : self.materialViewController.matFeedingConditionsID
                                                      bandWidth:!self.actualBeltViewController.widhtPlgTF.text ? @"" : self.actualBeltViewController.widhtPlgTF.text
                                                    bandTension:!self.actualBeltViewController.tensionTF.text ? @"0" : self.actualBeltViewController.tensionTF.text
                                          bandTopThicknessCover:!self.actualBeltViewController.topCoverThicknessID ? self.conveyor.bandTopThicknessCover : self.actualBeltViewController.topCoverThicknessID
                                       bandBottomThicknessCover:!self.actualBeltViewController.bottomCoverThicknessID ? self.conveyor.bandBottomThicknessCover : self.actualBeltViewController.bottomCoverThicknessID
                                                      bandSpeed:!self.actualBeltViewController.velocityTF.text ? @"" : self.actualBeltViewController.velocityTF.text
                                           bandInstallationDate:![CPDateUtils timeStampFromDate:self.actualBeltViewController.installationDate] ? self.conveyor.bandInstallationDate : [CPDateUtils timeStampFromDate:self.actualBeltViewController.installationDate]
                                                      bandBrand:!self.actualBeltViewController.brandTF.text ? @"0" : self.actualBeltViewController.brandTF.text
                                           bandTotalDevelopment:!self.actualBeltViewController.totalDevelopmentTF.text ? @"0" : self. actualBeltViewController.totalDevelopmentTF.text
                                                  bandOperation:!self.actualBeltViewController.operationHrsTF.text ? @"0" : self.actualBeltViewController.operationHrsTF.text
                                                    drivePulley:!self.pulleysViewController.drivePulleyTF.text ? @"0" : self.pulleysViewController.drivePulleyTF.text
                                               drivePulleyWidth:!self.pulleysViewController.widthDrivePulleyTF.text ? @"0" : self.pulleysViewController.widthDrivePulleyTF.text
                                                    coverPulley:!self.pulleysViewController.coveringTF.text ? @"0" : self.pulleysViewController.coveringTF.text
                                               contactArcPulley:!self.pulleysViewController.contactArcPulleyID ? self.conveyor.contactArcPulley : self.pulleysViewController.contactArcPulleyID
                                                     headPulley:!self.pulleysViewController.headPulleyTF.text ? @"0" : self.pulleysViewController.headPulleyTF.text
                                                headPulleyWidth:!self.pulleysViewController.widthHeadPulleyTF.text ? @"0" : self.pulleysViewController.widthHeadPulleyTF.text
                                                     tailPulley:!self.pulleysViewController.tailPulleyTF.text ? @"0" : self.pulleysViewController.tailPulleyTF.text
                                                tailPulleyWidth:!self.pulleysViewController.widthTailPulleyTF.text ? @"0" : self.pulleysViewController.widthTailPulleyTF.text
                                                  contactPulley:!self.pulleysViewController.contactPulleyTF.text ? @"0" : self.pulleysViewController.contactPulleyTF.text
                                             contactPulleyWidth:!self.pulleysViewController.widthContactPulleyTF.text ? @"0" : self.pulleysViewController.widthContactPulleyTF.text
                                                     foldPulley:!self.pulleysViewController.bendingPulleyTF.text ? @"0" : self.pulleysViewController.bendingPulleyTF.text
                                                foldPulleyWidth:!self.pulleysViewController.widthBendingPulleyTF.text ? @"0" : self.pulleysViewController.widthBendingPulleyTF.text
                                                   tensorPulley:!self.pulleysViewController.tensorPulleyTF.text ? @"0" : self.pulleysViewController.tensorPulleyTF.text
                                              tensorPulleyWidth:!self.pulleysViewController.widthTensorPulleyTF.text ? @"0" : self.pulleysViewController.widthTensorPulleyTF.text
                                            additionalOnePulley:!self.pulleysViewController.additionalPulley1TF.text ? @"0" : self.pulleysViewController.additionalPulley1TF.text
                                       additionalOnePulleyWidth:!self.pulleysViewController.widthAdditionalPulley1TF.text ? @"0" : self.pulleysViewController.widthAdditionalPulley1TF.text
                                            additionalTwoPulley:!self.pulleysViewController.additionalPulley2TF.text ? @"0" : self.pulleysViewController.additionalPulley2TF.text
                                       additionalTwoPulleyWidth:!self.pulleysViewController.widthAdditionalPulley2TF.text ? @"0" : self.pulleysViewController.widthAdditionalPulley2TF.text
                                              rodImpactDiameter:!self.idlersViewController.impactLCTF.text ? @"" : self.idlersViewController.impactLCTF.text
                                                 rodImpactAngle:!self.idlersViewController.impactAngleID ? self.conveyor.rodImpactAngle : self.idlersViewController.impactAngleID
                                                rodLoadDiameter:!self.idlersViewController.loadDiameterID ? self.conveyor.rodLoadDiameter : self.idlersViewController.loadDiameterID
                                                   rodLoadAngle:!self.idlersViewController.loadAngleID ? self.conveyor.rodLoadAngle : self.idlersViewController.loadAngleID
                                              rodReturnDiameter:!self.idlersViewController.returnDiameterID ? self.conveyor.rodReturnDiameter : self.idlersViewController.returnDiameterID
                                                 rodReturnAngle:!self.idlersViewController.returnLRTF.text ? @"" : self.idlersViewController.returnLRTF.text
                                                    rodLDCSpace:!self.idlersViewController.spaceLCTF.text ? @"" : self.idlersViewController.spaceLCTF.text
                                                    rodLDRSpace:!self.idlersViewController.spaceLRTF.text ? @"" : self.idlersViewController.spaceLRTF.text
                                               rodPartTroughing:!self.idlersViewController.partTroghingDescLB.text ? @"" : self.idlersViewController.partTroghingDescLB.text
                                                   observations:!self.remarksViewController.textView.text ? @"0" : self.remarksViewController.textView.text
                                                     coverImgID:self.conveyor.coverImgID
                                                      createdAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                                      updatedAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                              completionHandler:^(BOOL success) {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [MRProgressOverlayView  dismissOverlayForView:self.view
                                                                                           animated:YES];
                                                      if (success) {
                                                          [self dismissViewControllerAnimated:YES
                                                                                   completion:nil];
                                                      } else {
                                                          UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al actualizar el transportador"]
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

#pragma mark - DDScrollViewDataSource

- (NSUInteger)numberOfViewControllerInDDScrollView:(DDScrollViewController *)DDScrollView
{
    return [self.viewControllerArray count];
}

- (UIViewController*)ddScrollView:(DDScrollViewController *)ddScrollView
     contentViewControllerAtIndex:(NSUInteger)index
{
    return [self.viewControllerArray objectAtIndex:index];
}


@end
