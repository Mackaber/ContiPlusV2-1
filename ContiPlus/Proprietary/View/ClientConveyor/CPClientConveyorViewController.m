//
//  CPClientConveyorViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/22/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPClientConveyorViewController.h"
#import "CPLanguajeUtils.h"
#import "SWTableViewCell.h"
#import "CPClient.h"
#import "CPConveyor.h"
#import "CPClientInfoViewController.h"
#import "CPDateUtils.h"
#import "CPAddEditConveyorViewController.h"
#import "CPConveyorInfoViewController.h"
#import "CPUser.h"
#import "DejalActivityView.h"
#import "CPUserProfileViewController.h"
#import "MRProgress.h"
#import "CPImage.h"
#import "CPVideo.h"
#import "CPBucket.h"
#import "CPNote.h"
#import "CPNotification.h"
#import "CPFileUtils.h"
#import "CPReport.h"
#import "CPWebViewSettingsViewController.h"
#import "CPLoginViewController.h"

@interface CPClientConveyorViewController ()
<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, UISearchResultsUpdating, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) CPClient *globalClient;
@property (strong, nonatomic) CPConveyor *globalConveyor;
@property (nonatomic) BOOL isClientSelected;
@property (strong, nonatomic) NSString *clientName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpaceViewCNTS;
@property (nonatomic) BOOL isMenuOpen;
@property (weak, nonatomic) IBOutlet UIButton *menuBT;
@property (weak, nonatomic) IBOutlet UIButton *closeMenuBT;
@property (weak, nonatomic) IBOutlet UIButton *addConveyorBt;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (nonatomic) BOOL isRefresh;
@property (nonatomic) BOOL isDownloadDone;
@property (nonatomic) BOOL dataError;

// Menu Properties
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLB;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLB;
@property (weak, nonatomic) IBOutlet UILabel *notificationsLB;
@property (weak, nonatomic) IBOutlet UILabel *draftsLB;
@property (weak, nonatomic) IBOutlet UILabel *helpLB;
@property (weak, nonatomic) IBOutlet UILabel *configurationLB;
@property (weak, nonatomic) IBOutlet UILabel *signOutLB;
@property (weak, nonatomic) IBOutlet UILabel *numberNotificationsLB;
@property (nonatomic) BOOL imageLoaded;

// Data
@property (strong, nonatomic) NSMutableArray *clientsArray;
@property (strong, nonatomic) NSMutableArray *conveyorsArray;
@property (nonatomic) int globalClientID;
@property (strong, nonatomic) NSDictionary *userDictionary;

@property (strong, nonatomic) NSMutableArray *alphabetClients;
@property (strong, nonatomic) NSMutableArray *alphabetConveyors;

@end

@implementation CPClientConveyorViewController

#pragma mark - UIViewController LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"cpUser"]];
    if (self.userDictionary) {
        [CPUser userWithJSONDictionary:self.userDictionary];
        [self downloadClientInfo];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        [self setUpView];
        self.trailingSpaceViewCNTS.constant = 500;
        self.isClientSelected = YES;
        
        UISwipeGestureRecognizer *showMenuGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(handleGesture:)];
        showMenuGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:showMenuGesture];
        
        UISwipeGestureRecognizer *hideMenuGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(handleGesture:)];
        hideMenuGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.menuView addGestureRecognizer:hideMenuGesture];
        
        UITableViewController *tableViewController = [[UITableViewController alloc] init];
        tableViewController.tableView = self.tableView;
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self
                                action:@selector(refreshInfo)
                      forControlEvents:UIControlEventValueChanged];
        tableViewController.refreshControl = self.refreshControl;
    } else {
        CPLoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPLoginViewController"];
        [self presentViewController:loginViewController
                           animated:NO
                         completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0
                                                                               green:165.0/255.0
                                                                                blue:0.0
                                                                               alpha:1.0];
    self.segmentedController.hidden = NO;
    self.menuBT.hidden = NO;
    self.closeMenuBT.hidden = YES;
    self.trailingSpaceViewCNTS.constant = 500;
    [self obtainData];
    [self setUpView];
    [self createAlphabetClients];
    [self createAlphabetConveyors];
    [self.tableView reloadData];
    [self downloadNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.searchController.active = NO;
}

- (void)obtainData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"conveyorsArray"]) {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"serialNumber"
                                                             ascending:YES
                                                              selector:@selector(caseInsensitiveCompare:)];
        NSArray *tempConveyorArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"conveyorsArray"]];
        tempConveyorArray = [tempConveyorArray sortedArrayUsingDescriptors:@[sort]];
        self.conveyorsArray = [NSMutableArray arrayWithArray:tempConveyorArray];
        [self createAlphabetClients];
        [self createAlphabetConveyors];
        [self.tableView reloadData];
    }
}

