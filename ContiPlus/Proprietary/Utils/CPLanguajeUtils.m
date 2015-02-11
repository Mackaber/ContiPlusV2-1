//
//  CPLanguajeUtils.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/22/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPLanguajeUtils.h"
#import "CPEnum.h"

@implementation CPLanguajeUtils

+ (NSString *)languajeSelectedForString:(NSString *)key
{
    int selectedLanguaje;
    NSString *path;
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"LanguajeSelected"])
        selectedLanguaje = CPEnglish;
    else
        selectedLanguaje = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LanguajeSelected"] intValue];
    
    if (selectedLanguaje == CPSpanish)
        path = [[NSBundle mainBundle] pathForResource:@"es"
                                               ofType:@"lproj"];
    else if (selectedLanguaje == CPEnglish)
        path = [[NSBundle mainBundle] pathForResource:@"en"
                                               ofType:@"lproj"];
    
    NSBundle *languajeBundle = [NSBundle bundleWithPath:path];
    NSString *languaje = [languajeBundle localizedStringForKey:key
                                                         value:@""
                                                         table:nil];
    
    return languaje;
}

+ (NSString *)languajeForHeader
{
    int selectedLanguaje;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"LanguajeSelected"])
        selectedLanguaje = CPEnglish;
    else
        selectedLanguaje = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LanguajeSelected"] intValue];
    
    if (selectedLanguaje == CPEnglish)
        return @"en";
    else 
        return @"es";
}

@end
