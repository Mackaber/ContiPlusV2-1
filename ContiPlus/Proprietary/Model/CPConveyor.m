//
//  CPConveyor.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/26/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPConveyor.h"
#import "CPLanguajeUtils.h"
#import "CPImage.h"
#import "CPVideo.h"
#import "CPUser.h"
#import "CPFileUtils.h"

@implementation CPConveyor

- (id)init
{
    if ((self = [super init])) {
        _ID = 0;
        _clientID = 0;
        _serialNumber = @"";
        _profileID = @"";
        _transCentersDistance = @"";
        _transRPMMotor = @"";
        _transElevation = @"";
        _transInclinationAngle = @"";
        _transHPMotor = @"";
        _transCapacity = @"";
        _transReducerRelationship = @"";
        _transLoad = @"";
        _tensorType = @"";
        _tensorEstimatedWeight = @"";
        _tensorCareer = @"";
        _matDescription = @"";
        _matTerronSize = @"";
        _matTemperature = @"";
        _matHeightFall = @"";
        _matFinosPercentage = @"";
        _matLoadingConditions = @"";
        _matLoadingFrequency = @"";
        _matGranularSize = @"";
        _matDensity = @"";
        _matAggresivity = @"";
        _matMaterialConveyed = @"";
        _matFeedingConditions = @"";
        _bandWidth = @"";
        _bandTension = @"";
        _bandTopThicknessCover = @"";
        _bandBottomThicknessCover = @"";
        _bandSpeed = @"";
        _bandInstallationDate = 0;
        _bandBrand = @"";
        _bandTotalDevelopment = @"";
        _bandOperation = @"";
        _drivePulley = @"";
        _drivePulleyWidth = @"";
        _coverPulley = @"";
        _contactArcPulley = @"";
        _headPulley = @"";
        _headPulleyWidth = @"";
        _tailPulley = @"";
        _tailPulleyWidth = @"";
        _contactPulley = @"";
        _contactPulleyWidth = @"";
        _foldPulley = @"";
        _foldPulleyWidth = @"";
        _tensorPulley = @"";
        _tensorPulleyWidth = @"";
        _additionalOnePulley = @"";
        _additionalOnePulleyWidth = @"";
        _additionalTwoPulley = @"";
        _additionalTwoPulleyWidth = @"";
        _rodImpactDiameter = @"";
        _rodImpactAngle = @"";
        _rodLoadDiameter = @"";
        _rodLoadAngle = @"";
        _rodReturnDiameter = @"";
        _rodReturnAngle = @"";
        _rodLDCSpace = @"";
        _rodLDRSpace = @"";
        _rodPartTroughing = @"";
        _observations = @"";
        _coverImgID = 0;
        _trackingUrl = @"";
        _createdAt = 0;
        _updatedAt = 0;
    }
    
    return self;
}

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
                       updatedAt:(int)updatedAt
{
    CPConveyor *conveyor = [[self alloc] init];
    conveyor.clientID = clientID;
    conveyor.serialNumber = serialNumber;
    conveyor.profileID = profileID;
    conveyor.transCentersDistance = transCentersDistance;
    conveyor.transRPMMotor = transRPMMotor;
    conveyor.transElevation = transElevation;
    conveyor.transInclinationAngle = transInclinationAngle;
    conveyor.transHPMotor = transHPMotor;
    conveyor.transCapacity = transCapacity;
    conveyor.transReducerRelationship = transReducerRelationship;
    conveyor.transLoad = transLoad;
    conveyor.tensorType = tensorType;
    conveyor.tensorEstimatedWeight = tensorEstimatedWeight;
    conveyor.tensorCareer = tensorCareer;
    conveyor.matDescription = matDescription;
    conveyor.matTerronSize = matTerronSize;
    conveyor.matTemperature = matTemperature;
    conveyor.matHeightFall = matHeightFall;
    conveyor.matFinosPercentage = matFinosPercentage;
    conveyor.matLoadingConditions = matLoadingConditions;
    conveyor.matLoadingFrequency = matLoadingFrequency;
    conveyor.matGranularSize = matGranularSize;
    conveyor.matDensity = matDensity;
    conveyor.matAggresivity = matAggresivity;
    conveyor.matMaterialConveyed = matMaterialConveyed;
    conveyor.matFeedingConditions = matFeedingConditions;
    conveyor.bandWidth = bandWidth;
    conveyor.bandTension = bandTension;
    conveyor.bandTopThicknessCover = bandTopThicknessCover;
    conveyor.bandBottomThicknessCover = bandBottomThicknessCover;
    conveyor.bandSpeed = bandSpeed;
    conveyor.bandInstallationDate = bandInstallationDate;
    conveyor.bandBrand = bandBrand;
    conveyor.bandTotalDevelopment = bandTotalDevelopment;
    conveyor.bandOperation = bandOperation;
    conveyor.drivePulley = drivePulley;
    conveyor.drivePulleyWidth = drivePulleyWidth;
    conveyor.coverPulley = coverPulley;
    conveyor.contactArcPulley = contactArcPulley;
    conveyor.headPulley = headPulley;
    conveyor.headPulleyWidth = headPulleyWidth;
    conveyor.tailPulley = tailPulley;
    conveyor.tailPulleyWidth = tailPulleyWidth;
    conveyor.contactPulley = contactPulley;
    conveyor.contactPulleyWidth = contactPulleyWidth;
    conveyor.foldPulley = foldPulley;
    conveyor.foldPulleyWidth = foldPulleyWidth;
    conveyor.tensorPulley = tensorPulley;
    conveyor.tensorPulleyWidth = tensorPulleyWidth;
    conveyor.additionalOnePulley = additionalOnePulley;
    conveyor.additionalOnePulleyWidth = additionalOnePulleyWidth;
    conveyor.additionalTwoPulley = additionalTwoPulley;
    conveyor.additionalTwoPulleyWidth = additionalTwoPulleyWidth;
    conveyor.rodImpactDiameter = rodImpactDiameter;
    conveyor.rodImpactAngle = rodImpactAngle;
    conveyor.rodLoadDiameter = rodLoadDiameter;
    conveyor.rodLoadAngle = rodLoadAngle;
    conveyor.rodReturnDiameter = rodReturnDiameter;
    conveyor.rodReturnAngle = rodReturnAngle;
    conveyor.rodLDCSpace = rodLDCSpace;
    conveyor.rodLDRSpace = rodLDRSpace;
    conveyor.rodPartTroughing = rodPartTroughing;
    conveyor.observations = observations;
    conveyor.createdAt = createdAt;
    conveyor.updatedAt = updatedAt;
    
    return conveyor;
}