- (void)setUpView
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0
                                                                           green:165.0/255.0
                                                                            blue:0.0
                                                                           alpha:1.0];
    self.tableView.backgroundColor = [UIColor colorWithRed:243.0/255.0
                                                     green:243.0/255.0
                                                      blue:243.0/255.0
                                                     alpha:1.0];
    // Menu
    __block UIImage *image;
    [DejalKeyboardActivityView activityViewForView:self.userImageView withLabel:@""];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:[CPUser sharedUser].urlProfilePicture];
        __block NSData *imageData = nil;
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            imageData = [NSData dataWithContentsOfURL:url];
            image = [UIImage imageWithData:imageData];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [DejalKeyboardActivityView removeViewAnimated:YES];
                if (image) {
                    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
                    self.userImageView.clipsToBounds = YES;
                    self.userImageView.layer.borderWidth = 2.0f;
                    self.userImageView.layer.borderColor = [UIColor colorWithRed:253.0/255.0
                                                                           green:148.0/255.0
                                                                            blue:9.0/255.0
                                                                           alpha:1.0].CGColor;
                    self.userImageView.image = image;
                    self.imageLoaded = YES;
                }
                else {
                    self.userImageView.image = [UIImage imageNamed:@"userImageSmall"];
                    self.imageLoaded = NO;
                }
            });
        });
    });
    self.closeMenuBT.hidden = YES;
    self.userNameLB.text = [CPUser sharedUser].name;
    self.userEmailLB.text = [CPUser sharedUser].email;
    self.notificationsLB.text = [CPLanguajeUtils languajeSelectedForString:@"Notificaciones"];
    self.draftsLB.text = [CPLanguajeUtils languajeSelectedForString:@"Borradores"];
    self.helpLB.text = [CPLanguajeUtils languajeSelectedForString:@"Ayuda"];
    self.configurationLB.text = [CPLanguajeUtils languajeSelectedForString:@"Configuración"];
    self.signOutLB.text = [CPLanguajeUtils languajeSelectedForString:@"Cerrar Sesión"];
    self.numberNotificationsLB.layer.cornerRadius = self.numberNotificationsLB.frame.size.width / 2;
    self.numberNotificationsLB.clipsToBounds = YES;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"notificationsArray"]) {
        NSArray *notifArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationsArray"]];
        int newNotifications = 0;
        for (CPNotification *notif in notifArray) {
            if (!notif.read) {
                newNotifications++;
            }
        }
        
        if (newNotifications == 0) {
            self.numberNotificationsLB.hidden = YES;
        } else self.numberNotificationsLB.text = [NSString stringWithFormat:@"%i", newNotifications];
    }
    
    self.searchResults = [[NSMutableArray alloc] initWithCapacity:self.clientsArray.count];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    if ([[CPUser sharedUser].rol isEqualToString:@"client"]) {
        self.isClientSelected = NO;
        self.segmentedController.hidden = YES;
        self.navigationController.navigationItem.title = [CPLanguajeUtils languajeSelectedForString:@"Transportadores"];
        self.addConveyorBt.hidden = NO;
        for (CPClient *client in self.clientsArray) {
            self.globalClientID = client.ID;
        }
    } else {
        [self.segmentedController setTitle:[CPLanguajeUtils languajeSelectedForString:@"Clientes"]
                         forSegmentAtIndex:0];
        [self.segmentedController setTitle:[CPLanguajeUtils languajeSelectedForString:@"Transportadores"]
                         forSegmentAtIndex:1];
        self.addConveyorBt.hidden = YES;
    }
    
    self.tableView.sectionIndexColor = [UIColor colorWithRed:112.0/255.0
                                                       green:117.0/255.0
                                                        blue:113.0/255.0
                                                       alpha:1.0];
    self.tableView.sectionIndexBackgroundColor = [UIColor colorWithRed:243.0/255.0
                                                                 green:243.0/255.0
                                                                  blue:243.0/255.0
                                                                 alpha:1.0];
    
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor colorWithRed:243.0/255.0
                                                                         green:243.0/255.0
                                                                          blue:243.0/255.0
                                                                         alpha:1.0];
}

#pragma mark - Refresh Method
- (void)refreshInfo
{
    self.isRefresh = YES;
    [self downloadClientInfo];
    [self.tableView reloadData];
}

#pragma mark - Download Methods
- (void)downloadClientInfo
{
    self.isDownloadDone = self.isRefresh ? YES : NO;
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                         ascending:YES
                                                          selector:@selector(caseInsensitiveCompare:)];
    if (!self.isRefresh) {
        [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                            title:[CPLanguajeUtils languajeSelectedForString:@"Descargando información..."]
                                             mode:MRProgressOverlayViewModeIndeterminate
                                         animated:YES];
    }
    [CPClient getAllClientsWithAuthenticationKey:[CPUser sharedUser].authKey
                               completionHandler:^(NSURLResponse *response, NSError *error) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if ((!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200) || (self.userDictionary)) {
                                           NSArray *tempClientsArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientsArray"]];
                                           tempClientsArray = [tempClientsArray sortedArrayUsingDescriptors:@[sort]];
                                           self.clientsArray = [NSMutableArray arrayWithArray:tempClientsArray];
                                           [self downloadConveyorsInfo];
                                       } else {
                                           [self.refreshControl endRefreshing];
                                           [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                               animated:YES];
                                           [self eraseData];
                                       }
                                   });
                               }];
}

