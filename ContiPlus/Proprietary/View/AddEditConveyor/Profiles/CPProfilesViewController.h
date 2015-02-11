//
//  CPProfilesViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/6/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPProfilesViewController;
@protocol CPProfilesViewControllerDelegate <NSObject>
@required
- (void)returnSelectedProfileID:(int)profileID;

@end

@interface CPProfilesViewController : UIViewController

@property (weak, nonatomic) id<CPProfilesViewControllerDelegate>delegate;

@end
