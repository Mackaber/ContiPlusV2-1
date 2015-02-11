//
//  CPProfilesViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/6/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPProfilesViewController.h"
#import "CPProfilesArray.h"
#import "CPCollectionViewCell.h"
#import "CPLanguajeUtils.h"

@interface CPProfilesViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBT;
@property (weak, nonatomic) IBOutlet UIButton *doneBT;
@property (nonatomic) int profileID;
@end

@implementation CPProfilesViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self setUpView];
}

- (void)setUpView
{
    [self.cancelBT setTitle:[CPLanguajeUtils languajeSelectedForString:@"Cancelar"]
                   forState:UIControlStateNormal];
    [self.doneBT setTitle:[CPLanguajeUtils languajeSelectedForString:@"Hecho"]
                 forState:UIControlStateNormal];
    self.doneBT.hidden = YES;
}

#pragma mark - UIStatusBar White Color
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UICollectionView Data Source Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [CPProfilesArray profilesArray].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CollectionCell";
    CPCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                           forIndexPath:indexPath];
    
    NSDictionary *dict = [CPProfilesArray profilesArray][indexPath.row];
    cell.imageViewCell.image = [UIImage imageNamed:[dict objectForKey:@"Image"]];
    if (cell.selected)
        cell.selectedView.hidden = NO;
    else
        cell.selectedView.hidden = YES;
    
    
    return cell;
}

#pragma mark - UICollectionView Delegate Methods
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPCollectionViewCell *cell = (CPCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.doneBT.hidden = NO;
    cell.selectedView.hidden = NO;
    NSDictionary *dict = [CPProfilesArray profilesArray][indexPath.row];
    self.profileID = [[dict objectForKey:@"id"] intValue];
}

- (void)collectionView:(UICollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPCollectionViewCell *cell = (CPCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectedView.hidden = YES;
}

#pragma mark - IBAction Methods
- (IBAction)cancel
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)accept
{
    [self.delegate returnSelectedProfileID:self.profileID];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}



@end