- (void)downloadConveyorsInfo
{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"serialNumber"
                                                         ascending:YES
                                                          selector:@selector(caseInsensitiveCompare:)];
    [CPConveyor getAllConveyorsWithAuthenticationKey:[CPUser sharedUser].authKey
                                   completionHandler:^(NSURLResponse *response, NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if ((!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200) || self.userDictionary) {
                                               NSArray *tempConveyorArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"conveyorsArray"]];
                                               tempConveyorArray = [tempConveyorArray sortedArrayUsingDescriptors:@[sort]];
                                               self.conveyorsArray = [NSMutableArray arrayWithArray:tempConveyorArray];
                                               [self downloadImagesInfo];
                                           } else {
                                               [self.refreshControl endRefreshing];
                                               [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                   animated:YES];
                                               [self eraseData];
                                           }
                                       });
                                   }];
}

- (void)downloadImagesInfo
{
    [CPImage getAllImagesWithAuthenticationKey:[CPUser sharedUser].authKey
                             completionHandler:^(NSURLResponse *response, NSError *error) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     if ((!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200) || self.userDictionary)
                                         [self downloadVideosInfo];
                                     else {
                                         [self.refreshControl endRefreshing];
                                         [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                             animated:YES];
                                         [self eraseData];
                                     }
                                 });
                             }];
}

- (void)downloadVideosInfo
{
    [CPVideo getAllVideosWithAuthenticationKey:[CPUser sharedUser].authKey
                             completionHandler:^(NSURLResponse *response, NSError *error) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     if ((!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200) || self.userDictionary)
                                         [self downloadBucketsInfo];
                                     else {
                                         [self.refreshControl endRefreshing];
                                         [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                             animated:YES];
                                         [self eraseData];
                                     }
                                 });
                             }];
}
- (void)downloadBucketsInfo
{
    [CPBucket getAllBucketsWithAuthenticationKey:[CPUser sharedUser].authKey
                               completionHandler:^(NSURLResponse *response, NSError *error) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if ((!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200) || self.userDictionary)
                                           [self downloadNotesInfo];
                                       else {
                                           [self.refreshControl endRefreshing];
                                           [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                               animated:YES];
                                           [self eraseData];
                                       }
                                   });
                               }];
}

- (void)downloadNotesInfo
{
    [CPNote getAllNotesWithAuthenticationKey:[CPUser sharedUser].authKey
                           completionHandler:^(NSURLResponse *response, NSError *error) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   if ((!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200) || self.userDictionary)
                                       [self downloadReportsInfo];
                                   else {
                                       [self.refreshControl endRefreshing];
                                       [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                           animated:YES];
                                       [self eraseData];
                                   }
                               });
                           }];
}

- (void)downloadReportsInfo
{
    [CPReport getAllReportsWithAuthenticationKey:[CPUser sharedUser].authKey
                               completionHandler:^(BOOL success) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self.refreshControl endRefreshing];
                                       [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                           animated:YES];
                                       if (success || self.userDictionary) {
                                           self.segmentedController.enabled = YES;
                                           self.menuBT.enabled = YES;
                                           self.isDownloadDone = YES;
                                           self.dataError = NO;
                                           [self createAlphabetClients];
                                           [self createAlphabetConveyors];
                                           [self.tableView reloadData];
                                           if (!success) {
                                               UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al descargar la información"]
                                                                                                              message:[CPLanguajeUtils languajeSelectedForString:@"Favor de verificar tu conexión a internet o intentar más tarde. La aplicación usará los datos de cache"]
                                                                                                       preferredStyle:UIAlertControllerStyleAlert];
                                               UIAlertAction *ok = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Ok"]
                                                                                            style:UIAlertActionStyleDefault
                                                                                          handler:^(UIAlertAction *action) {
                                                                                              self.isRefresh = NO;
                                                                                              [alert dismissViewControllerAnimated:YES
                                                                                                                        completion:nil];
                                                                                          }];
                                               [alert addAction:ok];
                                               [self presentViewController:alert
                                                                  animated:YES
                                                                completion:nil];
                                           }
                                       } else {
                                           [self eraseData];
                                       }
                                   });
                               }];
}

