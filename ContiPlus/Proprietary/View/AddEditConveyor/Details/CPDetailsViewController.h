//
//  CPDetailsViewController.h
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/29/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *profileBT;
@property (nonatomic) int profileID;
@property (weak, nonatomic) IBOutlet UIButton *photoBT;
@end
