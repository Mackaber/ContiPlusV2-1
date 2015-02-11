//
//  CPMaterialArray.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/3/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPMaterialArray : NSObject

+ (NSArray *)materialArray;
+ (NSArray *)conditionsArray;
+ (NSArray *)loadingFrecuencyArray;
+ (NSArray *)granularSizeArray;
+ (NSArray *)densityArray;
+ (NSArray *)aggresivityArray;
+ (NSArray *)materialConveyedArray;
+ (NSArray *)feedingConditionsArray;

@end