- (void)downloadNotifications
{
    [CPNotification getAllNotificationsWithAuthenticationKey:[CPUser sharedUser].authKey
                                           completionHandler:^(BOOL success) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   NSArray *notifArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationsArray"]];
                                                   int newNotifications = 0;
                                                   for (CPNotification *notif in notifArray) {
                                                       if (!notif.read) {
                                                           newNotifications++;
                                                       }
                                                   }
                                                   if (newNotifications == 0) {
                                                       self.numberNotificationsLB.hidden = YES;
                                                   } else {
                                                       self.numberNotificationsLB.hidden = NO;
                                                       self.numberNotificationsLB.text = [NSString stringWithFormat:@"%i", newNotifications];
                                                   }
                                               });
                                           }];
}

#pragma mark - TableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isDownloadDone) {
        self.tableView.separatorStyle = self.dataError ? UITableViewCellSeparatorStyleNone : UITableViewCellSeparatorStyleSingleLine;
        // return 1;
        if (self.isClientSelected)
            return self.searchController.active ? 1 : self.alphabetClients.count;
        else
            return self.searchController.active ? 1 : self.alphabetConveyors.count;
    } else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
        messageLabel.text = [CPLanguajeUtils languajeSelectedForString:@"Error al descargar la información. Favor de revisar su conexión a Internet o tratar más tarde. Para actualizar favor de jalar la tabla hacia abajo"];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        messageLabel.hidden = self.dataError ? NO : YES;
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *rowArray = [NSMutableArray array];
    if (self.isClientSelected) {
        rowArray = [self getClientsArrayForSection:section];
        return self.searchController.active ? self.searchResults.count : rowArray.count;
    } else {
        rowArray = [self getConveyorsArrayForSection:section];
        return self.searchController.active ? self.searchResults.count : rowArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (self.isClientSelected) {
        CPClient *client = self.searchController.active ? [self.searchResults objectAtIndex:indexPath.row] : [self clientForRow:indexPath];
        NSString *title = nil;
        UIColor *color = nil;
        
        if (!client.isSuspended) {
            title = [CPLanguajeUtils languajeSelectedForString:@"Suspender"];
            color = [UIColor colorWithRed:187.0/255.0
                                    green:187.0/255.0
                                     blue:193.0/255.0
                                    alpha:1.0];
        }
        else {
            title = [CPLanguajeUtils languajeSelectedForString:@"Reactivar"];
            color = [UIColor colorWithRed:40.0/255.0
                                    green:165.0/255.0
                                     blue:30.0/255.0
                                    alpha:1.0];
        }
        
        if (cell == nil) {
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier
                                      containingTableView:tableView
                                       leftUtilityButtons:nil
                                      rightUtilityButtons:[self rightButtonsClientWithTitle:title
                                                                                   andColor:color]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.delegate = self;
        } else {
            cell.rightUtilityButtons = [self rightButtonsClientWithTitle:title
                                                                andColor:color];
        }
        
        cell.textLabel.text = client.name;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = [UIColor colorWithRed:112.0/255.0
                                                   green:117.0/255.0
                                                    blue:113.0/255.0
                                                   alpha:1.0];
        if (client.isSuspended)
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", client.city, [CPLanguajeUtils languajeSelectedForString:@"Suspendida"]];
        else
            cell.detailTextLabel.text = client.city;
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.textColor = [UIColor colorWithRed:112.0/255.0
                                                         green:117.0/255.0
                                                          blue:113.0/255.0
                                                         alpha:1.0];
        cell.imageView.image = [UIImage imageNamed:@"companyIcon"];
    } else {
        if (cell == nil) {
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier
                                      containingTableView:tableView
                                       leftUtilityButtons:nil
                                      rightUtilityButtons:[self rightButtonsConveyor]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.delegate = self;
        } else {
            cell.rightUtilityButtons = [self rightButtonsConveyor];
        }
        CPConveyor *conveyor = self.searchController.active ? [self.searchResults objectAtIndex:indexPath.row] : [self conveyorForRow:indexPath];
        cell.textLabel.text = conveyor.serialNumber;
        cell.textLabel.textColor = [UIColor colorWithRed:112.0/255.0
                                                   green:117.0/255.0
                                                    blue:113.0/255.0
                                                   alpha:1.0];
        NSString *clientName = nil;
        for (CPClient *client in self.clientsArray) {
            if (client.ID == conveyor.clientID) {
                clientName = client.name;
                break;
            }
        }
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@: %@", clientName, [CPLanguajeUtils languajeSelectedForString:@"Editado"], [CPDateUtils stringFromTimeStamp:@(conveyor.updatedAt)]];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.textColor = [UIColor colorWithRed:112.0/255.0
                                                         green:117.0/255.0
                                                          blue:113.0/255.0
                                                         alpha:1.0];
        cell.imageView.image = [UIImage imageNamed:@"conveyorIcon"];
    }
    
    return cell;
}

