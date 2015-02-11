//
//  CPEstimatedLifeViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/10/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPEstimatedLifeViewController.h"
#import "CPLanguajeUtils.h"
#import "CPConveyor.h"
#import "MRProgress.h"
#import "CPDateUtils.h"
#import "CPQuoteRequestViewController.h"
#import "CPUser.h"
#import "CPMonthArray.h"

@interface CPEstimatedLifeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *estimatedLifeLB;
@property (weak, nonatomic) IBOutlet UILabel *estimatedLifeDescLB;
@property (weak, nonatomic) IBOutlet UILabel *tonnageLB;
@property (weak, nonatomic) IBOutlet UILabel *tonnageDescLB;
@property (weak, nonatomic) IBOutlet UILabel *updateDateChangeLB;
@property (weak, nonatomic) IBOutlet UILabel *updateDateChangeDescLB;
@property (weak, nonatomic) IBOutlet UIButton *recommendedBandBT;
@property (weak, nonatomic) IBOutlet UILabel *noticeLB;

@end

@implementation CPEstimatedLifeViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    [self obtainData];
}

- (void)setUpView
{
    self.estimatedLifeDescLB.text = @"";
    self.tonnageDescLB.text = @"";
    self.updateDateChangeDescLB.text = @"";
    self.navigationController.navigationBar.hidden = YES;
    self.estimatedLifeLB.text = [CPLanguajeUtils languajeSelectedForString:@"Vida estimada en años"];
    self.tonnageLB.text = [CPLanguajeUtils languajeSelectedForString:@"Tonelaje esperado en Mio/ton"];
    self.updateDateChangeLB.text = [CPLanguajeUtils languajeSelectedForString:@"Fecha aproximada de cambio"];
    
    [self.recommendedBandBT.layer setBorderWidth:1.5f];
    [self.recommendedBandBT.layer setBorderColor:[UIColor colorWithRed:1.0
                                                                 green:45.0/255.0
                                                                  blue:55.0/255.0
                                                                 alpha:1.0].CGColor];
    [self.recommendedBandBT.layer setCornerRadius:5.0f];
    [self.recommendedBandBT setTitle:[CPLanguajeUtils languajeSelectedForString:@"Banda recomendada"]
                            forState:UIControlStateNormal];
    self.recommendedBandBT.hidden = YES;
    
    self.noticeLB.text = [CPLanguajeUtils languajeSelectedForString:@"Disclaimer"];
}

- (void)obtainData
{
    self.estimatedLifeDescLB.text = [self.estimatedLife isEqualToString:@""] ? @"-" : [NSString stringWithFormat:@"%@ %@", self.estimatedLife, [CPLanguajeUtils languajeSelectedForString:@"años"]];
    self.tonnageDescLB.text = [self.tonnage isEqualToString:@""] ? @"-" : [NSString stringWithFormat:@"%@ %@", self.tonnage, [CPLanguajeUtils languajeSelectedForString:@"Mio/ton"]];
    
    if ([self.aproxChangeDate intValue] == 0) {
        self.updateDateChangeDescLB.text = @"-";
    } else {
        for (NSDictionary *dictionary in [CPMonthArray monthArray]) {
            if ([CPDateUtils monthFromDate:self.aproxChangeDate] == [dictionary[@"Number"] intValue]) {
                self.updateDateChangeDescLB.text = [NSString stringWithFormat:@"%@ %@", dictionary[@"Month"], [CPDateUtils stringYearFromTimeStamp:self.aproxChangeDate]];
            }
        }
    }
    
    self.recommendedBandBT.hidden = [self.recommendedConveyorMm isEqualToString:@""] || [self.recommendedConveyorIn isEqualToString:@""] ? YES : NO;
}

#pragma mark - IBAction Methods
- (IBAction)returnToPrController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue
                sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"QuoteRequestSegue"]) {
        CPQuoteRequestViewController *quoteRequestViewController = segue.destinationViewController;
        quoteRequestViewController.recommendedConveyorIn = self.recommendedConveyorIn;
        quoteRequestViewController.recommendedConveyorMm = self.recommendedConveyorMm;
        quoteRequestViewController.conveyorID = self.conveyorID;
    }
}
@end
