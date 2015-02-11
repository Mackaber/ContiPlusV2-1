//
//  CPConveyor.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/26/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPObject.h"

@interface CPConveyor : NSObject<NSCoding>

@property (nonatomic) int ID;
@property (nonatomic) int clientID;
@property (strong, nonatomic) NSString *serialNumber;
@property (strong, nonatomic) NSString *profileID;
@property (strong, nonatomic) NSString *transCentersDistance;
@property (strong, nonatomic) NSString *transRPMMotor;
@property (strong, nonatomic) NSString *transElevation;
@property (strong, nonatomic) NSString *transInclinationAngle;
@property (strong, nonatomic) NSString *transHPMotor;
@property (strong, nonatomic) NSString *transCapacity;
@property (strong, nonatomic) NSString *transReducerRelationship;
@property (strong, nonatomic) NSString *transLoad;
@property (strong, nonatomic) NSString *tensorType;
@property (strong, nonatomic) NSString *tensorEstimatedWeight;
@property (strong, nonatomic) NSString *tensorCareer;
@property (strong, nonatomic) NSString *matDescription;
@property (strong, nonatomic) NSString *matTerronSize;
@property (strong, nonatomic) NSString *matTemperature;
@property (strong, nonatomic) NSString *matHeightFall;
@property (strong, nonatomic) NSString *matFinosPercentage;
@property (strong, nonatomic) NSString *matLoadingConditions;
@property (strong, nonatomic) NSString *matLoadingFrequency;
@property (strong, nonatomic) NSString *matGranularSize;
@property (strong, nonatomic) NSString *matDensity;
@property (strong, nonatomic) NSString *matAggresivity;
@property (strong, nonatomic) NSString *matMaterialConveyed;
@property (strong, nonatomic) NSString *matFeedingConditions;
@property (strong, nonatomic) NSString *bandWidth;
@property (strong, nonatomic) NSString *bandTension;
@property (strong, nonatomic) NSString *bandTopThicknessCover;
@property (strong, nonatomic) NSString *bandBottomThicknessCover;
@property (strong, nonatomic) NSString *bandSpeed;
@property (nonatomic) int bandInstallationDate;
@property (strong, nonatomic) NSString *bandBrand;
@property (strong, nonatomic) NSString *bandTotalDevelopment;
@property (strong, nonatomic) NSString *bandOperation;
@property (strong, nonatomic) NSString *drivePulley;
@property (strong, nonatomic) NSString *drivePulleyWidth;
@property (strong, nonatomic) NSString *coverPulley;
@property (strong, nonatomic) NSString *contactArcPulley;
@property (strong, nonatomic) NSString *headPulley;
@property (strong, nonatomic) NSString *headPulleyWidth;
@property (strong, nonatomic) NSString *tailPulley;
@property (strong, nonatomic) NSString *tailPulleyWidth;
@property (strong, nonatomic) NSString *contactPulley;
@property (strong, nonatomic) NSString *contactPulleyWidth;
@property (strong, nonatomic) NSString *foldPulley;
@property (strong, nonatomic) NSString *foldPulleyWidth;
@property (strong, nonatomic) NSString *tensorPulley;
@property (strong, nonatomic) NSString *tensorPulleyWidth;
@property (strong, nonatomic) NSString *additionalOnePulley;
@property (strong, nonatomic) NSString *additionalOnePulleyWidth;
@property (strong, nonatomic) NSString *additionalTwoPulley;
@property (strong, nonatomic) NSString *additionalTwoPulleyWidth;
@property (strong, nonatomic) NSString *rodImpactDiameter;
@property (strong, nonatomic) NSString *rodImpactAngle;
@property (strong, nonatomic) NSString *rodLoadDiameter;
@property (strong, nonatomic) NSString *rodLoadAngle;
@property (strong, nonatomic) NSString *rodReturnDiameter;
@property (strong, nonatomic) NSString *rodReturnAngle;
@property (strong, nonatomic) NSString *rodLDCSpace;
@property (strong, nonatomic) NSString *rodLDRSpace;
@property (strong, nonatomic) NSString *rodPartTroughing;
@property (strong, nonatomic) NSString *observations;
@property (nonatomic) int coverImgID;
@property (strong, nonatomic) NSString *trackingUrl;
@property (nonatomic) int createdAt;
@property (nonatomic) int updatedAt;