#pragma mark - TableView Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableView.isEditing)
        [tableView deselectRowAtIndexPath:indexPath
                                 animated:YES];
    if (self.isClientSelected) {
        self.globalClient = self.searchController.active ? self.searchResults[indexPath.row] : [self clientForRow:indexPath];
        [self performSegueWithIdentifier:@"ClientSegue"
                                  sender:self];
    } else {
        self.globalConveyor = self.searchController.active ? self.searchResults[indexPath.row] : [self conveyorForRow:indexPath];
        NSString *clientName = nil;
        for (CPClient *client in self.clientsArray) {
            if (client.ID == self.globalConveyor.clientID) {
                clientName = client.name;
                break;
            }
        }
        self.clientName = clientName;
        [self performSegueWithIdentifier:@"ConveyorSegue"
                                  sender:self];
    }
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [NSString string];
    if (self.isClientSelected) {
        for (int i = 1; i < self.alphabetClients.count; i++) {
            if (section == i)
                title = self.alphabetClients[i];
        }
        
        return self.searchController.active ? nil : title;
    } else {
        for (int i = 1; i < self.alphabetConveyors.count; i++) {
            if (section == i)
                title = self.alphabetConveyors[i];
        }
        
        return self.searchController.active ? nil : title;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.isDownloadDone) {
        if (self.isClientSelected)
            return self.searchController.active ? nil : self.alphabetClients;
        else
            return self.searchController.active ? nil : self.alphabetConveyors;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index
{
    if (index == 0) {
        CGRect searchBarFrame = self.searchController.searchBar.frame;
        [tableView scrollRectToVisible:searchBarFrame
                              animated:NO];
        return -1;
    }
    else {
        NSIndexPath *indexPath;
        if (self.isClientSelected) {
            for (int i = 0; i < self.alphabetClients.count; i++) {
                NSString *titleToSearch = self.alphabetClients[i];
                if ([title isEqualToString:titleToSearch]) {
                    indexPath = [NSIndexPath indexPathForRow:0
                                                   inSection:i];
                    [tableView scrollToRowAtIndexPath:indexPath
                                     atScrollPosition:UITableViewScrollPositionTop
                                             animated:YES];
                }
            }
            return indexPath.section;
        } else {
            for (int i = 0; i < self.alphabetConveyors.count; i++) {
                NSString *titleToSearch = self.alphabetConveyors[i];
                if ([title isEqualToString:titleToSearch]) {
                    indexPath = [NSIndexPath indexPathForRow:0
                                                   inSection:i];
                    [tableView scrollToRowAtIndexPath:indexPath
                                     atScrollPosition:UITableViewScrollPositionTop
                                             animated:YES];
                }
            }
            return indexPath.section;
        }
    }
}

#pragma mark - UITableView Helper Methods Indexed Table
- (void)createAlphabetClients
{
    self.alphabetClients = [NSMutableArray array];
    for (CPClient *client in self.clientsArray) {
        NSString *firstCharacter = [client.name substringToIndex:1];
        firstCharacter = [firstCharacter uppercaseString];
        if (![self.alphabetClients containsObject:firstCharacter])
            [self.alphabetClients addObject:firstCharacter];
    }
    
    [self.alphabetClients sortUsingSelector:@selector(caseInsensitiveCompare:)];
    [self.alphabetClients insertObject:UITableViewIndexSearch
                               atIndex:0];
}

- (void)createAlphabetConveyors
{
    self.alphabetConveyors = [NSMutableArray array];
    for (CPConveyor *conveyor in self.conveyorsArray) {
        NSString *firstCharacter = [conveyor.serialNumber substringToIndex:1];
        firstCharacter = [firstCharacter uppercaseString];
        if (![self.alphabetConveyors containsObject:firstCharacter])
            [self.alphabetConveyors addObject:firstCharacter];
    }
    
    [self.alphabetConveyors sortUsingSelector:@selector(caseInsensitiveCompare:)];
    [self.alphabetConveyors insertObject:UITableViewIndexSearch
                                 atIndex:0];
}

- (NSMutableArray *)getClientsArrayForSection:(NSInteger)section
{
    NSMutableArray *rowContainer = [NSMutableArray array];
    for (int i = 0; i < self.alphabetClients.count; i++) {
        if (section == i) {
            for (CPClient *client in self.clientsArray) {
                if ([[client.name substringToIndex:1] isEqualToString:self.alphabetClients[i]] ||
                    [[[client.name substringToIndex:1] uppercaseString] isEqualToString:self.alphabetClients[i]])
                    [rowContainer addObject:client];
            }
        }
    }
    
    return rowContainer;
}

- (NSMutableArray *)getConveyorsArrayForSection:(NSInteger)section
{
    NSMutableArray *rowContainer = [NSMutableArray array];
    for (int i = 0; i < self.alphabetConveyors.count; i++) {
        if (section == i) {
            for (CPConveyor *conveyor in self.conveyorsArray) {
                if ([[conveyor.serialNumber substringToIndex:1] isEqualToString:self.alphabetConveyors[i]] ||
                    [[[conveyor.serialNumber substringToIndex:1] uppercaseString] isEqualToString:self.alphabetConveyors[i]])
                    [rowContainer addObject:conveyor];
            }
        }
    }
    
    return rowContainer;
}

- (CPClient *)clientForRow:(NSIndexPath *)indexPath
{
    NSMutableArray *rowArray = [NSMutableArray array];
    rowArray = [self getClientsArrayForSection:indexPath.section];
    CPClient *clientToDisplay = rowArray[indexPath.row];
    
    return clientToDisplay;
}

- (CPConveyor *)conveyorForRow:(NSIndexPath *)indexPath
{
    NSMutableArray *rowArray = [NSMutableArray array];
    rowArray = [self getConveyorsArrayForSection:indexPath.section];
    CPConveyor *conveyorToDisplay = rowArray[indexPath.row];
    
    return conveyorToDisplay;
}

#pragma mark - SWTableViewCell Methods and Buttons
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:243.0/255.0
                                           green:243.0/255.0
                                            blue:243.0/255.0
                                           alpha:1.0];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (NSMutableArray *)rightButtonsClientWithTitle:(NSString *)title
                                       andColor:(UIColor *)color
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:color
                                                title:title];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:251.0/255.0
                                                                      green:15.0/255.0
                                                                       blue:42.0/255.0
                                                                      alpha:1.0]
                                                title:[CPLanguajeUtils languajeSelectedForString:@"Eliminar"]];
    
    return rightUtilityButtons;
}

