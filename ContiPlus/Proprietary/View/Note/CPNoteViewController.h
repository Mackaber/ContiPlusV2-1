//
//  CPNoteViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/9/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPNote;
@class CPNoteViewController;
@protocol CPNoteViewControllerDelegate <NSObject>

- (void)eraseNote:(CPNote *)cpNote;

@end

@interface CPNoteViewController : UIViewController

@property (strong, nonatomic) CPNote *cpNote;
@property (weak, nonatomic) id<CPNoteViewControllerDelegate> delegate;

@end