+ (instancetype)conveyorClientID:(int)clientID
                    serialNumber:(NSString *)serialNumber
                       profileID:(NSString *)profileID
            transCentersDistance:(NSString *)transCentersDistance
                   transRPMMotor:(NSString *)transRPMMotor
                  transElevation:(NSString *)transElevation
           transInclinationAngle:(NSString *)transInclinationAngle
                    transHPMotor:(NSString *)transHPMotor
                   transCapacity:(NSString *)transCapacity
        transReducerRelationship:(NSString *)transReducerRelationship
                       transLoad:(NSString *)transLoad
                      tensorType:(NSString *)tensorType
           tensorEstimatedWeight:(NSString *)tensorEstimatedWeight
                    tensorCareer:(NSString *)tensorCareer
                  matDescription:(NSString *)matDescription
                   matTerronSize:(NSString *)matTerronSize
                  matTemperature:(NSString *)matTemperature
                   matHeightFall:(NSString *)matHeightFall
              matFinosPercentage:(NSString *)matFinosPercentage
            matLoadingConditions:(NSString *)matLoadingConditions
             matLoadingFrequency:(NSString *)matLoadingFrequency
                 matGranularSize:(NSString *)matGranularSize
                      matDensity:(NSString *)matDensity
                  matAggresivity:(NSString *)matAggresivity
             matMaterialConveyed:(NSString *)matMaterialConveyed
            matFeedingConditions:(NSString *)matFeedingConditions
                       bandWidth:(NSString *)bandWidth
                     bandTension:(NSString *)bandTension
           bandTopThicknessCover:(NSString *)bandTopThicknessCover
        bandBottomThicknessCover:(NSString *)bandBottomThicknessCover
                       bandSpeed:(NSString *)bandSpeed
            bandInstallationDate:(int)bandInstallationDate
                       bandBrand:(NSString *)bandBrand
            bandTotalDevelopment:(NSString *)bandTotalDevelopment
                   bandOperation:(NSString *)bandOperation
                     drivePulley:(NSString *)drivePulley
                drivePulleyWidth:(NSString *)drivePulleyWidth
                     coverPulley:(NSString *)coverPulley
                contactArcPulley:(NSString *)contactArcPulley
                      headPulley:(NSString *)headPulley
                 headPulleyWidth:(NSString *)headPulleyWidth
                      tailPulley:(NSString *)tailPulley
                 tailPulleyWidth:(NSString *)tailPulleyWidth
                   contactPulley:(NSString *)contactPulley
              contactPulleyWidth:(NSString *)contactPulleyWidth
                      foldPulley:(NSString *)foldPulley
                 foldPulleyWidth:(NSString *)foldPulleyWidth
                    tensorPulley:(NSString *)tensorPulley
               tensorPulleyWidth:(NSString *)tensorPulleyWidth
             additionalOnePulley:(NSString *)additionalOnePulley
        additionalOnePulleyWidth:(NSString *)additionalOnePulleyWidth
             additionalTwoPulley:(NSString *)additionalTwoPulley
        additionalTwoPulleyWidth:(NSString *)additionalTwoPulleyWidth
               rodImpactDiameter:(NSString *)rodImpactDiameter
                  rodImpactAngle:(NSString *)rodImpactAngle
                 rodLoadDiameter:(NSString *)rodLoadDiameter
                    rodLoadAngle:(NSString *)rodLoadAngle
               rodReturnDiameter:(NSString *)rodReturnDiameter
                  rodReturnAngle:(NSString *)rodReturnAngle
                     rodLDCSpace:(NSString *)rodLDCSpace
                     rodLDRSpace:(NSString *)rodLDRSpace
                rodPartTroughing:(NSString *)rodPartTroughing
                    observations:(NSString *)observations
                      coverImgID:(int)coverImgID
                       createdAt:(int)createdAt
                       updatedAt:(int)updatedAt;

+ (instancetype)conveyorWithJSONDictionary:(NSDictionary *)dictionary;

+ (void)getAllConveyorsWithAuthenticationKey:(NSString *)authenticationKey
                           completionHandler:(void(^)(NSURLResponse *response, NSError *error))completionHandler;