- (NSMutableArray *)rightButtonsConveyor
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:187.0/255.0
                                                                      green:187.0/255.0
                                                                       blue:193.0/255.0
                                                                      alpha:1.0]
                                                title:[CPLanguajeUtils languajeSelectedForString:@"Editar"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:251.0/255.0
                                                                      green:15.0/255.0
                                                                       blue:42.0/255.0
                                                                      alpha:1.0]
                                                title:[CPLanguajeUtils languajeSelectedForString:@"Eliminar"]];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell
didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (self.isClientSelected) {
        CPClient *client = self.searchController.active ? self.searchResults[indexPath.row] : [self clientForRow:indexPath];
        switch (index) {
            case 0:
            {
                [self.searchController.searchBar resignFirstResponder];
                if (!client.isSuspended) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"¡ATENCIÓN!"]
                                                                                   message:[CPLanguajeUtils languajeSelectedForString:@"Al suspender a la empresa ningún usuario asociado podrá entrar a la plataforma. ¿Desea continuar?"]
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *suspend = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Sí"]
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *action) {
                                                                        [MRProgressOverlayView showOverlayAddedTo:[[[UIApplication sharedApplication] windows] objectAtIndex:0]//self.navigationController.navigationBar.superview
                                                                                                            title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                                                                                             mode:MRProgressOverlayViewModeIndeterminate
                                                                                                         animated:YES];
                                                                        [CPClient supendClientWithWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                                                     ID:client.ID
                                                                                                      completionHandler:^(BOOL success) {
                                                                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                              [MRProgressOverlayView dismissOverlayForView:[[[UIApplication sharedApplication] windows] objectAtIndex:0]
                                                                                                                                                  animated:YES];
                                                                                                              if (success) {
                                                                                                                  [alert dismissViewControllerAnimated:YES
                                                                                                                                            completion:nil];
                                                                                                                  client.isSuspended = YES;
                                                                                                                  [self.tableView reloadData];
                                                                                                              } else {
                                                                                                                  UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al suspender al cliente"]
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
                                                                                                          });
                                                                                                      }];
                                                                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"No"]
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction *action) {
                                                                       [alert dismissViewControllerAnimated:YES
                                                                                                 completion:nil];
                                                                   }];
                    [alert addAction:suspend];
                    [alert addAction:cancel];
                    [self presentViewController:alert
                                       animated:YES
                                     completion:nil];
                } else {
                    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                                        title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                                         mode:MRProgressOverlayViewModeIndeterminate
                                                     animated:YES];
                    [CPClient reactivateClientWithWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                     ID:client.ID
                                                      completionHandler:^(BOOL success) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                                 animated:YES];
                                                             if (success) {
                                                                 client.isSuspended = NO;
                                                                 [self.tableView reloadData];
                                                             } else {
                                                                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al reactivar al cliente"]
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
                                                         });
                                                      }];
                }
                break;
            }
            case 1:
            {
                [self.searchController.searchBar resignFirstResponder];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"¡ATENCIÓN!"]
                                                                               message:[CPLanguajeUtils languajeSelectedForString:@"Al eliminar la empresa no se podrá recuperar la información y todos los elementos asociados se perderán. ¿Desea continuar?"]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *erase = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Si"]
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                                                                                      title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                                                                                       mode:MRProgressOverlayViewModeIndeterminate
                                                                                                   animated:YES];
                                                                  [CPClient deleteClientWithWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                                               ID:client.ID
                                                                                                completionHandler:^(BOOL success) {
                                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                        [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                                                                            animated:YES];
                                                                                                        if (success) {
                                                                                                            [alert dismissViewControllerAnimated:YES
                                                                                                                                      completion:nil];
                                                                                                            [self.searchResults removeObject:client];
                                                                                                            [self.clientsArray removeObject:client];
                                                                                                            [self createAlphabetClients];
                                                                                                            [self createAlphabetConveyors];
                                                                                                            [self.tableView reloadData];
                                                                                                        } else {
                                                                                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al borrar al cliente"]
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
                                                                                                    });
                                                                                                }];
                                                              }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"No"]
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   [alert dismissViewControllerAnimated:YES
                                                                                             completion:nil];
                                                               }];
                [alert addAction:erase];
                [alert addAction:cancel];
                [self presentViewController:alert
                                   animated:YES
                                 completion:nil];
                break;
            }
            default:
                break;
        }
    }
    else {
        CPConveyor *conveyor = self.searchController.active ? self.searchResults[indexPath.row] : [self conveyorForRow:indexPath];
        switch (index) {
            case 0:
                self.globalConveyor = conveyor;
                for (CPClient *client in self.clientsArray) {
                    if (client.ID == self.globalConveyor.clientID) {
                        self.globalClientID = client.ID;
                        break;
                    }
                }
                [self performSegueWithIdentifier:@"editConveyorSegue"
                                          sender:self];
                break;
            case 1:
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"¡ATENCIÓN!"]
                                                                               message:[CPLanguajeUtils languajeSelectedForString:@"Al eliminar el transportador no se podrá recuperar la información y todos los elementos asociados se perderán. ¿Desea continuar?"]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *erase = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Si"]
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                                                                                      title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                                                                                       mode:MRProgressOverlayViewModeIndeterminate
                                                                                                   animated:YES];
                                                                  [CPConveyor deleteConveyorWithWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                                                   ID:conveyor.ID
                                                                                                    completionHandler:^(BOOL success) {
                                                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                            [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                                                                                animated:YES];
                                                                                                            if (success) {
                                                                                                                [alert dismissViewControllerAnimated:YES
                                                                                                                                          completion:nil];
                                                                                                                [self.searchResults removeObject:conveyor];
                                                                                                                [self.conveyorsArray removeObject:conveyor];
                                                                                                                [self createAlphabetClients];
                                                                                                                [self createAlphabetConveyors];
                                                                                                                [self.tableView reloadData];
                                                                                                            } else {
                                                                                                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al borrar el transportador"]
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
                                                                                                        });
                                                                                                    }];
                                                              }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"No"]
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   [alert dismissViewControllerAnimated:YES
                                                                                             completion:nil];
                                                               }];
                [alert addAction:erase];
                [alert addAction:cancel];
                [self presentViewController:alert
                                   animated:YES
                                 completion:nil];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - LateralMenu Methods