+ (instancetype)conveyorWithJSONDictionary:(NSDictionary *)dictionary
{
    CPConveyor *conveyor = [[self alloc] init];
    conveyor.ID                         = [dictionary[@"id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"id"] intValue];
    conveyor.clientID                   = [dictionary[@"client_id"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"client_id"] intValue];
    conveyor.serialNumber               = [dictionary[@"numero"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"numero"];
    conveyor.profileID                  = [dictionary[@"profile_id"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"profile_id"];
    conveyor.transCentersDistance       = [dictionary[@"trans_distancia_centros"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"trans_distancia_centros"];
    conveyor.transRPMMotor              = [dictionary[@"trans_rpm_motor"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"trans_rpm_motor"];
    conveyor.transElevation             = [dictionary[@"trans_elevacion"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"trans_elevacion"];
    conveyor.transInclinationAngle      = [dictionary[@"trans_angulo_inclinacion"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"trans_angulo_inclinacion"];
    conveyor.transHPMotor               = [dictionary[@"trans_hp_motor"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"trans_hp_motor"];
    conveyor.transCapacity              = [dictionary[@"trans_capacidad"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"trans_capacidad"];
    conveyor.transReducerRelationship   = [dictionary[@"trans_relacion_reductor"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"trans_relacion_reductor"];
    conveyor.transLoad                  = [dictionary[@"trans_carga"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"trans_carga"];
    conveyor.tensorType                 = [dictionary[@"tensor_tipo"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"tensor_tipo"];
    conveyor.tensorEstimatedWeight      = [dictionary[@"tensor_peso_estimado"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"tensor_peso_estimado"];
    conveyor.tensorCareer               = [dictionary[@"tensor_carrera"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"tensor_carrera"];
    conveyor.matDescription             = [dictionary[@"mat_descripcion"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"mat_descripcion"];
    conveyor.matTerronSize              = [dictionary[@"mat_tam_terron"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"mat_tam_terron"];
    conveyor.matTemperature             = [dictionary[@"mat_temperatura"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"mat_temperatura"];
    conveyor.matHeightFall              = [dictionary[@"mat_altura_caida"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"mat_altura_caida"];
    conveyor.matFinosPercentage         = [dictionary[@"mat_porcentaje_finos"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"mat_porcentaje_finos"];
    conveyor.matLoadingConditions       = [dictionary[@"mat_condicion_carga"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"mat_condicion_carga"];
    conveyor.matLoadingFrequency        = [dictionary[@"mat_frecuencia_carga"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"mat_frecuencia_carga"];
    conveyor.matGranularSize            = [dictionary[@"mat_tamanio_granular"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"mat_tamanio_granular"];
    conveyor.matDensity                 = [dictionary[@"mat_tipo_densidad"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"mat_tipo_densidad"];
    conveyor.matAggresivity             = [dictionary[@"mat_agresividad"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"mat_agresividad"];
    conveyor.matMaterialConveyed        = [dictionary[@"mat_grado_mat_transportado"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"mat_grado_mat_transportado"];
    conveyor.matFeedingConditions       = [dictionary[@"mat_condicion_alimentacion"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"mat_condicion_alimentacion"];
    conveyor.bandWidth                  = [dictionary[@"banda_ancho"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"banda_ancho"];
    conveyor.bandTension                = [dictionary[@"banda_tension"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"banda_tension"];
    conveyor.bandTopThicknessCover      = [dictionary[@"id_espesor_cubierta_sup"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"id_espesor_cubierta_sup"];
    conveyor.bandBottomThicknessCover   = [dictionary[@"id_espesor_cubierta_inf"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"id_espesor_cubierta_inf"];
    conveyor.bandSpeed                  = [dictionary[@"banda_velocidad"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"banda_velocidad"];
    conveyor.bandInstallationDate       = [dictionary[@"banda_fecha_instalacion"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"banda_fecha_instalacion"] intValue];
    conveyor.bandBrand                  = [dictionary[@"banda_marca"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"banda_marca"];
    conveyor.bandTotalDevelopment       = [dictionary[@"banda_desarrollo_total"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"banda_desarrollo_total"];
    conveyor.bandOperation              = [dictionary[@"banda_operacion"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"banda_operacion"];
    conveyor.drivePulley                = [dictionary[@"polea_motriz"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"polea_motriz"];
    conveyor.drivePulleyWidth           = [dictionary[@"ancho_polea_motriz"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"ancho_polea_motriz"];
    conveyor.coverPulley                = [dictionary[@"polea_recubrimiento"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"polea_recubrimiento"];
    conveyor.contactArcPulley           = [dictionary[@"polea_arco_contacto"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", dictionary[@"polea_arco_contacto"]];
    conveyor.headPulley                 = [dictionary[@"polea_cabeza"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"polea_cabeza"];
    conveyor.headPulleyWidth            = [dictionary[@"ancho_pol_cabeza"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"ancho_pol_cabeza"];
    conveyor.tailPulley                 = [dictionary[@"polea_cola"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"polea_cola"];
    conveyor.tailPulleyWidth            = [dictionary[@"ancho_pol_cola"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"ancho_pol_cola"];
    conveyor.contactPulley              = [dictionary[@"polea_contacto"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"polea_contacto"];
    conveyor.contactPulleyWidth         = [dictionary[@"ancho_pol_contacto"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"ancho_pol_contacto"];
    conveyor.foldPulley                 = [dictionary[@"polea_doblez"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"polea_doblez"];
    conveyor.foldPulleyWidth            = [dictionary[@"ancho_pol_doblez"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"ancho_pol_doblez"];
    conveyor.tensorPulley               = [dictionary[@"polea_tensora"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"polea_tensora"];
    conveyor.tensorPulleyWidth          = [dictionary[@"ancho_pol_tensora"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"ancho_pol_tensora"];
    conveyor.additionalOnePulley        = [dictionary[@"polea_uno_adicional"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"polea_uno_adicional"];
    conveyor.additionalOnePulleyWidth   = [dictionary[@"ancho_polea_uno_adicional"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"ancho_polea_uno_adicional"];
    conveyor.additionalTwoPulley        = [dictionary[@"polea_dos_adicional"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"ancho_pol_dos_adicional"];
    conveyor.additionalTwoPulleyWidth   = [dictionary[@"ancho_pol_dos_adicional"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"ancho_pol_dos_adicional"];
    conveyor.rodImpactDiameter          = [dictionary[@"rod_diam_impacto"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"rod_diam_impacto"];
    conveyor.rodImpactAngle             = [dictionary[@"rod_ang_impacto"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"rod_ang_impacto"];
    conveyor.rodLoadDiameter            = [dictionary[@"rod_diam_carga"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"rod_diam_carga"];
    conveyor.rodLoadAngle               = [dictionary[@"rod_ang_carga"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"rod_ang_carga"];
    conveyor.rodReturnDiameter          = [dictionary[@"rod_diam_retorno"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"rod_diam_retorno"];
    conveyor.rodReturnAngle             = [dictionary[@"rod_ang_retorno"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"rod_ang_retorno"];
    conveyor.rodLDCSpace                = [dictionary[@"rod_espacio_ldc"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"rod_espacio_ldc"];
    conveyor.rodLDRSpace                = [dictionary[@"rod_espacio_ldr"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"rod_espacio_ldr"];
    conveyor.rodPartTroughing           = [dictionary[@"rod_partes_artesa"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"rod_partes_artesa"];
    conveyor.observations               = [dictionary[@"observaciones"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"observaciones"];
    conveyor.trackingUrl                = [dictionary[@"tracking_url"] isKindOfClass:[NSNull class]] ? @"" : dictionary[@"tracking_url"];
    conveyor.coverImgID                 = [dictionary[@"cover_img"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"cover_img"] intValue];
    conveyor.createdAt                  = [dictionary[@"created_at"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"created_at"] intValue];
    conveyor.updatedAt                  = [dictionary[@"updated_at"] isKindOfClass:[NSNull class]] ? 0 : [dictionary[@"updated_at"] intValue];
    
    return conveyor;
}

#pragma mark - NSCoding Protocols
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.ID) forKey:@"ID"];
    [aCoder encodeObject:@(self.clientID) forKey:@"clientID"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:self.profileID forKey:@"profileID"];
    [aCoder encodeObject:self.transCentersDistance forKey:@"transCentersDistance"];
    [aCoder encodeObject:self.transRPMMotor forKey:@"transRPMMotor"];
    [aCoder encodeObject:self.transElevation forKey:@"transElevation"];
    [aCoder encodeObject:self.transInclinationAngle forKey:@"transInclinationAngle"];
    [aCoder encodeObject:self.transHPMotor forKey:@"transHPMotor"];
    [aCoder encodeObject:self.transCapacity forKey:@"transCapacity"];
    [aCoder encodeObject:self.transReducerRelationship forKey:@"transReducerRelationship"];
    [aCoder encodeObject:self.transLoad forKey:@"transLoad"];
    [aCoder encodeObject:self.tensorType forKey:@"tensorType"];
    [aCoder encodeObject:self.tensorEstimatedWeight forKey:@"tensorEstimatedWeight"];
    [aCoder encodeObject:self.tensorCareer forKey:@"tensorCareer"];
    [aCoder encodeObject:self.matDescription forKey:@"matDescription"];
    [aCoder encodeObject:self.matTerronSize forKey:@"matTerronSize"];
    [aCoder encodeObject:self.matTemperature forKey:@"matTemperature"];
    [aCoder encodeObject:self.matHeightFall forKey:@"matHeightFall"];
    [aCoder encodeObject:self.matFinosPercentage forKey:@"matFinosPercentage"];
    [aCoder encodeObject:self.matLoadingConditions forKey:@"matLoadingConditions"];
    [aCoder encodeObject:self.matLoadingFrequency forKey:@"matLoadingFrequency"];
    [aCoder encodeObject:self.matGranularSize forKey:@"matGranularSize"];
    [aCoder encodeObject:self.matDensity forKey:@"matDensity"];
    [aCoder encodeObject:self.matAggresivity forKey:@"matAggresivity"];
    [aCoder encodeObject:self.matMaterialConveyed forKey:@"matMaterialConveyed"];
    [aCoder encodeObject:self.matFeedingConditions forKey:@"matFeedingConditions"];
    [aCoder encodeObject:self.bandWidth forKey:@"bandWidth"];
    [aCoder encodeObject:self.bandTension forKey:@"bandTension"];
    [aCoder encodeObject:self.bandTopThicknessCover forKey:@"bandTopThicknessCover"];
    [aCoder encodeObject:self.bandBottomThicknessCover forKey:@"bandBottomThicknessCover"];
    [aCoder encodeObject:self.bandSpeed forKey:@"bandSpeed"];
    [aCoder encodeObject:@(self.bandInstallationDate) forKey:@"bandInstallationDate"];
    [aCoder encodeObject:self.bandBrand forKey:@"bandBrand"];
    [aCoder encodeObject:self.bandTotalDevelopment forKey:@"bandTotalDevelopment"];
    [aCoder encodeObject:self.bandOperation forKey:@"bandOperation"];
    [aCoder encodeObject:self.drivePulley forKey:@"drivePulley"];
    [aCoder encodeObject:self.drivePulleyWidth forKey:@"drivePulleyWidth"];
    [aCoder encodeObject:self.coverPulley forKey:@"coverPulley"];
    [aCoder encodeObject:self.contactArcPulley forKey:@"contactArcPulley"];
    [aCoder encodeObject:self.headPulley forKey:@"headPulley"];
    [aCoder encodeObject:self.headPulleyWidth forKey:@"headPulleyWidth"];
    [aCoder encodeObject:self.tailPulley forKey:@"tailPulley"];
    [aCoder encodeObject:self.tailPulleyWidth forKey:@"tailPulleyWidth"];
    [aCoder encodeObject:self.contactPulley forKey:@"contactPulley"];
    [aCoder encodeObject:self.contactPulleyWidth forKey:@"contactPulleyWidth"];
    [aCoder encodeObject:self.foldPulley forKey:@"foldPulley"];
    [aCoder encodeObject:self.foldPulleyWidth forKey:@"foldPulleyWidth"];
    [aCoder encodeObject:self.tensorPulley forKey:@"tensorPulley"];
    [aCoder encodeObject:self.tensorPulleyWidth forKey:@"tensorPulleyWidth"];
    [aCoder encodeObject:self.additionalOnePulley forKey:@"additionalOnePulley"];
    [aCoder encodeObject:self.additionalOnePulleyWidth forKey:@"additionalOnePulleyWidth"];
    [aCoder encodeObject:self.additionalTwoPulley forKey:@"additionalTwoPulley"];
    [aCoder encodeObject:self.additionalTwoPulleyWidth forKey:@"additionalTwoPulleyWidth"];
    [aCoder encodeObject:self.rodImpactDiameter forKey:@"rodImpactDiameter"];
    [aCoder encodeObject:self.rodImpactAngle forKey:@"rodImpactAngle"];
    [aCoder encodeObject:self.rodLoadDiameter forKey:@"rodLoadDiameter"];
    [aCoder encodeObject:self.rodLoadAngle forKey:@"rodLoadAngle"];
    [aCoder encodeObject:self.rodReturnDiameter forKey:@"rodReturnDiameter"];
    [aCoder encodeObject:self.rodReturnAngle forKey:@"rodReturnAngle"];
    [aCoder encodeObject:self.rodLDCSpace forKey:@"rodLDCSpace"];
    [aCoder encodeObject:self.rodLDRSpace forKey:@"rodLDRSpace"];
    [aCoder encodeObject:self.rodPartTroughing forKey:@"rodPartTroughing"];
    [aCoder encodeObject:self.observations forKey:@"observations"];
    [aCoder encodeObject:@(self.coverImgID) forKey:@"coverImgID"];
    [aCoder encodeObject:self.trackingUrl forKey:@"trackingUrl"];
    [aCoder encodeObject:@(self.createdAt) forKey:@"createdAt"];
    [aCoder encodeObject:@(self.updatedAt) forKey:@"updatedAt"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.ID = [[aDecoder decodeObjectForKey:@"ID"] intValue];
        self.clientID = [[aDecoder decodeObjectForKey:@"clientID"] intValue];
        self.serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        self.profileID = [aDecoder decodeObjectForKey:@"profileID"];
        self.transCentersDistance = [aDecoder decodeObjectForKey:@"transCentersDistance"];
        self.transRPMMotor = [aDecoder decodeObjectForKey:@"transRPMMotor"];
        self.transElevation = [aDecoder decodeObjectForKey:@"transElevation"];
        self.transInclinationAngle = [aDecoder decodeObjectForKey:@"transInclinationAngle"];
        self.transHPMotor = [aDecoder decodeObjectForKey:@"transHPMotor"];
        self.transCapacity = [aDecoder decodeObjectForKey:@"transCapacity"];
        self.transReducerRelationship = [aDecoder decodeObjectForKey:@"transReducerRelationship"];
        self.transLoad = [aDecoder decodeObjectForKey:@"transLoad"];
        self.tensorType = [aDecoder decodeObjectForKey:@"tensorType"];
        self.tensorEstimatedWeight = [aDecoder decodeObjectForKey:@"tensorEstimatedWeight"];
        self.tensorCareer = [aDecoder decodeObjectForKey:@"tensorCareer"];
        self.matDescription = [aDecoder decodeObjectForKey:@"matDescription"];
        self.matTerronSize = [aDecoder decodeObjectForKey:@"matTerronSize"];
        self.matTemperature = [aDecoder decodeObjectForKey:@"matTemperature"];
        self.matHeightFall = [aDecoder decodeObjectForKey:@"matHeightFall"];
        self.matFinosPercentage = [aDecoder decodeObjectForKey:@"matFinosPercentage"];
        self.matLoadingConditions = [aDecoder decodeObjectForKey:@"matLoadingConditions"];
        self.matLoadingFrequency = [aDecoder decodeObjectForKey:@"matLoadingFrequency"];
        self.matGranularSize = [aDecoder decodeObjectForKey:@"matGranularSize"];
        self.matDensity = [aDecoder decodeObjectForKey:@"matDensity"];
        self.matAggresivity = [aDecoder decodeObjectForKey:@"matAggresivity"];
        self.matMaterialConveyed = [aDecoder decodeObjectForKey:@"matMaterialConveyed"];
        self.matFeedingConditions = [aDecoder decodeObjectForKey:@"matFeedingConditions"];
        self.bandWidth = [aDecoder decodeObjectForKey:@"bandWidth"];
        self.bandTension = [aDecoder decodeObjectForKey:@"bandTension"];
        self.bandTopThicknessCover = [aDecoder decodeObjectForKey:@"bandTopThicknessCover"];
        self.bandBottomThicknessCover = [aDecoder decodeObjectForKey:@"bandBottomThicknessCover"];
        self.bandSpeed = [aDecoder decodeObjectForKey:@"bandSpeed"];
        self.bandInstallationDate = [[aDecoder decodeObjectForKey:@"bandInstallationDate"] intValue];
        self.bandBrand = [aDecoder decodeObjectForKey:@"bandBrand"];
        self.bandTotalDevelopment = [aDecoder decodeObjectForKey:@"bandTotalDevelopment"];
        self.bandOperation = [aDecoder decodeObjectForKey:@"bandOperation"];
        self.drivePulley = [aDecoder decodeObjectForKey:@"drivePulley"];
        self.drivePulleyWidth = [aDecoder decodeObjectForKey:@"drivePulleyWidth"];
        self.coverPulley = [aDecoder decodeObjectForKey:@"coverPulley"];
        self.contactArcPulley = [aDecoder decodeObjectForKey:@"contactArcPulley"];
        self.headPulley = [aDecoder decodeObjectForKey:@"headPulley"];
        self.headPulleyWidth = [aDecoder decodeObjectForKey:@"headPulleyWidth"];
        self.tailPulley = [aDecoder decodeObjectForKey:@"tailPulley"];
        self.tailPulleyWidth = [aDecoder decodeObjectForKey:@"tailPulleyWidth"];
        self.contactPulley = [aDecoder decodeObjectForKey:@"contactPulley"];
        self.contactPulleyWidth = [aDecoder decodeObjectForKey:@"contactPulleyWidth"];
        self.foldPulley = [aDecoder decodeObjectForKey:@"foldPulley"];
        self.foldPulleyWidth = [aDecoder decodeObjectForKey:@"foldPulleyWidth"];
        self.tensorPulley = [aDecoder decodeObjectForKey:@"tensorPulley"];
        self.tensorPulleyWidth = [aDecoder decodeObjectForKey:@"tensorPulleyWidth"];
        self.additionalOnePulley = [aDecoder decodeObjectForKey:@"additionalOnePulley"];
        self.additionalOnePulleyWidth = [aDecoder decodeObjectForKey:@"additionalOnePulleyWidth"];
        self.additionalTwoPulley = [aDecoder decodeObjectForKey:@"additionalTwoPulley"];
        self.additionalTwoPulleyWidth = [aDecoder decodeObjectForKey:@"additionalTwoPulleyWidth"];
        self.rodImpactDiameter = [aDecoder decodeObjectForKey:@"rodImpactDiameter"];
        self.rodImpactAngle = [aDecoder decodeObjectForKey:@"rodImpactAngle"];
        self.rodLoadDiameter = [aDecoder decodeObjectForKey:@"rodLoadDiameter"];
        self.rodLoadAngle = [aDecoder decodeObjectForKey:@"rodLoadAngle"];
        self.rodReturnDiameter = [aDecoder decodeObjectForKey:@"rodReturnDiameter"];
        self.rodReturnAngle = [aDecoder decodeObjectForKey:@"rodReturnAngle"];
        self.rodLDCSpace = [aDecoder decodeObjectForKey:@"rodLDCSpace"];
        self.rodLDRSpace = [aDecoder decodeObjectForKey:@"rodLDRSpace"];
        self.rodPartTroughing = [aDecoder decodeObjectForKey:@"rodPartTroughing"];
        self.observations = [aDecoder decodeObjectForKey:@"observations"];
        self.coverImgID = [[aDecoder decodeObjectForKey:@"coverImgID"] intValue];
        self.trackingUrl = [aDecoder decodeObjectForKey:@"trackingUrl"];
        self.createdAt = [[aDecoder decodeObjectForKey:@"createdAt"] intValue];
        self.updatedAt = [[aDecoder decodeObjectForKey:@"updatedAt"] intValue];
    }
    
    return self;
}


+ (void)getAllConveyorsWithAuthenticationKey:(NSString *)authenticationKey
                           completionHandler:(void(^)(NSURLResponse *response, NSError *error))completionHandler
{
    NSURL *url = [NSURL URLWithString:@"http://api.contiplus.net/conveyors"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                          NSArray *conveyorsJsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          NSMutableArray *conveyorsArray = [NSMutableArray array];
                                          for (NSDictionary *dictionary in conveyorsJsonArray) {
                                              [conveyorsArray addObject:[CPConveyor conveyorWithJSONDictionary:dictionary]];
                                          }
                                          NSData *encodeConveyorsArray = [NSKeyedArchiver archivedDataWithRootObject:conveyorsArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeConveyorsArray forKey:@"conveyorsArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                      }
                                      completionHandler(response, error);
                                  }];
    [task resume];
}

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
                     completionHandler:(void(^)(BOOL success, int conveyorID))completionHandler
{
    NSURL *URL = [NSURL URLWithString:@"http://api.contiplus.net/conveyors"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{\"client_id\":%i,\n \"numero\":\"%@\",\n \"profile_id\":%@,\n \"trans_distancia_centros\":\"%@\",\n \"trans_rpm_motor\":\"%@\",\n \"trans_elevacion\":\"%@\",\n \"trans_angulo_inclinacion\":\"%@\",\n \"trans_hp_motor\":\"%@\",\n \"trans_capacidad\":\"%@\",\n \"trans_relacion_reductor\":\"%@\",\n \"trans_carga\":\"%@\",\n \"tensor_tipo\":\"%@\",\n \"tensor_peso_estimado\":\"%@\",\n \"tensor_carrera\":\"%@\",\n \"mat_descripcion\":\"%@\",\n \"mat_tam_terron\":\"%@\",\n \"mat_temperatura\":\"%@\",\n \"mat_altura_caida\":\"%@\",\n \"mat_porcentaje_finos\":\"%@\", \n \"mat_grado_mat_transportado\":\"%@\", \n \"mat_condicion_alimentacion\":\"%@\", \n \"mat_condicion_carga\":\"%@\", \n \"mat_frecuencia_carga\":\"%@\", \n \"mat_tamanio_granular\":\"%@\", \n \"mat_tipo_densidad\":\"%@\", \n \"mat_agresividad\":\"%@\", \n \"banda_ancho\":\"%@\",\n \"banda_tension\":\"%@\",\n \"id_espesor_cubierta_sup\":\"%@\", \n \"id_espesor_cubierta_inf\":\"%@\",\n \"banda_velocidad\":\"%@\",\n \"banda_fecha_instalacion\":\"%i\",\n \"banda_marca\":\"%@\",\n \"banda_desarrollo_total\":\"%@\",\n \"banda_operacion\":\"%@\",\n \"polea_motriz\":\"%@\",\n \"ancho_polea_motriz\":\"%@\",\n \"polea_recubrimiento\":\"%@\",\n \"polea_arco_contacto\":%@,\n \"polea_cabeza\":\"%@\",\n \"ancho_pol_cabeza\":\"%@\",\n \"polea_cola\":\"%@\",\n \"ancho_pol_cola\":\"%@\",\n \"polea_contacto\":\"%@\",\n \"ancho_pol_contacto\":\"%@\",\n \"polea_doblez\":\"%@\",\n \"ancho_pol_doblez\":\"%@\",\n \"polea_tensora\":\"%@\",\n \"ancho_pol_tensora\":\"%@\",\n \"polea_uno_adicional\":\"%@\",\n \"ancho_polea_uno_adicional\":\"%@\",\n \"polea_dos_adicional\":\"%@\",\n \"ancho_pol_dos_adicional\":\"%@\",\n \"rod_diam_impacto\":\"%@\",\n \"rod_ang_impacto\":\"%@\",\n \"rod_diam_carga\":\"%@\",\n \"rod_ang_carga\":\"%@\",\n \"rod_diam_retorno\":\"%@\",\n \"rod_ang_retorno\":\"%@\",\n \"rod_espacio_ldc\":\"%@\",\n \"rod_espacio_ldr\":\"%@\", \n \"rod_partes_artesa\":\"%@\", \n \"cover_img\":\"%i\", \n \"observaciones\":\"%@\",\n \"created_at\":%i,\n \"updated_at\":%i\n}", clientID, serialNumber, profileID, transCentersDistance, transRPMMotor, transElevation, transInclinationAngle, transHPMotor, transCapacity, transReducerRelationship, transLoad, tensorType, tensorEstimatedWeight, tensorCareer, matDescription, matTerronSize, matTemperature, matHeightFall, matFinosPercentage, matMaterialConveyed, matFeedingConditions, matLoadingConditions, matLoadingFrequency, matGranularSize, matDensity, matAggresivity, bandWidth, bandTension, bandTopThicknessCover, bandBottomThicknessCover, bandSpeed, bandInstallationDate, bandBrand, bandTotalDevelopment, bandOperation, drivePulley, drivePulleyWidth, coverPulley, contactArcPulley, headPulley, headPulleyWidth, tailPulley, tailPulleyWidth, contactPulley, contactPulleyWidth, foldPulley, foldPulleyWidth, tensorPulley, tensorPulleyWidth, additionalOnePulley, additionalOnePulleyWidth, additionalTwoPulley, additionalTwoPulleyWidth, rodImpactDiameter, rodImpactAngle, rodLoadDiameter, rodLoadAngle, rodReturnDiameter, rodReturnAngle, rodLDCSpace, rodLDRSpace, rodPartTroughing, coverImgID, observations, createdAt, updatedAt] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                          NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                                          NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
                                      }
                                      
                                      NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"Response Body:\n%@\n", body);
                                      
                                      BOOL success;
                                      if (!error && (long)[(NSHTTPURLResponse *)response statusCode] == 201) {
                                          NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:0
                                                                                                 error:nil];
                                          NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]
                                                                                                                   objectForKey:@"conveyorsArray"]] mutableCopy];
                                          [tempArray addObject:[CPConveyor conveyorWithJSONDictionary:dict]];
                                          NSData *encodeConveyorsArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeConveyorsArray forKey:@"conveyorsArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                          completionHandler(success, [dict[@"id"] intValue]);
                                      } else {
                                          success = NO;
                                          completionHandler(success, 0);
                                      }
                                  }];
    [task resume];
}

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
                          completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.contiplus.net/conveyors/%i", conveyorID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"PUT"];
    
    [request setValue:@"content-type: application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    [request setHTTPBody:[[NSString stringWithFormat:@"{\"id\":%i,\n\"client_id\":%i,\n \"numero\":\"%@\",\n \"profile_id\":%@,\n \"trans_distancia_centros\":\"%@\",\n \"trans_rpm_motor\":\"%@\",\n \"trans_elevacion\":\"%@\",\n \"trans_angulo_inclinacion\":\"%@\",\n \"trans_hp_motor\":\"%@\",\n \"trans_capacidad\":\"%@\",\n \"trans_relacion_reductor\":\"%@\",\n \"trans_carga\":\"%@\",\n \"tensor_tipo\":\"%@\",\n \"tensor_peso_estimado\":\"%@\",\n \"tensor_carrera\":\"%@\",\n \"mat_descripcion\":\"%@\",\n \"mat_tam_terron\":\"%@\",\n \"mat_temperatura\":\"%@\",\n \"mat_altura_caida\":\"%@\",\n \"mat_porcentaje_finos\":\"%@\", \n \"mat_grado_mat_transportado\":\"%@\", \n \"mat_condicion_alimentacion\":\"%@\", \n \"mat_condicion_carga\":\"%@\", \n \"mat_frecuencia_carga\":\"%@\", \n \"mat_tamanio_granular\":\"%@\", \n \"mat_tipo_densidad\":\"%@\", \n \"mat_agresividad\":\"%@\", \n \"banda_ancho\":\"%@\",\n \"banda_tension\":\"%@\",\n \"id_espesor_cubierta_sup\":\"%@\", \n \"id_espesor_cubierta_inf\":\"%@\",\n \"banda_velocidad\":\"%@\",\n \"banda_fecha_instalacion\":\"%i\",\n \"banda_marca\":\"%@\",\n \"banda_desarrollo_total\":\"%@\",\n \"banda_operacion\":\"%@\",\n \"polea_motriz\":\"%@\",\n \"ancho_polea_motriz\":\"%@\",\n \"polea_recubrimiento\":\"%@\",\n \"polea_arco_contacto\":%@,\n \"polea_cabeza\":\"%@\",\n \"ancho_pol_cabeza\":\"%@\",\n \"polea_cola\":\"%@\",\n \"ancho_pol_cola\":\"%@\",\n \"polea_contacto\":\"%@\",\n \"ancho_pol_contacto\":\"%@\",\n \"polea_doblez\":\"%@\",\n \"ancho_pol_doblez\":\"%@\",\n \"polea_tensora\":\"%@\",\n \"ancho_pol_tensora\":\"%@\",\n \"polea_uno_adicional\":\"%@\",\n \"ancho_polea_uno_adicional\":\"%@\",\n \"polea_dos_adicional\":\"%@\",\n \"ancho_pol_dos_adicional\":\"%@\",\n \"rod_diam_impacto\":\"%@\",\n \"rod_ang_impacto\":\"%@\",\n \"rod_diam_carga\":\"%@\",\n \"rod_ang_carga\":\"%@\",\n \"rod_diam_retorno\":\"%@\",\n \"rod_ang_retorno\":\"%@\",\n \"rod_espacio_ldc\":\"%@\",\n \"rod_espacio_ldr\":\"%@\", \n \"rod_partes_artesa\":\"%@\", \n \"cover_img\":\"%i\", \n \"observaciones\":\"%@\",\n \"created_at\":%i,\n \"updated_at\":%i\n}", conveyorID, clientID, serialNumber, profileID, transCentersDistance, transRPMMotor, transElevation, transInclinationAngle, transHPMotor, transCapacity, transReducerRelationship, transLoad, tensorType, tensorEstimatedWeight, tensorCareer, matDescription, matTerronSize, matTemperature, matHeightFall, matFinosPercentage, matMaterialConveyed, matFeedingConditions, matLoadingConditions, matLoadingFrequency, matGranularSize, matDensity, matAggresivity, bandWidth, bandTension, bandTopThicknessCover, bandBottomThicknessCover, bandSpeed, bandInstallationDate, bandBrand, bandTotalDevelopment, bandOperation, drivePulley, drivePulleyWidth, coverPulley, contactArcPulley, headPulley, headPulleyWidth, tailPulley, tailPulleyWidth, contactPulley, contactPulleyWidth, foldPulley, foldPulleyWidth, tensorPulley, tensorPulleyWidth, additionalOnePulley, additionalOnePulleyWidth, additionalTwoPulley, additionalTwoPulleyWidth, rodImpactDiameter, rodImpactAngle, rodLoadDiameter, rodLoadAngle, rodReturnDiameter, rodReturnAngle, rodLDCSpace, rodLDRSpace, rodPartTroughing, coverImgID, observations, createdAt, updatedAt] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      BOOL success;
                                      if ((long)[(NSHTTPURLResponse *)response statusCode] == 200 && !error) {
                                          NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"conveyorsArray"]] mutableCopy];
                                          NSDictionary *updateConveyor = [NSJSONSerialization JSONObjectWithData:data
                                                                                                         options:0
                                                                                                           error:nil];
                                          int index = 0;
                                          for (CPConveyor *conveyor in tempArray) {
                                              if (conveyor.ID == conveyorID) {
                                                  break;
                                              }
                                              index++;
                                          }
                                          [tempArray replaceObjectAtIndex:index
                                                               withObject:[CPConveyor conveyorWithJSONDictionary:updateConveyor]];
                                          NSData *encodeConveyorArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeConveyorArray forKey:@"conveyorsArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                      } else success = NO;
                                      completionHandler(success);
                                  }];
    [task resume];
}

+ (void)deleteConveyorWithWithAuthenticationKey:(NSString *)authenticationKey
                                          ID:(int)ID
                           completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.contiplus.net/conveyors/%i", ID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      BOOL success;
                                      if ((long)[(NSHTTPURLResponse *)response statusCode] == 204 && !error) {
                                          NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"conveyorsArray"]] mutableCopy];
                                          for (CPConveyor *conveyor in tempArray) {
                                              if (conveyor.ID == ID) {
                                                  [tempArray removeObject:conveyor];
                                                  break;
                                              }
                                          }
                                          NSData *encodeConveyorsArray = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
                                          [[NSUserDefaults standardUserDefaults] setObject:encodeConveyorsArray forKey:@"conveyorsArray"];
                                          [[NSUserDefaults standardUserDefaults] synchronize];
                                          success = YES;
                                      } else success = NO;
                                      completionHandler(success);
                                  }];
    [task resume];
}

+ (void)getConveyorLifeTimeWithAuthenticationKey:(NSString *)authenticationKey
                                              ID:(int)ID
                               completionHandler:(void(^)(BOOL success, NSDictionary *lifetimeDictionary))completionHandler;
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.contiplus.net/conveyors/lifetime/%i", ID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      BOOL success;
                                      if ((long)[(NSHTTPURLResponse *)response statusCode] == 200 && !error) {
                                          success = YES;
                                          NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                                         options:0
                                                                                                           error:nil];
                                          completionHandler(success, jsonDictionary);
                                      } else {
                                          success = NO;
                                          completionHandler(success, @{});
                                      }
                                  }];
    [task resume];
}

+ (void)requestConveyorQuoteWithAuthenticationKey:(NSString *)authenticationKey
                                               ID:(int)ID
                                completionHandler:(void(^)(BOOL success))completionHandler
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.contiplus.net/conveyors/recommended/%i", ID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:authenticationKey forHTTPHeaderField:@"X-Auth"];
    [request setValue:[CPLanguajeUtils languajeForHeader] forHTTPHeaderField:@"Content-Language"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                          NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                                          NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
                                      }
                                      NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"Response Body:\n%@\n", body);
                                      
                                      BOOL success;
                                      if ((long)[(NSHTTPURLResponse *)response statusCode] == 203 && !error) success = YES;
                                      else success = NO;
                                      
                                      completionHandler(success);
                                  }];
    [task resume];
}

+ (BOOL)uploadCacheElement:(CPObject *)element
               forConveyor:(int)ID
{
    __block BOOL success;
    if ([element isKindOfClass:[CPImage class]]) {
        CPImage *image = (CPImage *)element;
        [CPImage saveImageWithAuthenticationKey:[CPUser sharedUser].authKey
                                      imageData:[CPFileUtils dataFromUserFolderWithName:[NSString stringWithFormat:@"%i%i_%i", image.conveyorID, image.bucketID, image.createdAt] dataType:CPImageFile]
                                           name:image.name
                                 descriptionImg:image.descriptionStr
                                     conveyorID:ID
                                       bucketID:0
                                      createdAt:image.createdAt
                                      updatedAt:image.updatedAt
                              completionHandler:^(NSURLResponse *response, NSError *error, NSString *name, int coverID) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error)
                                          success = NO;
                                      else
                                          success = YES;
                                  });
                              }];
    } else if ([element isKindOfClass:[CPVideo class]]) {
        CPVideo *video = (CPVideo *)element;
        [CPVideo saveVideoWithAuthenticationKey:[CPUser sharedUser].authKey
                                      videoData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[CPFileUtils stringPathForVideoWithName:[NSString stringWithFormat:@"%i%i_%i", video.conveyorID, video.bucketID, video.createdAt]]]]
                                           name:video.name
                                 descriptionVid:video.descriptionStr
                                     conveyorID:ID
                                       bucketID:0
                                      createdAt:video.createdAt
                                      updatedAt:video.updatedAt
                              completionHandler:^(NSURLResponse *response, NSError *error, NSString *name) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      if (((long)[(NSHTTPURLResponse *)response statusCode] != 201) || error)
                                          success = NO;
                                      else
                                          success = YES;
                                  });
                              }];
    }
    
    return success;
}



@end
