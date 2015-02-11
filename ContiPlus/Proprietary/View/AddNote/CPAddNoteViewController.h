//
//  CPAddNoteViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/10/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPNote;

@interface CPAddNoteViewController : UIViewController

@property (strong, nonatomic) CPNote *note;
@property (nonatomic) BOOL isCache;
@property (nonatomic) int conveyorID;
@property (nonatomic) int bucketID;

@end