- (void)openMenuMethod
{
    self.isMenuOpen = YES;
    [self.view layoutIfNeeded];
    self.trailingSpaceViewCNTS.constant = 0;
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0
                                                                           green:0
                                                                            blue:0
                                                                           alpha:0.75];
    self.segmentedController.hidden = YES;
    self.menuBT.hidden = YES;
    self.closeMenuBT.hidden = NO;
}

- (void)closeMenuMethod
{
    self.isMenuOpen = NO;
    [self.view layoutIfNeeded];
    self.trailingSpaceViewCNTS.constant = 500;
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0
                                                                           green:165.0/255.0
                                                                            blue:0.0
                                                                           alpha:1.0];
    if ([[CPUser sharedUser].rol isEqualToString:@"client"]) {
        self.isClientSelected = NO;
        self.segmentedController.hidden = YES;
        self.title = [CPLanguajeUtils languajeSelectedForString:@"Transportadores"];
    } else {
        self.isClientSelected = YES;
        self.segmentedController.hidden = NO;
        [self.segmentedController setTitle:[CPLanguajeUtils languajeSelectedForString:@"Clientes"]
                         forSegmentAtIndex:0];
        [self.segmentedController setTitle:[CPLanguajeUtils languajeSelectedForString:@"Transportadores"]
                         forSegmentAtIndex:1];
    }
    self.menuBT.hidden = NO;
    self.closeMenuBT.hidden = YES;
}

#pragma mark - UIGestureRecognizer Methods
- (void)handleGesture:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        [self openMenuMethod];
    }
    else{
        [self closeMenuMethod];
    }
}

#pragma mark - IBAction Methods
- (IBAction)changeTableViewData:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.isClientSelected = YES;
            self.searchResults = [[NSMutableArray alloc] initWithCapacity:self.clientsArray.count];
            [self.searchController resignFirstResponder];
            [self.tableView reloadData];
            break;
        case 1:
            self.isClientSelected = NO;
            self.searchResults = [[NSMutableArray alloc] initWithCapacity:self.conveyorsArray.count];
            [self.searchController resignFirstResponder];
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}