+ (void)saveConveyorWithAuthenticationKey:(NSString *)authenticationKey
                              clientID:(int)clientID
                          serialNumber:(NSString *)serialNumber
                             profileID:(NSString *)profileID
                  transCentersDistance:(NSString *)transCentersDistance
                         transRPMMotor:(NSString *)transRPMMotor
                        transElevation:(NSString *)transElevation
                 transInclinationAngle:(NSString *)transInclinationAngle
                          transHPMotor:(NSString *)transHPMotor
                         transCapacity:(NSString *)transCapacity
              transReducerRelationship:(NSString *)transReducerRelationship
                             transLoad:(NSString *)transLoad
                            tensorType:(NSString *)tensorType
                 tensorEstimatedWeight:(NSString *)tensorEstimatedWeight
                          tensorCareer:(NSString *)tensorCareer
                        matDescription:(NSString *)matDescription
                         matTerronSize:(NSString *)matTerronSize
                        matTemperature:(NSString *)matTemperature
                         matHeightFall:(NSString *)matHeightFall
                    matFinosPercentage:(NSString *)matFinosPercentage
                  matLoadingConditions:(NSString *)matLoadingConditions
                   matLoadingFrequency:(NSString *)matLoadingFrequency
                       matGranularSize:(NSString *)matGranularSize
                            matDensity:(NSString *)matDensity
                        matAggresivity:(NSString *)matAggresivity
                   matMaterialConveyed:(NSString *)matMaterialConveyed
                  matFeedingConditions:(NSString *)matFeedingConditions
                             bandWidth:(NSString *)bandWidth
                           bandTension:(NSString *)bandTension
                 bandTopThicknessCover:(NSString *)bandTopThicknessCover
              bandBottomThicknessCover:(NSString *)bandBottomThicknessCover
                             bandSpeed:(NSString *)bandSpeed
                  bandInstallationDate:(int)bandInstallationDate
                             bandBrand:(NSString *)bandBrand
                  bandTotalDevelopment:(NSString *)bandTotalDevelopment
                         bandOperation:(NSString *)bandOperation
                           drivePulley:(NSString *)drivePulley
                      drivePulleyWidth:(NSString *)drivePulleyWidth
                           coverPulley:(NSString *)coverPulley
                      contactArcPulley:(NSString *)contactArcPulley
                            headPulley:(NSString *)headPulley
                       headPulleyWidth:(NSString *)headPulleyWidth
                            tailPulley:(NSString *)tailPulley
                       tailPulleyWidth:(NSString *)tailPulleyWidth
                         contactPulley:(NSString *)contactPulley
                    contactPulleyWidth:(NSString *)contactPulleyWidth
                            foldPulley:(NSString *)foldPulley
                       foldPulleyWidth:(NSString *)foldPulleyWidth
                          tensorPulley:(NSString *)tensorPulley
                     tensorPulleyWidth:(NSString *)tensorPulleyWidth
                   additionalOnePulley:(NSString *)additionalOnePulley
              additionalOnePulleyWidth:(NSString *)additionalOnePulleyWidth
                   additionalTwoPulley:(NSString *)additionalTwoPulley
              additionalTwoPulleyWidth:(NSString *)additionalTwoPulleyWidth
                     rodImpactDiameter:(NSString *)rodImpactDiameter
                        rodImpactAngle:(NSString *)rodImpactAngle
                       rodLoadDiameter:(NSString *)rodLoadDiameter
                          rodLoadAngle:(NSString *)rodLoadAngle
                     rodReturnDiameter:(NSString *)rodReturnDiameter
                        rodReturnAngle:(NSString *)rodReturnAngle
                           rodLDCSpace:(NSString *)rodLDCSpace
                           rodLDRSpace:(NSString *)rodLDRSpace
                      rodPartTroughing:(NSString *)rodPartTroughing
                          observations:(NSString *)observations
                            coverImgID:(int)coverImgID
                             createdAt:(int)createdAt
                             updatedAt:(int)updatedAt
                     completionHandler:(void(^)(BOOL success, int conveyorID))completionHandler;

