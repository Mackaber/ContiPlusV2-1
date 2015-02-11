//
//  CPDataSheetViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/7/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPDataSheetViewController.h"
#import "CPConveyor.h"
#import "CPDateUtils.h"
#import "CPLanguajeUtils.h"
#import "CPMaterialArray.h"
#import "CPAddEditConveyorViewController.h"
#import "CPTensorTypeArray.h"
#import "CPActualBeltArray.h"
#import "CPContactArcArray.h"
#import "CPIdlersArray.h"

@interface CPDataSheetViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarBT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeigthCNST;

@property (weak, nonatomic) IBOutlet UILabel *nameConveyorLB;
@property (weak, nonatomic) IBOutlet UILabel *clientLB;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfileView;
@property (weak, nonatomic) IBOutlet UILabel *editedLB;
@property (weak, nonatomic) IBOutlet UILabel *createdLB;

// Conveyor
@property (weak, nonatomic) IBOutlet UILabel *conveyorTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *distanceConveyorLB;
@property (weak, nonatomic) IBOutlet UILabel *distanceConveyorDescLB;
@property (weak, nonatomic) IBOutlet UILabel *elevationConveyor;
@property (weak, nonatomic) IBOutlet UILabel *elevationConvetorDesc;
@property (weak, nonatomic) IBOutlet UILabel *hpMotorLB;
@property (weak, nonatomic) IBOutlet UILabel *hpMotorDesc;
@property (weak, nonatomic) IBOutlet UILabel *reductoRelationshipLB;
@property (weak, nonatomic) IBOutlet UILabel *reductorRelationshipDescLB;
@property (weak, nonatomic) IBOutlet UILabel *rpmMotorLB;
@property (weak, nonatomic) IBOutlet UILabel *rpmMotorDescLB;
@property (weak, nonatomic) IBOutlet UILabel *inclinationAngleLB;
@property (weak, nonatomic) IBOutlet UILabel *inclinationAngleDescLB;
@property (weak, nonatomic) IBOutlet UILabel *capacityLB;
@property (weak, nonatomic) IBOutlet UILabel *capacityDescLB;
@property (weak, nonatomic) IBOutlet UILabel *loadLB;
@property (weak, nonatomic) IBOutlet UILabel *loadDescLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conveyorViewHeightCNST;
@property (nonatomic) BOOL isConveyorOpen;
@property (weak, nonatomic) IBOutlet UIView *conveyorContentView;

// Tensor Type
@property (weak, nonatomic) IBOutlet UILabel *tensorTypeTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *tensorTypeLB;
@property (weak, nonatomic) IBOutlet UILabel *tensorTypeDescLB;
@property (weak, nonatomic) IBOutlet UILabel *estimatedWeightLB;
@property (weak, nonatomic) IBOutlet UILabel *estimatedWeightDescLB;
@property (weak, nonatomic) IBOutlet UILabel *careerLB;
@property (weak, nonatomic) IBOutlet UILabel *careerDescLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tensorViewHeightCNST;
@property (nonatomic) BOOL isTensorOpen;
@property (weak, nonatomic) IBOutlet UIView *tensorContentView;

// Material
@property (weak, nonatomic) IBOutlet UILabel *materialTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLB;
@property (weak, nonatomic) IBOutlet UILabel *descriptionDescLB;
@property (weak, nonatomic) IBOutlet UILabel *densityMatLB;
@property (weak, nonatomic) IBOutlet UILabel *densityMatDescLB;
@property (weak, nonatomic) IBOutlet UILabel *maxTerronSizeLB;
@property (weak, nonatomic) IBOutlet UILabel *maxTerronSizeDescLB;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLB;
@property (weak, nonatomic) IBOutlet UILabel *temperatureDescLB;
@property (weak, nonatomic) IBOutlet UILabel *fallHeightLB;
@property (weak, nonatomic) IBOutlet UILabel *fallHeightDescLB;
@property (weak, nonatomic) IBOutlet UILabel *finesLB;
@property (weak, nonatomic) IBOutlet UILabel *finesDescLB;
@property (weak, nonatomic) IBOutlet UILabel *loadingConditionsLB;
@property (weak, nonatomic) IBOutlet UILabel *loadingConditionsDescLB;
@property (weak, nonatomic) IBOutlet UILabel *loadingFrecuencyLB;
@property (weak, nonatomic) IBOutlet UILabel *loadingFrecuencyDescLB;
@property (weak, nonatomic) IBOutlet UILabel *granularSizeLB;
@property (weak, nonatomic) IBOutlet UILabel *granularSizeDescLB;
@property (weak, nonatomic) IBOutlet UILabel *nDensityLB;
@property (weak, nonatomic) IBOutlet UILabel *nDensityDescLB;
@property (weak, nonatomic) IBOutlet UILabel *aggresitivityLB;
@property (weak, nonatomic) IBOutlet UILabel *aggresitivityDescLB;
@property (weak, nonatomic) IBOutlet UILabel *conveyedMaterialLB;
@property (weak, nonatomic) IBOutlet UILabel *conveyedMaterialDescLB;
@property (weak, nonatomic) IBOutlet UILabel *feedingConditionsLB;
@property (weak, nonatomic) IBOutlet UILabel *feedingConditionsDescLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *materialViewHeightCNST;
@property (nonatomic) BOOL isMaterialOpen;
@property (weak, nonatomic) IBOutlet UIView *materialContentView;