- (IBAction)openUserMenu
{
    [self openMenuMethod];
}

- (IBAction)closeMenu
{
    [self closeMenuMethod];
}

- (IBAction)logOut
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"clientsArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"conveyorsArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"imagesArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"videosArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bucketsArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"notesArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"draftsArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"reportsArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cpUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"draftsConveyorArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [CPFileUtils deleteAllObjectsFromUserFolder];

    CPLoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPLoginViewController"];
    loginViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:loginViewController
                       animated:YES
                     completion:nil];
}

#pragma mark - Erase Data Method
- (void)eraseData
{
    if (self.isRefresh) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al descargar la información"]
                                                                       message:[CPLanguajeUtils languajeSelectedForString:@"Favor de verificar tu conexión a internet o intentar más tarde"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Ok"]
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       self.isRefresh = NO;
                                                       [alert dismissViewControllerAnimated:YES
                                                                                 completion:nil];
                                                   }];
        [alert addAction:ok];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    } else {
        self.clientsArray = [NSMutableArray array];
        self.conveyorsArray = [NSMutableArray array];
        self.segmentedController.enabled = NO;
        self.menuBT.enabled = NO;
        self.dataError = YES;
        [self createAlphabetClients];
        [self createAlphabetConveyors];
        [self.tableView reloadData];
    }
}

#pragma mark - UISearchController Delegate Methods
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [searchController.searchBar text];
    if (self.isClientSelected)
        [self updateFilteredContentForClientName:searchString];
    else
        [self updateFilteredContentForConveyorSerialNumber:searchString];
    [self.tableView reloadData];
}

- (void)updateFilteredContentForClientName:(NSString *)clientName
{
    if (clientName == nil || clientName.length == 0)
    {
        self.searchResults = [self.clientsArray mutableCopy];
        return;
    }
    
    [self.searchResults removeAllObjects];
    
    for (CPClient *client in self.clientsArray)
    {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange clientRangeName = NSMakeRange(0, client.name.length);
        NSRange foundRange = [client.name rangeOfString:clientName
                                                   options:searchOptions
                                                     range:clientRangeName];
        if (foundRange.length > 0) {
            [self.searchResults addObject:client];
        }
    }
}

- (void)updateFilteredContentForConveyorSerialNumber:(NSString *)conveyorSerialNumber
{
    if (conveyorSerialNumber == nil || conveyorSerialNumber.length == 0) {
        self.searchResults = [self.conveyorsArray mutableCopy];
        return;
    }
    
    [self.searchResults removeAllObjects];
    
    for (CPConveyor *conveyor in self.conveyorsArray) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange conveyorRangeSerialNumber = NSMakeRange(0, conveyor.serialNumber.length);
        NSRange foundRange = [conveyor.serialNumber rangeOfString:conveyorSerialNumber
                                                          options:searchOptions
                                                            range:conveyorRangeSerialNumber];
        if (foundRange.length > 0)
        {
            [self.searchResults addObject:conveyor];
        }
    }
}

#pragma mark - UINavigation Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ClientSegue"]) {
        CPClientInfoViewController *clientInfoViewController = segue.destinationViewController;
        clientInfoViewController.client = self.globalClient;
        clientInfoViewController.allConveyorsArray = self.conveyorsArray;
    } else if ([segue.identifier isEqualToString:@"editConveyorSegue"]) {
        CPAddEditConveyorViewController *addEditConveyor = segue.destinationViewController;
        addEditConveyor.conveyor = self.globalConveyor;
        addEditConveyor.isEditable = YES;
        addEditConveyor.isCache = NO;
        addEditConveyor.clientID = self.globalClientID;
    } else if ([segue.identifier isEqualToString:@"ConveyorSegue"]) {
        CPConveyorInfoViewController *conveyorInfoController = segue.destinationViewController;
        conveyorInfoController.conveyor = self.globalConveyor;
        conveyorInfoController.clientName = self.clientName;
    } else if ([segue.identifier isEqualToString:@"UserProfileSegue"]) {
        CPUserProfileViewController *userProfileController = segue.destinationViewController;
        userProfileController.imageProfile = self.userImageView.image;
        userProfileController.isImageLoad = self.imageLoaded;
    } else if ([segue.identifier isEqualToString:@"AddConveyorSegue"]) {
        CPAddEditConveyorViewController *addEditConveyor = segue.destinationViewController;
        addEditConveyor.conveyor = self.globalConveyor;
        addEditConveyor.isEditable = NO;
        addEditConveyor.isCache = NO;
        addEditConveyor.clientID = self.globalClientID;
    } else if ([segue.identifier isEqualToString:@"WebViewSettingSegue"]) {
        CPWebViewSettingsViewController *webViewSettingsViewController = segue.destinationViewController;
        webViewSettingsViewController.url = [CPUser sharedUser].helpUrl;
    }
}

@end