+ (void)updateConveyorWithAuthenticationKey:(NSString *)authenticationKey
                                 conveyorID:(int)conveyorID
                                 clientID:(int)clientID
                             serialNumber:(NSString *)serialNumber
                                profileID:(NSString *)profileID
                     transCentersDistance:(NSString *)transCentersDistance
                            transRPMMotor:(NSString *)transRPMMotor
                           transElevation:(NSString *)transElevation
                    transInclinationAngle:(NSString *)transInclinationAngle
                             transHPMotor:(NSString *)transHPMotor
                            transCapacity:(NSString *)transCapacity
                 transReducerRelationship:(NSString *)transReducerRelationship
                                transLoad:(NSString *)transLoad
                               tensorType:(NSString *)tensorType
                    tensorEstimatedWeight:(NSString *)tensorEstimatedWeight
                             tensorCareer:(NSString *)tensorCareer
                           matDescription:(NSString *)matDescription
                            matTerronSize:(NSString *)matTerronSize
                           matTemperature:(NSString *)matTemperature
                            matHeightFall:(NSString *)matHeightFall
                       matFinosPercentage:(NSString *)matFinosPercentage
                     matLoadingConditions:(NSString *)matLoadingConditions
                      matLoadingFrequency:(NSString *)matLoadingFrequency
                          matGranularSize:(NSString *)matGranularSize
                               matDensity:(NSString *)matDensity
                           matAggresivity:(NSString *)matAggresivity
                      matMaterialConveyed:(NSString *)matMaterialConveyed
                     matFeedingConditions:(NSString *)matFeedingConditions
                                bandWidth:(NSString *)bandWidth
                              bandTension:(NSString *)bandTension
                    bandTopThicknessCover:(NSString *)bandTopThicknessCover
                 bandBottomThicknessCover:(NSString *)bandBottomThicknessCover
                                bandSpeed:(NSString *)bandSpeed
                     bandInstallationDate:(int)bandInstallationDate
                                bandBrand:(NSString *)bandBrand
                     bandTotalDevelopment:(NSString *)bandTotalDevelopment
                            bandOperation:(NSString *)bandOperation
                              drivePulley:(NSString *)drivePulley
                         drivePulleyWidth:(NSString *)drivePulleyWidth
                              coverPulley:(NSString *)coverPulley
                         contactArcPulley:(NSString *)contactArcPulley
                               headPulley:(NSString *)headPulley
                          headPulleyWidth:(NSString *)headPulleyWidth
                               tailPulley:(NSString *)tailPulley
                          tailPulleyWidth:(NSString *)tailPulleyWidth
                            contactPulley:(NSString *)contactPulley
                       contactPulleyWidth:(NSString *)contactPulleyWidth
                               foldPulley:(NSString *)foldPulley
                          foldPulleyWidth:(NSString *)foldPulleyWidth
                             tensorPulley:(NSString *)tensorPulley
                        tensorPulleyWidth:(NSString *)tensorPulleyWidth
                      additionalOnePulley:(NSString *)additionalOnePulley
                 additionalOnePulleyWidth:(NSString *)additionalOnePulleyWidth
                      additionalTwoPulley:(NSString *)additionalTwoPulley
                 additionalTwoPulleyWidth:(NSString *)additionalTwoPulleyWidth
                        rodImpactDiameter:(NSString *)rodImpactDiameter
                           rodImpactAngle:(NSString *)rodImpactAngle
                          rodLoadDiameter:(NSString *)rodLoadDiameter
                             rodLoadAngle:(NSString *)rodLoadAngle
                        rodReturnDiameter:(NSString *)rodReturnDiameter
                           rodReturnAngle:(NSString *)rodReturnAngle
                              rodLDCSpace:(NSString *)rodLDCSpace
                              rodLDRSpace:(NSString *)rodLDRSpace
                         rodPartTroughing:(NSString *)rodPartTroughing
                             observations:(NSString *)observations
                               coverImgID:(int)coverImgID
                                createdAt:(int)createdAt
                                updatedAt:(int)updatedAt
                        completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)deleteConveyorWithWithAuthenticationKey:(NSString *)authenticationKey
                                             ID:(int)ID
                              completionHandler:(void(^)(BOOL success))completionHandler;

+ (void)getConveyorLifeTimeWithAuthenticationKey:(NSString *)authenticationKey
                                              ID:(int)ID
                               completionHandler:(void(^)(BOOL success, NSDictionary *lifetimeDictionary))completionHandler;

+ (void)requestConveyorQuoteWithAuthenticationKey:(NSString *)authenticationKey
                                               ID:(int)ID
                                completionHandler:(void(^)(BOOL success))completionHandler;

+ (BOOL)uploadCacheElement:(CPObject *)element
               forConveyor:(int)ID;


@end