// Belt
@property (weak, nonatomic) IBOutlet UILabel *beltTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *bandwitdthLB;
@property (weak, nonatomic) IBOutlet UILabel *bandwitdthDescLB;
@property (weak, nonatomic) IBOutlet UILabel *bandTensionLB;
@property (weak, nonatomic) IBOutlet UILabel *bandTensionDescLB;
@property (weak, nonatomic) IBOutlet UILabel *bandTopThicknessCoverLB;
@property (weak, nonatomic) IBOutlet UILabel *bandTopThicknessCoverDescLB;
@property (weak, nonatomic) IBOutlet UILabel *bandBottomThicknessCoverLB;
@property (weak, nonatomic) IBOutlet UILabel *bandBottomThicknessCoverDescLB;
@property (weak, nonatomic) IBOutlet UILabel *bandSpeedLB;
@property (weak, nonatomic) IBOutlet UILabel *bandSpeedDescLB;
@property (weak, nonatomic) IBOutlet UILabel *bandInstalationDateLB;
@property (weak, nonatomic) IBOutlet UILabel *bandInstalationDateDescLB;
@property (weak, nonatomic) IBOutlet UILabel *bandBrandLB;
@property (weak, nonatomic) IBOutlet UILabel *bandBrandDescLB;
@property (weak, nonatomic) IBOutlet UILabel *bandTotalDevelopmentLB;
@property (weak, nonatomic) IBOutlet UILabel *bandTotalDevelopmentDescLB;
@property (weak, nonatomic) IBOutlet UILabel *bandOperationLB;
@property (weak, nonatomic) IBOutlet UILabel *bandOperationDescLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actualBeltViewHeightCNST;
@property (nonatomic) BOOL isActualBeltOpen;
@property (weak, nonatomic) IBOutlet UIView *actualBandContentView;

// Pulleys
@property (weak, nonatomic) IBOutlet UILabel *pulleysTitle;
@property (weak, nonatomic) IBOutlet UILabel *drivePulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *drivePulleyDescLB;
@property (weak, nonatomic) IBOutlet UILabel *drivePulleyWidthLB;
@property (weak, nonatomic) IBOutlet UILabel *drivePulleyWidthDescLB;
@property (weak, nonatomic) IBOutlet UILabel *coverPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *coverPulleyDescLB;
@property (weak, nonatomic) IBOutlet UILabel *contactArcPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *contactArcPulleyDescLB;
@property (weak, nonatomic) IBOutlet UILabel *headPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *headPulleyDescLB;
@property (weak, nonatomic) IBOutlet UILabel *headPulleyWidthLB;
@property (weak, nonatomic) IBOutlet UILabel *headPulleyWidthDescLB;
@property (weak, nonatomic) IBOutlet UILabel *tailPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *tailPulleyDescLB;
@property (weak, nonatomic) IBOutlet UILabel *tailPulleyWidthLB;
@property (weak, nonatomic) IBOutlet UILabel *tailPulleyWidthDescLB;
@property (weak, nonatomic) IBOutlet UILabel *contactPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *contactPulleyDescLB;
@property (weak, nonatomic) IBOutlet UILabel *contactPulleyWidthLB;
@property (weak, nonatomic) IBOutlet UILabel *contactPulleyWidthDescLB;
@property (weak, nonatomic) IBOutlet UILabel *foldPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *foldPulleyDescLB;
@property (weak, nonatomic) IBOutlet UILabel *foldPulleyWidthLB;
@property (weak, nonatomic) IBOutlet UILabel *foldPulleyWidthDescLB;
@property (weak, nonatomic) IBOutlet UILabel *tensorPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *tensorPulleyDescLB;
@property (weak, nonatomic) IBOutlet UILabel *tensorPulleyWidthLB;
@property (weak, nonatomic) IBOutlet UILabel *tensorPulleyWidthDescLB;
@property (weak, nonatomic) IBOutlet UILabel *additionalOnePulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *additionalOnePulleyDescLB;
@property (weak, nonatomic) IBOutlet UILabel *additionalOnePulleyWidthLB;
@property (weak, nonatomic) IBOutlet UILabel *additionalOnePulleyWidthDescLB;
@property (weak, nonatomic) IBOutlet UILabel *additionalTwoPulleyLB;
@property (weak, nonatomic) IBOutlet UILabel *additionalTwoPulleyDescLB;
@property (weak, nonatomic) IBOutlet UILabel *additionalTwoPulleyWidthLB;
@property (weak, nonatomic) IBOutlet UILabel *additionalTwoPulleyWidthDescLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pulleysViewHeightCNST;
@property (nonatomic) BOOL isPulleysOpen;
@property (weak, nonatomic) IBOutlet UIView *pulleysContainerView;

