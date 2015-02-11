//
//  CPLanguajeViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/13/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPLanguajeViewController.h"
#import "CPLanguajeUtils.h"
#import "CPEnum.h"
#import "MRProgress.h"
#import "CPClient.h"
#import "CPConveyor.h"
#import "CPNote.h"
#import "CPImage.h"
#import "CPVideo.h"
#import "CPBucket.h"
#import "CPReport.h"
#import "CPUser.h"

@interface CPLanguajeViewController ()
<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *languageArray;
@property (nonatomic) int selectedLanguage;
@property (nonatomic) BOOL isFirstTime;
@end

@implementation CPLanguajeViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void)setUpView
{
    self.isFirstTime = NO;
    self.selectedLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LanguajeSelected"] intValue];
    // if (!self.selectedLanguage) self.selectedLanguage = CPSpanish;
    self.tableView.scrollEnabled = NO;
    self.languageArray = @[@{@"id": @(CPEnglish), @"Name": @"English"}, @{@"id": @(CPSpanish), @"Name": @"Español"}];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedLanguage
                                                            inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionNone];
    [self.tableView.delegate tableView:self.tableView
               didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedLanguage
                                                          inSection:0]];
}


#pragma mark - UITableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.languageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LanguageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *languageDict = self.languageArray[indexPath.row];
    cell.textLabel.text = [languageDict objectForKey:@"Name"];
    
    return cell;
}

#pragma mark - UITableView Deleagte Methods
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    NSDictionary *languajeDict = self.languageArray[indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:[languajeDict objectForKey:@"id"]
                                              forKey:@"LanguajeSelected"];
    if (self.isFirstTime) {
        [self downloadClientInfo];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"notificationsArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
        self.isFirstTime = YES;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark - Download Methods
- (void)downloadClientInfo
{
    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                        title:@""
                                         mode:MRProgressOverlayViewModeIndeterminate
                                     animated:YES];
    [CPClient getAllClientsWithAuthenticationKey:[CPUser sharedUser].authKey
                               completionHandler:^(NSURLResponse *response, NSError *error) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if (!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200) {
                                           [self downloadConveyorsInfo];
                                       } else {
                                           [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                               animated:YES];
                                           [self showAlertError];
                                       }
                                   });
                               }];
}

- (void)downloadConveyorsInfo
{
    [CPConveyor getAllConveyorsWithAuthenticationKey:[CPUser sharedUser].authKey
                                   completionHandler:^(NSURLResponse *response, NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if (!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200) {
                                               [self downloadImagesInfo];
                                           } else {
                                               [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                   animated:YES];
                                               [self showAlertError];
                                           }
                                       });
                                   }];
}

- (void)downloadImagesInfo
{
    [CPImage getAllImagesWithAuthenticationKey:[CPUser sharedUser].authKey
                             completionHandler:^(NSURLResponse *response, NSError *error) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     if (!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200)
                                         [self downloadVideosInfo];
                                     else {
                                         [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                             animated:YES];
                                         [self showAlertError];
                                     }
                                 });
                             }];
}

- (void)downloadVideosInfo
{
    [CPVideo getAllVideosWithAuthenticationKey:[CPUser sharedUser].authKey
                             completionHandler:^(NSURLResponse *response, NSError *error) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     if (!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200)
                                         [self downloadBucketsInfo];
                                     else {
                                         [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                             animated:YES];
                                         [self showAlertError];
                                     }
                                 });
                             }];
}
- (void)downloadBucketsInfo
{
    [CPBucket getAllBucketsWithAuthenticationKey:[CPUser sharedUser].authKey
                               completionHandler:^(NSURLResponse *response, NSError *error) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if (!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200)
                                           [self downloadNotesInfo];
                                       else {
                                           [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                               animated:YES];
                                           [self showAlertError];
                                       }
                                   });
                               }];
}

- (void)downloadNotesInfo
{
    [CPNote getAllNotesWithAuthenticationKey:[CPUser sharedUser].authKey
                           completionHandler:^(NSURLResponse *response, NSError *error) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   if (!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200)
                                       [self downloadReportsInfo];
                                   else {
                                       [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                           animated:YES];
                                       [self showAlertError];
                                   }
                               });
                           }];
}

- (void)downloadReportsInfo
{
    [CPReport getAllReportsWithAuthenticationKey:[CPUser sharedUser].authKey
                               completionHandler:^(BOOL success) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                           animated:YES];
                                       if (success) {
                                           
                                       } else {
                                           [self showAlertError];
                                       }
                                   });
                               }];
}

#pragma mark - Error Method
- (void)showAlertError
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al descargar la información"]
                                                                   message:[CPLanguajeUtils languajeSelectedForString:@"Favor de verificar tu conexión a internet o intentar más tarde"]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Ok"]
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   [alert dismissViewControllerAnimated:YES
                                                                             completion:nil];
                                               }];
    [alert addAction:ok];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

@end
