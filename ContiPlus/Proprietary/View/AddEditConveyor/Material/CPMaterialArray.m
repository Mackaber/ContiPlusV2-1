//
//  CPMaterialArray.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/3/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPMaterialArray.h"
#import "CPLanguajeUtils.h"

@implementation CPMaterialArray

+ (NSArray *)materialArray
{
    return @[@{@"id": @0 ,  @"Name": @"",                                                                            @"Value": @0},
             @{@"id": @154 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Alumina"],                         @"Value": @65},
             @{@"id": @155 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Arcilla"],                         @"Value": @70},
             @{@"id": @156 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Avena"],                           @"Value": @26},
             @{@"id": @157 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Arena de fundición"],              @"Value": @90},
             @{@"id": @158 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Arena húmeda"],                    @"Value": @130},
             @{@"id": @159 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Arena rocosa"],                    @"Value": @82},
             @{@"id": @160 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Aserrin"],                         @"Value": @13},
             @{@"id": @161 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Arena seca"],                      @"Value": @110},
             @{@"id": @162 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Asfalto"],                         @"Value": @65},
             @{@"id": @163 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Azúcar a granel"],                 @"Value": @65},
             @{@"id": @164 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Azúcar refinada"],                 @"Value": @55},
             @{@"id": @165 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Agregados"],                       @"Value": @90},
             @{@"id": @166 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Azufres, finos"],                  @"Value": @55},
             @{@"id": @167 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Azufres, mineral"],                @"Value": @87},
             @{@"id": @168 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Azufres, piedras"],                @"Value": @85},
             @{@"id": @169 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Bagazo"],                          @"Value": @10},
             @{@"id": @170 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Bauxita"],                         @"Value": @90},
             @{@"id": @171 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Cal, de tierra"],                  @"Value": @60},
             @{@"id": @172 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Cal guijarros"],                   @"Value": @55},
             @{@"id": @173 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Caliza clasificada"],              @"Value": @100},
             @{@"id": @174 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Caliza finos"],                    @"Value": @85},
             @{@"id": @175 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Caliza triturada"],                @"Value": @100},
             @{@"id": @176 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Carbón antracita 3/4 a 2\""],      @"Value": @60},
             @{@"id": @177 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Carbón bituminoso clasificado"],   @"Value": @50},
             @{@"id": @178 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Carbón bituminoso húmedo"],        @"Value": @55},
             @{@"id": @179 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Carbón bituminoso seco"],          @"Value": @45},
             @{@"id": @180 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Cemento portland"],                @"Value": @94},
             @{@"id": @181 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Cemento clinker"],                 @"Value": @95},
             @{@"id": @182 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Ceniza húmeda"],                   @"Value": @50},
             @{@"id": @183 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Ceniza seca"],                     @"Value": @40},
             @{@"id": @184 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Cebada"],                          @"Value": @38},
             @{@"id": @185 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Centeno"],                         @"Value": @44},
             @{@"id": @186 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Concreto"],                        @"Value": @115},
             @{@"id": @187 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Coque clasificado"],               @"Value": @30},
             @{@"id": @188 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Coque desmenuzado"],               @"Value": @34},
             @{@"id": @189 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Coque mezclado"],                  @"Value": @32},
             @{@"id": @190 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Coque petrolizado"],               @"Value": @40},
             @{@"id": @191 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Criolita"],                        @"Value": @62},
             @{@"id": @192 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Cuarzo triturado"],                @"Value": @100},
             @{@"id": @193 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Desperdicio de vidrio Nuevo¡"],    @"Value": @100},
             @{@"id": @194 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Dolomita triturada"],              @"Value": @100},
             @{@"id": @195 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Escoria de fundición triturada"],  @"Value": @80},
             @{@"id": @196 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Escoria granulada"],               @"Value": @65},
             @{@"id": @197 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Fluorita"],                        @"Value": @80},
             @{@"id": @198 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Fosfato guijarros"],               @"Value": @85},
             @{@"id": @199 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Fosfato roca"],                    @"Value": @85},
             @{@"id": @200 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Granito"],                         @"Value": @100},
             @{@"id": @201 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Girasol"],                         @"Value": @45},
             @{@"id": @202 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Hierro mineral"],                  @"Value": @200},
             @{@"id": @203 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Hierro triturado"],                @"Value": @150},
             @{@"id": @204 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Harina de trigo"],                 @"Value": @45},
             @{@"id": @205 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Grava seca cribada"],              @"Value": @100},
             @{@"id": @206 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Madera sólida"],                   @"Value": @75},
             @{@"id": @207 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Madera viruta"],                   @"Value": @36},
             @{@"id": @208 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"MAP, DAP"],                        @"Value": @57},
             @{@"id": @209 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Mármol"],                          @"Value": @105},
             @{@"id": @210 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Niquel, minera"],                  @"Value": @100},
             @{@"id": @211 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Nitrato de amonio"],               @"Value": @45},
             @{@"id": @212 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Pallets de hierro"],               @"Value": @125},
             @{@"id": @213 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Pizarra triturada 1/2\""],         @"Value": @90},
             // @{@"id": @214 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Potasa mineral 6\""],              @"Value": @85},
             @{@"id": @215 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Potasa mineral 14\""],             @"Value": @75},
             @{@"id": @216 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Pulpa de papel"],                  @"Value": @62},
             @{@"id": @217 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Roca triturada"],                  @"Value": @110},
             @{@"id": @218 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Sal, granulada"],                  @"Value": @80},
             @{@"id": @219 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Sal, triturada 3/8\""],            @"Value": @80},
             @{@"id": @220 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Sinters"],                         @"Value": @135},
             @{@"id": @221 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Taconita, pellets"],               @"Value": @130},
             @{@"id": @222 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Vidrio horneado"],                 @"Value": @100},
             @{@"id": @223 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Yeso  triturado"],                 @"Value": @80},
             @{@"id": @224 ,@"Name": [CPLanguajeUtils languajeSelectedForString:@"Zinc, mineral triturado"],         @"Value": @160}];
}

+ (NSArray *)conditionsArray
{
    return @[@{@"id": @0, @"Name": @""},
             @{@"id": @259, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Desfavorable"]},
             @{@"id": @260, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Moderado"]},
             @{@"id": @261, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Favorable"]}];
}

+ (NSArray *)loadingFrecuencyArray
{
    return @[@{@"id": @0, @"Name": @""},
             @{@"id": @262, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Poco frecuente"]},
             @{@"id": @263, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Moderado"]},
             @{@"id": @264, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Frecuente"]}];
}

+ (NSArray *)granularSizeArray
{
    return @[@{@"id": @0, @"Name": @""},
             @{@"id": @265, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Fino"]},
             @{@"id": @266, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Medio"]},
             @{@"id": @267, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Grueso"]}];
}

+ (NSArray *)densityArray
{
    return @[@{@"id": @0, @"Name": @""},
             @{@"id": @268, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Ligera"]},
             @{@"id": @269, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Media"]},
             @{@"id": @270, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Pesada"]}];
}

+ (NSArray *)aggresivityArray
{
    return @[@{@"id": @0, @"Name": @""},
             @{@"id": @271, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Baja"]},
             @{@"id": @272, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Moderada"]},
             @{@"id": @273, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Alta"]}];
}

+ (NSArray *)materialConveyedArray
{
    return @[@{@"id": @0, @"Name": @"", @"ShortName": @""},
             @{@"id": @241, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Grado 1 medida de grano 0-50 mm"], @"ShortName": [CPLanguajeUtils languajeSelectedForString:@"Grado 1"]},
             @{@"id": @242, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Grado 2 medida de grano 50-150 mm"], @"ShortName": [CPLanguajeUtils languajeSelectedForString:@"Grado 2"]},
             @{@"id": @243, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Grado 3 medida de grano 150-400 mm"], @"ShortName": [CPLanguajeUtils languajeSelectedForString:@"Grado 3"]}];
}

+ (NSArray *)feedingConditionsArray
{
    return @[@{@"id": @0, @"Name": @"", @"ShortName": @""},
             @{@"id": @238, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Desfavorable caída arriba de 250 cm"], @"ShortName": [CPLanguajeUtils languajeSelectedForString:@"Desfavorable"]},
             @{@"id": @239, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Estandar caída entre 50-250 cm"], @"ShortName": [CPLanguajeUtils languajeSelectedForString:@"Estandar"]},
             @{@"id": @240, @"Name": [CPLanguajeUtils languajeSelectedForString:@"Favorable caída menor a 50 cm"], @"ShortName": [CPLanguajeUtils languajeSelectedForString:@"Favorable"]}];
}

@end