// Idlres
@property (weak, nonatomic) IBOutlet UILabel *idlersTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *rodImpactDiameterLB;
@property (weak, nonatomic) IBOutlet UILabel *rodImpactDiameterDescLB;
@property (weak, nonatomic) IBOutlet UILabel *rodImpactAngleLB;
@property (weak, nonatomic) IBOutlet UILabel *rodImpactAngleDescLB;
@property (weak, nonatomic) IBOutlet UILabel *rodLoadDiameterLB;
@property (weak, nonatomic) IBOutlet UILabel *rodLoadDiameterDescLB;
@property (weak, nonatomic) IBOutlet UILabel *rodLoadAngleLB;
@property (weak, nonatomic) IBOutlet UILabel *rodLoadAngleDescLB;
@property (weak, nonatomic) IBOutlet UILabel *rodReturnDiameterLB;
@property (weak, nonatomic) IBOutlet UILabel *rodReturnDiameterDescLB;
@property (weak, nonatomic) IBOutlet UILabel *rodReturnAngleLB;
@property (weak, nonatomic) IBOutlet UILabel *rodReturnAngleDescLB;
@property (weak, nonatomic) IBOutlet UILabel *rodLDCSpaceLB;
@property (weak, nonatomic) IBOutlet UILabel *rodLDCSpaceDescLB;
@property (weak, nonatomic) IBOutlet UILabel *rodLDRSpaceLB;
@property (weak, nonatomic) IBOutlet UILabel *rodLDRSpaceDescLB;
@property (weak, nonatomic) IBOutlet UILabel *partTroughingLB;
@property (weak, nonatomic) IBOutlet UILabel *partTroughingDescLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idlersViewHeightCNST;
@property (nonatomic) BOOL isIdlersOpen;
@property (weak, nonatomic) IBOutlet UIView *idlersContentView;

// Observations
@property (weak, nonatomic) IBOutlet UILabel *observationsTitleLB;
@property (weak, nonatomic) IBOutlet UITextView *observationsTV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *observationsHeightCNST;
@property (weak, nonatomic) IBOutlet UIView *observationsContentView;
@property (nonatomic) BOOL isObservationsOpen;

@end

@implementation CPDataSheetViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:rightConstraint];
    self.contentViewHeigthCNST.constant = self.contentViewHeigthCNST.constant - self.conveyorViewHeightCNST.constant - self.tensorViewHeightCNST.constant - self.materialViewHeightCNST.constant - self.actualBeltViewHeightCNST.constant - self.pulleysViewHeightCNST.constant - self.idlersViewHeightCNST.constant - self.observationsHeightCNST.constant;
    self.conveyorViewHeightCNST.constant = 0;
    self.conveyorContentView.hidden = YES;
    self.tensorViewHeightCNST.constant = 0;
    self.tensorContentView.hidden = YES;
    self.materialViewHeightCNST.constant = 0;
    self.materialContentView.hidden = YES;
    self.actualBeltViewHeightCNST.constant = 0;
    self.actualBandContentView.hidden = YES;
    self.pulleysViewHeightCNST.constant = 0;
    self.pulleysContainerView.hidden = YES;
    self.idlersViewHeightCNST.constant = 0;
    self.idlersContentView.hidden = YES;
    self.observationsHeightCNST.constant = 0;
    self.observationsContentView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"conveyorsArray"]] mutableCopy];
    for (CPConveyor *conveyor in tempArray) {
        if (conveyor.ID == self.conveyor.ID) {
            self.conveyor = conveyor;
            break;
        }
    }
    [self setUpView];
}

