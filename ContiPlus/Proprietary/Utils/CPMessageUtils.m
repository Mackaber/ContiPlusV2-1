//
//  CPMessageUtils.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/22/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPMessageUtils.h"
#import <UIKit/UIKit.h>

@implementation CPMessageUtils

+ (void)showAlertViewWithTitle:(NSString *)title
                    andMessage:(NSString *)message
{
    UIAlertView *alerview = [[UIAlertView alloc] initWithTitle:title
                                                       message:message
                                                      delegate:nil
                                             cancelButtonTitle:@"Aceptar"
                                             otherButtonTitles:nil];
    [alerview show];
}

@end