- (void)setUpView
{
    // Head
    [self.editBarBT setTitle:[CPLanguajeUtils languajeSelectedForString:@"Editar"]];
    self.nameConveyorLB.text = self.conveyor.serialNumber;
    self.clientLB.text = self.clientName;
    self.imageProfileView.image = [UIImage imageNamed:[NSString stringWithFormat:@"profile_%@", self.conveyor.profileID]];
    self.editedLB.text = [NSString stringWithFormat:@"%@ %@", [CPLanguajeUtils languajeSelectedForString:@"Editado"],[CPDateUtils stringFromTimeStamp:@(self.conveyor.updatedAt)]];
    self.createdLB.text = [NSString stringWithFormat:@"%@ %@", [CPLanguajeUtils languajeSelectedForString:@"Creado"], [CPDateUtils stringFromTimeStamp:@(self.conveyor.createdAt)]];
    // Conveyor
    self.conveyorTitleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Transportador"];
    self.distanceConveyorLB.text = [CPLanguajeUtils languajeSelectedForString:@"Distancia entre centros (m)"];
    self.distanceConveyorDescLB.text = [self.conveyor.transCentersDistance isEqualToString:@""] || [self.conveyor.transCentersDistance isEqualToString:@"0"] ? @"-" : self.conveyor.transCentersDistance;
    self.elevationConveyor.text = [CPLanguajeUtils languajeSelectedForString:@"Elevación (m)"];
    self.elevationConvetorDesc.text = [self.conveyor.transElevation isEqualToString:@""] || [self.conveyor.transElevation isEqualToString:@"0"] ? @"-" : self.conveyor.transElevation;
    self.hpMotorLB.text = [CPLanguajeUtils languajeSelectedForString:@"HP Motor"];
    self.hpMotorDesc.text = [self.conveyor.transHPMotor isEqualToString:@""] ? @"-" : self.conveyor.transHPMotor;
    self.reductoRelationshipLB.text = [CPLanguajeUtils languajeSelectedForString:@"Relación reductor"];
    self.reductorRelationshipDescLB.text = [self.conveyor.transReducerRelationship isEqualToString:@""] ? @"-" : self.conveyor.transReducerRelationship;
    self.rpmMotorLB.text = [CPLanguajeUtils languajeSelectedForString:@"RPM Motor"];
    self.rpmMotorDescLB.text = [self.conveyor.transRPMMotor isEqualToString:@""] ? @"-" : self.conveyor.transRPMMotor;
    self.inclinationAngleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ángulo de inclinación (°)"];
    self.inclinationAngleDescLB.text = [self.conveyor.transInclinationAngle isEqualToString:@""] ? @"-" : self.conveyor.transInclinationAngle;
    self.capacityLB.text = [CPLanguajeUtils languajeSelectedForString:@"Capacidad (t/h)"];
    self.capacityDescLB.text = [self.conveyor.transCapacity isEqualToString:@""] ? @"-" : self.conveyor.transCapacity;
    self.loadLB.text = [CPLanguajeUtils languajeSelectedForString:@"Carga (%)"];
    self.loadDescLB.text = [self.conveyor.transLoad isEqualToString:@""] ? @"-" : self.conveyor.transLoad;
    
    // TensorType
    self.tensorTypeTitleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Tipo de Tensor"];
    self.tensorTypeLB.text = [CPLanguajeUtils languajeSelectedForString:@"Tipo de Tensor"];
    
    NSString *tempString = [[NSString alloc] init];
    for (NSDictionary *dict in [CPTensorTypeArray tensorTypeArray]) {
        if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.tensorType intValue]) {
            tempString = [dict objectForKey:@"Name"];
            break;
        }
    }
    self.tensorTypeDescLB.text = [tempString isEqualToString:@""] ? @"-" : tempString;
    
    self.estimatedWeightLB.text = [CPLanguajeUtils languajeSelectedForString:@"Peso estimado (lbs)"];
    self.estimatedWeightDescLB.text = [self.conveyor.tensorEstimatedWeight isEqualToString:@""] ? @"-" : self.conveyor.tensorEstimatedWeight;
    self.careerLB.text = [CPLanguajeUtils languajeSelectedForString:@"Carrera (m)"];
    self.careerDescLB.text = [self.conveyor.tensorCareer isEqualToString:@""] || [self.conveyor.tensorCareer isEqualToString:@"0"] ? @"-" : self.conveyor.tensorCareer;
    
    // Material
    self.materialTitleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Material"];
    self.descriptionLB.text = [CPLanguajeUtils languajeSelectedForString:@"Descripción"];
    self.densityMatLB.text = [CPLanguajeUtils languajeSelectedForString:@"Densidad (lbs/ft3)"];
    
    if ([self.conveyor.matDescription intValue] == 0) {
        self.descriptionDescLB.text = @"-";
        self.densityMatDescLB.text = @"-";
    } else {
        for (NSDictionary *dict in [CPMaterialArray materialArray]) {
            if ([self.conveyor.matDescription intValue] == [[dict objectForKey:@"id"] intValue]) {
                self.descriptionDescLB.text = [NSString stringWithFormat:@"%@", dict[@"Name"]];
                self.densityMatDescLB.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Value"]];
            }
        }
    }
    
    self.maxTerronSizeLB.text = [CPLanguajeUtils languajeSelectedForString:@"Tamaño max. terrón (Plg)"];
    self.maxTerronSizeDescLB.text = [self.conveyor.matTerronSize isEqualToString:@""] ? @"-" : self.conveyor.matTerronSize;
    self.temperatureLB.text = [CPLanguajeUtils languajeSelectedForString:@"Temperatura (°C)"];
    self.temperatureDescLB.text = [self.conveyor.matTemperature isEqualToString:@""] || [self.conveyor.matTemperature isEqualToString:@"-18"] ? @"-" : self.conveyor.matTemperature;
    self.fallHeightLB.text = [CPLanguajeUtils languajeSelectedForString:@"Altura de caída (m)"];
    self.fallHeightDescLB.text = [self.conveyor.matHeightFall isEqualToString:@""] || [self.conveyor.matHeightFall isEqualToString:@"0"] ? @"-" : self.conveyor.matHeightFall;
    self.finesLB.text = [CPLanguajeUtils languajeSelectedForString:@"Finos (%)"];
    self.finesDescLB.text = [self.conveyor.matFinosPercentage isEqualToString:@""] ? @"-" : self.conveyor.matFinosPercentage;
    self.loadingConditionsLB.text = [CPLanguajeUtils languajeSelectedForString:@"Condiciones de carga"];
    tempString = [[NSString alloc] init];
    for (NSDictionary *dict in [CPMaterialArray conditionsArray]) {
        if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.matLoadingConditions intValue]) {
            tempString = [dict objectForKey:@"Name"];
            break;
        }
    }
    self.loadingConditionsDescLB.text = [tempString isEqualToString:@""] ? @"-" : tempString;
    self.loadingFrecuencyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Frecuencia de carga"];
    
    tempString = [[NSString alloc] init];
    for (NSDictionary *dict in [CPMaterialArray loadingFrecuencyArray]) {
        if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.matLoadingFrequency intValue]) {
            tempString = [dict objectForKey:@"Name"];
            break;
        }
    }
    self.loadingFrecuencyDescLB.text = [tempString isEqualToString:@""] ? @"-" : tempString;
    
    self.granularSizeLB.text = [CPLanguajeUtils languajeSelectedForString:@"Tamaño granular"];
    
    tempString = [[NSString alloc] init];
    for (NSDictionary *dict in [CPMaterialArray granularSizeArray]) {
        if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.matGranularSize intValue]) {
            tempString = [dict objectForKey:@"Name"];
            break;
        }
    }
    self.granularSizeDescLB.text = [tempString isEqualToString:@""] ? @"-" : tempString;
    self.nDensityLB.text = [CPLanguajeUtils languajeSelectedForString:@"Densidad"];
    
    tempString = [[NSString alloc] init];
    for (NSDictionary *dict in [CPMaterialArray densityArray]) {
        if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.matDensity intValue]) {
            tempString = [dict objectForKey:@"Name"];
            break;
        }
    }
    self.nDensityDescLB.text = [tempString isEqualToString:@""] ? @"-" : tempString;
    self.aggresitivityLB.text = [CPLanguajeUtils languajeSelectedForString:@"Agresividad"];
    
    tempString = [[NSString alloc] init];
    for (NSDictionary *dict in [CPMaterialArray aggresivityArray]) {
        if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.matAggresivity intValue]) {
            tempString = [dict objectForKey:@"Name"];
            break;
        }
    }
    self.aggresitivityDescLB.text = [tempString isEqualToString:@""] ? @"-" : tempString;
    
    self.conveyedMaterialLB.text = [CPLanguajeUtils languajeSelectedForString:@"Material transportado"];
    
    tempString = [[NSString alloc] init];
    for (NSDictionary *dict in [CPMaterialArray materialConveyedArray]) {
        if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.matMaterialConveyed intValue]) {
            tempString = [dict objectForKey:@"ShortName"];
            break;
        }
    }
    self.conveyedMaterialDescLB.text = [tempString isEqualToString:@""] ? @"-" : tempString;
    
    self.feedingConditionsLB.text = [CPLanguajeUtils languajeSelectedForString:@"Condiciones de alimentación"];
    
    tempString = [[NSString alloc] init];
    for (NSDictionary *dict in [CPMaterialArray feedingConditionsArray]) {
        if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.matFeedingConditions intValue]) {
            tempString = [dict objectForKey:@"ShortName"];
            break;
        }
    }
    self.feedingConditionsDescLB.text = [tempString isEqualToString:@""] ? @"-" : tempString;
    
    // Belt
    self.beltTitleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Banda Actual"];
    self.bandwitdthLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.bandwitdthDescLB.text = [self.conveyor.bandWidth isEqualToString:@""] ? @"-" : self.conveyor.bandWidth;
    self.bandTensionLB.text = [CPLanguajeUtils languajeSelectedForString:@"Tensión (TU) (PIW)"];
    self.bandTensionDescLB.text = [self.conveyor.bandTension isEqualToString:@""] ? @"-" : self.conveyor.bandTension;
    self.bandTopThicknessCoverLB.text = [CPLanguajeUtils languajeSelectedForString:@"Espesor cubierta superior"];
    
    tempString = [[NSString alloc] init];
    for (NSDictionary *dict in [CPActualBeltArray thicknessCoverArray]) {
        if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.bandTopThicknessCover intValue]) {
            tempString = [dict objectForKey:@"Value"];
        }
    }
    self.bandTopThicknessCoverDescLB.text = [tempString isEqualToString:@""] ? @"-" : tempString;
    
    self.bandBottomThicknessCoverLB.text = [CPLanguajeUtils languajeSelectedForString:@"Espesor cubierta inferior"];
    
    tempString = [[NSString alloc] init];
    for (NSDictionary *dict in [CPActualBeltArray thicknessCoverArray]) {
        if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.bandBottomThicknessCover intValue]) {
            tempString = [dict objectForKey:@"Value"];
        }
    }
    self.bandBottomThicknessCoverDescLB.text = [tempString isEqualToString:@""] ? @"-" : tempString;
    
    self.bandSpeedLB.text = [CPLanguajeUtils languajeSelectedForString:@"Velocidad (ft/min)"];
    self.bandSpeedDescLB.text = [self.conveyor.bandSpeed isEqualToString:@""] ? @"-" : self.conveyor.bandSpeed;
    self.bandInstalationDateLB.text = [CPLanguajeUtils languajeSelectedForString:@"Fecha de instalación"];
    self.bandInstalationDateDescLB.text = self.conveyor.bandInstallationDate == 0 || self.conveyor.bandInstallationDate == 21600 ? @"-" : [CPDateUtils stringFromTimeStamp:@(self.conveyor.bandInstallationDate)];
    self.bandBrandLB.text = [CPLanguajeUtils languajeSelectedForString:@"Marca"];
    self.bandBrandDescLB.text = [self.conveyor.bandBrand isEqualToString:@""] ? @"-" : self.conveyor.bandBrand;
    self.bandTotalDevelopmentLB.text = [CPLanguajeUtils languajeSelectedForString:@"Desarrollo total (m)"];
    self.bandTotalDevelopmentDescLB.text = [self.conveyor.bandTotalDevelopment isEqualToString:@""] || [self.conveyor.bandTotalDevelopment isEqualToString:@"0"] ? @"-" : self.conveyor.bandTotalDevelopment;
    self.bandOperationLB.text = [CPLanguajeUtils languajeSelectedForString:@"Operación hrs. por año"];
    self.bandOperationDescLB.text = [self.conveyor.bandOperation isEqualToString:@""] ? @"-" : self.conveyor.bandOperation;
    
    // Pulleys
    self.pulleysTitle.text = [CPLanguajeUtils languajeSelectedForString:@"Poleas"];
    self.drivePulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea motriz - Ø (Plg)"];
    self.drivePulleyDescLB.text = [self.conveyor.drivePulley isEqualToString:@""] ? @"-": self.conveyor.drivePulley;
    self.drivePulleyWidthLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.drivePulleyWidthDescLB.text = [self.conveyor.drivePulleyWidth isEqualToString:@""] ? @"-" : self.conveyor.drivePulleyWidth;
    self.coverPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Recubrimiento (Plg)"];
    self.coverPulleyDescLB.text = [self.conveyor.coverPulley isEqualToString:@""] ? @"-" : self.conveyor.coverPulley;
    self.contactArcPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Arco de contacto (°)"];
    
    tempString = [[NSString alloc] init];
    for (NSDictionary *dict in [CPContactArcArray contactArcArray]) {
        if ([dict[@"id"] intValue] == [self.conveyor.contactArcPulley intValue]) {
            tempString = dict[@"Value"];
        }
    }
    
    self.contactArcPulleyDescLB.text = [tempString isEqualToString:@"0"] || [tempString isEqualToString:@""] ? @"-" : tempString;
    
    self.headPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea de cabeza - Ø (Plg)"];
    self.headPulleyDescLB.text = [self.conveyor.headPulley isEqualToString:@""] ? @"-" :self.conveyor.headPulley;
    self.headPulleyWidthLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.headPulleyWidthDescLB.text = [self.conveyor.headPulleyWidth isEqualToString:@""] ? @"-" : self.conveyor.headPulleyWidth;
    self.tailPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea de cola - Ø (Plg)"];
    self.tailPulleyDescLB.text = [self.conveyor.tailPulley isEqualToString:@""] ? @"-" : self.conveyor.tailPulley;
    self.tailPulleyWidthLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.tailPulleyWidthDescLB.text = [self.conveyor.tailPulleyWidth isEqualToString:@""] ? @"-" : self.conveyor.tailPulleyWidth;
    self.contactPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea de contacto - Ø (Plg)"];
    self.contactPulleyDescLB.text = [self.conveyor.contactPulley isEqualToString:@""] ? @"-" : self.conveyor.contactPulley;
    self.contactPulleyWidthLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.contactPulleyWidthDescLB.text = [self.conveyor.contactPulleyWidth isEqualToString:@""] ? @"-" : self.conveyor.contactPulleyWidth;
    self.foldPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea de doblez - Ø (Plg)"];
    self.foldPulleyDescLB.text = [self.conveyor.foldPulley isEqualToString:@""] ? @"-" : self.conveyor.foldPulley;
    self.foldPulleyWidthLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.foldPulleyWidthDescLB.text = [self.conveyor.foldPulleyWidth isEqualToString:@""] ? @"-" : self.conveyor.foldPulleyWidth;
    self.tensorPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea tensora - Ø (Plg)"];
    self.tensorPulleyDescLB.text = [self.conveyor.tensorPulley isEqualToString:@""] ? @"-" : self.conveyor.tensorPulley;
    self.tensorPulleyWidthLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.tensorPulleyWidthDescLB.text = [self.conveyor.tensorPulleyWidth isEqualToString:@""] ? @"-" : self.conveyor.tensorPulleyWidth;
    self.additionalOnePulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea adicional1- Ø (Plg)"];
    self.additionalOnePulleyDescLB.text = [self.conveyor.additionalOnePulley isEqualToString:@""] ? @"-" : self.conveyor.additionalOnePulley;
    self.additionalOnePulleyWidthLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.additionalOnePulleyWidthDescLB.text = [self.conveyor.additionalOnePulleyWidth isEqualToString:@""] ? @"-" : self.conveyor.additionalOnePulleyWidth;
    self.additionalTwoPulleyLB.text = [CPLanguajeUtils languajeSelectedForString:@"Polea adicional2- Ø (Plg)"];
    self.additionalTwoPulleyDescLB.text = [self.conveyor.additionalTwoPulley isEqualToString:@""] ? @"-" : self.conveyor.additionalTwoPulley;
    self.additionalTwoPulleyWidthLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ancho (Plg)"];
    self.additionalTwoPulleyWidthDescLB.text = [self.conveyor.additionalTwoPulleyWidth isEqualToString:@""] ? @"-" : self.conveyor.additionalTwoPulleyWidth;
    
    // Idlers
    self.idlersTitleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Rodillos"];
    self.rodImpactDiameterLB.text = [CPLanguajeUtils languajeSelectedForString:@"Impacto Ø (Plg)"];
    self.rodImpactDiameterDescLB.text = [self.conveyor.rodImpactDiameter isEqualToString:@""] ? @"-" : self.conveyor.rodImpactDiameter;
    self.rodImpactAngleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Impacto (°)"];
    
    tempString = [[NSString alloc] init];
    for (NSDictionary *dict in [CPIdlersArray anglesImpactArray]) {
        if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.rodImpactAngle intValue]) {
            tempString = [dict objectForKey:@"Value"];
        }
    }
    self.rodImpactAngleDescLB.text = [tempString isEqualToString:@"0"] || [tempString isEqualToString:@""] ? @"-" : tempString;
    
    self.rodLoadDiameterLB.text = [CPLanguajeUtils languajeSelectedForString:@"Carga Ø (Plg)"];
    
    tempString = [[NSString alloc] init];
    for (NSDictionary *dict in [CPIdlersArray diametersLoadArray]) {
        if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.rodLoadDiameter intValue]) {
            tempString = [dict objectForKey:@"Value"];
        }
    }
    self.rodLoadDiameterDescLB.text = [tempString isEqualToString:@""] ? @"-" : tempString;
    
    self.rodLoadAngleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Carga (°)"];
    
    tempString = [[NSString alloc] init];
    for (NSDictionary *dict in [CPIdlersArray anglesLoadArray]) {
        if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.rodLoadAngle intValue]) {
            tempString = [dict objectForKey:@"Value"];
        }
    }
    self.rodLoadAngleDescLB.text = [tempString isEqualToString:@""] ? @"-" : tempString;
    
    self.rodReturnDiameterLB.text = [CPLanguajeUtils languajeSelectedForString:@"Retorno Ø (Plg)"];
    
    tempString = [[NSString alloc] init];
    for (NSDictionary *dict in [CPIdlersArray diametersReturnArray]) {
        if ([[dict objectForKey:@"id"] intValue] == [self.conveyor.rodReturnDiameter intValue]) {
            tempString = [dict objectForKey:@"Value"];
        }
    }
    self.rodReturnDiameterDescLB.text = [tempString isEqualToString:@""] ? @"-" : tempString;
    
    self.rodReturnAngleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Retorno (°)"];
    self.rodReturnAngleDescLB.text = [self.conveyor.rodReturnAngle isEqualToString:@""] ? @"-" : self.conveyor.rodReturnAngle;
    self.rodLDCSpaceLB.text = [CPLanguajeUtils languajeSelectedForString:@"Espacio (LC) (m)"];
    self.rodLDCSpaceDescLB.text = [self.conveyor.rodLDCSpace isEqualToString:@""] || [self.conveyor.rodLDCSpace isEqualToString:@"0"] ? @"-" : self.conveyor.rodLDCSpace;
    self.rodLDRSpaceLB.text = [CPLanguajeUtils languajeSelectedForString:@"Espacio (LR) (m)"];
    self.rodLDRSpaceDescLB.text = [self.conveyor.rodLDRSpace isEqualToString:@""] || [self.conveyor.rodLDRSpace isEqualToString:@"0"] ? @"-" : self.conveyor.rodLDRSpace;
    self.partTroughingLB.text = [CPLanguajeUtils languajeSelectedForString:@"Partes por artesa"];
    self.partTroughingDescLB.text = [self.conveyor.rodPartTroughing isEqualToString:@""] ? @"-" : self.conveyor.rodPartTroughing;
    
    // Observations
    self.observationsTitleLB.text = [CPLanguajeUtils languajeSelectedForString:@"Observaciones"];
    self.observationsTV.text = self.conveyor.observations;
}

#pragma mark - Constraints Methods
- (void)changeConstraint:(NSLayoutConstraint *)constraint
          withConstant:(CGFloat)constant
                 andView:(UIView *)view
                    open:(BOOL)open
{
    if (!open) {
        [self.view layoutIfNeeded];
        constraint.constant = constant;
        self.contentViewHeigthCNST.constant += constraint.constant;
        view.hidden = NO;
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];
        [self.scrollView scrollRectToVisible:view.frame
                                    animated:YES];
    } else {
        [self.view layoutIfNeeded];
        self.contentViewHeigthCNST.constant -= constraint.constant;
        constraint.constant = 0;
        view.hidden = YES;
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];
    }
    
}

#pragma mark - IBAction Methods
- (IBAction)openAndClose:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            [self changeConstraint:self.conveyorViewHeightCNST
                      withConstant:243
                           andView:self.conveyorContentView
                              open:self.isConveyorOpen];
            self.isConveyorOpen = !self.isConveyorOpen;
            break;
        }
        case 1:
        {
            [self changeConstraint:self.tensorViewHeightCNST
                      withConstant:94
                           andView:self.tensorContentView
                              open:self.isTensorOpen];
            self.isTensorOpen = !self.isTensorOpen;
            break;
        }
        case 2:
        {
            [self changeConstraint:self.materialViewHeightCNST
                      withConstant:383
                           andView:self.materialContentView
                              open:self.isMaterialOpen];
            self.isMaterialOpen = !self.isMaterialOpen;
            break;
        }
        case 3:
        {
            [self changeConstraint:self.actualBeltViewHeightCNST
                      withConstant:270
                           andView:self.actualBandContentView
                              open:self.isActualBeltOpen];
            self.isActualBeltOpen = !self.isActualBeltOpen;
            break;
        }
        case 4:
        {
            [self changeConstraint:self.pulleysViewHeightCNST
                      withConstant:530
                           andView:self.pulleysContainerView
                              open:self.isPulleysOpen];
            self.isPulleysOpen = !self.isPulleysOpen;
            break;
        }
        case 5:
        {
            [self changeConstraint:self.idlersViewHeightCNST
                      withConstant:270
                           andView:self.idlersContentView
                              open:self.isIdlersOpen];
            self.isIdlersOpen = !self.isIdlersOpen;
            break;
        }
        case 6:
        {
            [self changeConstraint:self.observationsHeightCNST
                      withConstant:216
                           andView:self.observationsContentView
                              open:self.isObservationsOpen];
            self.isObservationsOpen = !self.isObservationsOpen;
            break;
        }
        default:
            break;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditConveyorSegue"]) {
        CPAddEditConveyorViewController *addEditConveyorSegue = segue.destinationViewController;
        addEditConveyorSegue.conveyor = self.conveyor;
        addEditConveyorSegue.isEditable = YES;
    }
}

@end
