//
//  CPConveyorInfoViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/4/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPConveyorInfoViewController.h"
#import "CPConveyor.h"
#import "CPDataSheet.h"
#import "CPImage.h"
#import "CPVideo.h"
#import "CPBucket.h"
#import "CPLanguajeUtils.h"
#import "CPDateUtils.h"
#import "CPDataSheetViewController.h"
#import "CPImageViewController.h"
#import "CPVideoViewController.h"
#import "CPFolderViewController.h"
#import "REMenu.h"
#import "CPAddEditConveyorViewController.h"
#import "CPAddImageViewController.h"
#import "CPAddVideoViewController.h"
#import "MRProgress.h"
#import "CPEstimatedLifeViewController.h"
#import "CPBandTrackingViewController.h"
#import "CPReport.h"
#import "CPUser.h"
#import "CPReportViewController.h"
#import "CPClient.h"
#import "CPNote.h"
#import "CPQuoteRequestViewController.h"
#import "Reachability.h"

@interface CPConveyorInfoViewController ()
<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *generalArray;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchResults;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addImageSpaceCNST;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addVideoSpaceCNST;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addFolderSpaceCNST;
@property (weak, nonatomic) IBOutlet UILabel *addImageLB;
@property (weak, nonatomic) IBOutlet UILabel *addVideoLB;
@property (weak, nonatomic) IBOutlet UILabel *addFolderLB;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBBT;

@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (nonatomic) BOOL isMenuOpen;
@property (strong, nonatomic) CPImage *globalImage;
@property (strong, nonatomic) CPVideo *globalVideo;
@property (strong, nonatomic) CPBucket *globalBucket;
@property (strong, nonatomic) CPReport *globalReport;
@property (weak, nonatomic) IBOutlet UIButton *addBT;
@property (weak, nonatomic) IBOutlet UIButton *folderBT;

@property (strong, nonatomic) REMenu *menu;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL isRefresh;
@property (nonatomic) BOOL isDownloadDone;
@property (nonatomic) BOOL dataError;

@property (strong, nonatomic) __block NSString *estimatedLife;
@property (strong, nonatomic) __block NSString *tonnage;
@property (strong, nonatomic) __block NSNumber *aproxChangeDate;
@property (strong, nonatomic) __block NSString *recommendedConveyorIn;
@property (strong, nonatomic) __block NSString *recommendedConveyorMn;

@property (nonatomic) __block BOOL isInternetReachable;

@end

@implementation CPConveyorInfoViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkConnection];
    if (self.conveyor.ID != 0) {
        [self obtainEstimatedRecommended];
        [self obtainData];
    } else {
        [self obtainCacheData];
    }
    [self setUpView];
    [self.tableView reloadData];
    
    self.searchResults = [[NSMutableArray alloc] initWithCapacity:self.generalArray.count];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    if (self.conveyor.ID != 0) {
        UITableViewController *tableViewController = [[UITableViewController alloc] init];
        tableViewController.tableView = self.tableView;
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self
                                action:@selector(refreshInfo)
                      forControlEvents:UIControlEventValueChanged];
        tableViewController.refreshControl = self.refreshControl;
    }
}

- (void)setUpView
{
    [self.addBT setImage:[UIImage imageNamed:@"addButton"]
                forState:UIControlStateNormal];
    self.title = self.conveyor.serialNumber;
    self.addImageSpaceCNST.constant = -65;
    self.addVideoSpaceCNST.constant = -65;
    self.addFolderSpaceCNST.constant = -65;
    self.alphaView.hidden = YES;
    self.addImageLB.hidden = YES;
    self.addVideoLB.hidden = YES;
    self.addFolderLB.hidden = YES;
    self.isMenuOpen = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
    self.addImageLB.text = [CPLanguajeUtils languajeSelectedForString:@"Agregar imagen"];
    self.addVideoLB.text = [CPLanguajeUtils languajeSelectedForString:@"Agregar video"];
    self.addFolderLB.text = [CPLanguajeUtils languajeSelectedForString:@"Agregar folder"];
    if (self.conveyor.ID == 0) {
        self.menuBBT.enabled = NO;
        self.folderBT.enabled = NO;
    }
    
    REMenuItem *lifeTime = [[REMenuItem alloc] initWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Tiempo de vida"]
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [self performSegueWithIdentifier:@"EstimatedLifeSegue"
                                                                                    sender:self];
                                                      }];
    REMenuItem *recommended = [[REMenuItem alloc] initWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Banda recomendada"]
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [self performSegueWithIdentifier:@"RecommendedBandSegue"
                                                                                       sender:self];
                                                         }];
    REMenuItem *tracking = [[REMenuItem alloc] initWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Rastreo de banda"]
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [self performSegueWithIdentifier:@"TrackingSegue"
                                                                                    sender:self];
                                                      }];
    REMenuItem *edit = [[REMenuItem alloc] initWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Editar"]
                                                   image:nil
                                        highlightedImage:nil
                                                  action:^(REMenuItem *item) {
                                                      [self performSegueWithIdentifier:@"EditConveyorSegue"
                                                                                sender:self];
                                                  }];
    REMenuItem *erase = [[REMenuItem alloc] initWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Borrar"]
                                                    image:nil
                                         highlightedImage:nil
                                                   action:^(REMenuItem *item) {
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
                                                                                                                                                          ID:self.conveyor.ID
                                                                                                                                           completionHandler:^(BOOL success) {
                                                                                                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                                                                   [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                                                                                                                       animated:YES];
                                                                                                                                                   if (success) {
                                                                                                                                                       [alert dismissViewControllerAnimated:YES
                                                                                                                                                                                 completion:nil];
                                                                                                                                                       [self.navigationController popViewControllerAnimated:YES];
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

                                                   }];
    
    NSMutableArray *buttonsArray = [NSMutableArray array];
    if (![self.estimatedLife isEqualToString:@""] ||
        ![self.tonnage isEqualToString:@""] ||
        [self.aproxChangeDate intValue] != 0)
        [buttonsArray addObject:lifeTime];
    if (![self.recommendedConveyorIn isEqualToString:@""] ||
        ![self.recommendedConveyorMn isEqualToString:@""])
        [buttonsArray addObject:recommended];
    if (self.conveyor.trackingUrl)
        [buttonsArray addObject:tracking];
    [buttonsArray addObject:edit];
    [buttonsArray addObject:erase];
    
    self.menu = [[REMenu alloc] initWithItems:buttonsArray];
    self.menu.backgroundColor = [UIColor whiteColor];
    self.menu.highlightedBackgroundColor = [UIColor colorWithRed:253.0/255.0
                                                           green:148.0/255.0
                                                            blue:8.0/255.0
                                                           alpha:1.0];
    self.menu.highlightedTextColor = [UIColor whiteColor];
    self.menu.highlightedTextShadowColor = [UIColor clearColor];
    self.menu.cornerRadius = 4.0f;
    self.menu.textShadowOffset = CGSizeMake(5, 0);
    self.menu.borderColor = [UIColor colorWithRed:214.0/255.0
                                            green:214.0/255.0
                                             blue:214.0/255.0
                                            alpha:1.0];
    self.menu.font = [UIFont fontWithName:@"Avenir-Medium"
                                     size:15.0f];
    self.menu.textColor = [UIColor colorWithRed:93.0/255.0
                                          green:98.0/255.0
                                           blue:94.0/255.0
                                          alpha:1.0];
    self.menu.separatorColor = [UIColor colorWithRed:214.0/255.0
                                               green:214.0/255.0
                                                blue:214.0/255.0
                                               alpha:1.0];
    self.menu.separatorHeight = 0.5f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:YES];
    NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"conveyorsArray"]] mutableCopy];
    for (CPConveyor *conveyor in tempArray) {
        if (conveyor.ID == self.conveyor.ID) {
            self.conveyor = conveyor;
            break;
        }
    }
    if (self.conveyor.ID != 0)
        [self obtainData];
    else
        [self obtainCacheData];
    [self setUpView];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.searchController.active = NO;
    if (self.menu.isOpen) {
        [self.menu close];
    }
}

- (void)obtainData
{
    if (self.conveyor.ID != 0) {
        CPDataSheet *dataSheet = [CPDataSheet dataSheetWithName:[CPLanguajeUtils languajeSelectedForString:@"Ficha técnica"]
                                                 andDateUpdated:self.conveyor.updatedAt];
        self.generalArray = [NSMutableArray arrayWithArray:@[dataSheet]];
    }
    NSMutableArray *sortedArray = [NSMutableArray array];
    
    NSArray *tempImgArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]
                                                                        objectForKey:@"imagesArray"]];
    for (CPImage *img in tempImgArray) {
        if ((img.conveyorID == self.conveyor.ID) && (img.bucketID == 0)) {
            [sortedArray addObject:img];
        }
    }
    
    NSArray *tempVidArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"videosArray"]];
    for (CPVideo *video in tempVidArray) {
        if ((video.conveyorID == self.conveyor.ID) && (video.bucketID == 0)) {
            [sortedArray addObject:video];
        }
    }
    
    NSArray *tempBckArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"bucketsArray"]];
    for (CPBucket *bucket in tempBckArray) {
        if (bucket.conveyorID == self.conveyor.ID) {
            [sortedArray addObject:bucket];
        }
    }
    
    NSArray *tempReportArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"reportsArray"]];
    for (CPReport *report in tempReportArray) {
        if ((report.conveyorID == self.conveyor.ID) && (report.bucketID == 0)) {
            [sortedArray addObject:report];
        }
    }
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                         ascending:YES
                                                          selector:@selector(caseInsensitiveCompare:)];
    NSArray *finalArray = [sortedArray sortedArrayUsingDescriptors:@[sort]];
    
    for (CPObject *obj in finalArray) {
        [self.generalArray addObject:obj];
    }
}

- (void)obtainCacheData
{
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"draftsConveyorArray"]];
    self.generalArray = [NSMutableArray array];
    for (CPObject *object in array) {
        if (object.conveyorID == self.conveyor.createdAt) {
            [self.generalArray addObject:object];
        }
    }
    
}

#pragma mark - Internet Connection Method
- (void)checkConnection
{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.google.com"];
    reach.reachableBlock = ^(Reachability *reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isInternetReachable = YES;
        });
    };
    reach.unreachableBlock = ^(Reachability *reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isInternetReachable = NO;
        });
    };
    
    [reach startNotifier];
}

#pragma mark - Estimated Life and Recommended Band Method
- (void)obtainEstimatedRecommended
{
    [MRProgressOverlayView showOverlayAddedTo:self.view
                                        title:@""
                                         mode:MRProgressOverlayViewModeIndeterminate
                                     animated:YES];
    [CPConveyor getConveyorLifeTimeWithAuthenticationKey:[CPUser sharedUser].authKey
                                                      ID:self.conveyor.ID
                                       completionHandler:^(BOOL success, NSDictionary *lifetimeDictionary) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [MRProgressOverlayView dismissOverlayForView:self.view
                                                                                   animated:YES];
                                               if (success) {
                                                   self.estimatedLife = [lifetimeDictionary[@"estimated_lifetime"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%.1f", [lifetimeDictionary[@"estimated_lifetime"] floatValue]];
                                                   self.tonnage = [lifetimeDictionary[@"expected_tonnage"] isKindOfClass:[NSNull class]] ? @"" : [lifetimeDictionary[@"expected_tonnage"] stringValue];
                                                   self.aproxChangeDate = [lifetimeDictionary[@"approx_change_date"] isKindOfClass:[NSNull class]] ? @(0) : lifetimeDictionary[@"approx_change_date"];
                                                   if (lifetimeDictionary[@"recommended_conveyor_in"] && lifetimeDictionary[@"recommended_conveyor_mm"]) {
                                                       self.recommendedConveyorIn = [lifetimeDictionary[@"recommended_conveyor_in"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", lifetimeDictionary[@"recommended_conveyor_in"]];
                                                       self.recommendedConveyorMn = [lifetimeDictionary[@"recommended_conveyor_mm"] isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", lifetimeDictionary[@"recommended_conveyor_mm"]];
                                                   } else {
                                                       self.recommendedConveyorIn = @"";
                                                       self.recommendedConveyorMn = @"";
                                                   }
                                               } else {
                                                   self.estimatedLife = @"";
                                                   self.tonnage = @"";
                                                   self.aproxChangeDate = @(0);
                                                   self.recommendedConveyorIn = @"";
                                                   self.recommendedConveyorMn = @"";
                                               }
                                               [self setUpView];
                                           });
                                       }];
}

#pragma mark - Refresh Method
- (void)refreshInfo
{
    self.isRefresh = YES;
    [self downloadClientInfo];
}


#pragma mark - Download Methods
- (void)downloadClientInfo
{
    self.isDownloadDone = self.isRefresh ? YES : NO;
    [CPClient getAllClientsWithAuthenticationKey:[CPUser sharedUser].authKey
                               completionHandler:^(NSURLResponse *response, NSError *error) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if (!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200) {
                                           [self downloadConveyorsInfo];
                                       } else {
                                           [self.refreshControl endRefreshing];
                                           [self eraseData];
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
                                               [self.refreshControl endRefreshing];
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
                                     if (!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200)
                                         [self downloadVideosInfo];
                                     else {
                                         [self.refreshControl endRefreshing];
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
                                     if (!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200)
                                         [self downloadBucketsInfo];
                                     else {
                                         [self.refreshControl endRefreshing];
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
                                       if (!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200)
                                           [self downloadNotesInfo];
                                       else {
                                           [self.refreshControl endRefreshing];
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
                                   if (!error && (long)[(NSHTTPURLResponse *)response statusCode] == 200)
                                       [self downloadReportsInfo];
                                   else {
                                       [self.refreshControl endRefreshing];
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
                                       if (success) {
                                           self.isDownloadDone = YES;
                                           self.dataError = NO;
                                           [self obtainData];
                                           [self.tableView reloadData];
                                       } else {
                                           [self eraseData];
                                       }
                                   });
                               }];
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
        self.dataError = YES;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableView Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.searchController.active ? self.searchResults.count : self.generalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ConveyorCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    UIImage *image;
    CPObject *object = self.searchController.active ? self.searchResults[indexPath.row] : self.generalArray[indexPath.row];
    if ([object isKindOfClass:[CPDataSheet class]]) {
        image = [UIImage imageNamed:@"dataIcon"];
    } else if ([object isKindOfClass:[CPImage class]]) {
        image = [UIImage imageNamed:@"photoIcon"];
    } else if ([object isKindOfClass:[CPVideo class]]) {
        image = [UIImage imageNamed:@"videoIcon"];
    } else if ([object isKindOfClass:[CPBucket class]]) {
        image = [UIImage imageNamed:@"folderIcon"];
    } else if ([object isKindOfClass:[CPReport class]]) {
        image = [UIImage imageNamed:@"reportIcon"];
    }
    cell.textLabel.text = object.name;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor colorWithRed:112.0/255.0
                                               green:117.0/255.0
                                                blue:113.0/255.0
                                               alpha:1.0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [CPLanguajeUtils languajeSelectedForString:@"Editado"], [CPDateUtils stringFromTimeStamp:@(object.updatedAt)]];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:112.0/255.0
                                                     green:117.0/255.0
                                                      blue:113.0/255.0
                                                     alpha:1.0];
    cell.imageView.image = image;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableView Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPObject *object = self.searchController.active ? self.searchResults[indexPath.row] : self.generalArray[indexPath.row];
    if ([object isKindOfClass:[CPDataSheet class]]) {
        [self performSegueWithIdentifier:@"dataSheetSegue"
                                  sender:self];
    } else if ([object isKindOfClass:[CPImage class]]) {
        self.globalImage = (CPImage *)object;
        [self performSegueWithIdentifier:@"ImageSegue"
                                  sender:self];
    } else if ([object isKindOfClass:[CPVideo class]]) {
        self.globalVideo = (CPVideo *)object;
        [self performSegueWithIdentifier:@"MovieSegue"
                                  sender:self];
    } else if ([object isKindOfClass:[CPBucket class]]) {
        self.globalBucket = (CPBucket *)object;
        [self performSegueWithIdentifier:@"FolderSegue"
                                  sender:self];
    } else if ([object isKindOfClass:[CPReport class]]) {
        self.globalReport = (CPReport *)object;
        [self performSegueWithIdentifier:@"ReportSegue"
                                  sender:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - UISearchController Delegate Methods
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [searchController.searchBar text];
    [self updateFilteredContentForObjectName:searchString];
    [self.tableView reloadData];
}

- (void)updateFilteredContentForObjectName:(NSString *)objectName
{
    if (objectName == nil || objectName.length == 0) {
        self.searchResults = [self.generalArray mutableCopy];
        return;
    }
    [self.searchResults removeAllObjects];
    for (CPObject *cpObject in self.generalArray) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange objectRangeName = NSMakeRange(0, cpObject.name.length);
        NSRange foundRange = [cpObject.name rangeOfString:objectName
                                                options:searchOptions
                                                  range:objectRangeName];
        if (foundRange.length > 0) {
            [self.searchResults addObject:cpObject];
        }
    }
}

#pragma mark - IBAction Methods
- (IBAction)openCloseMenu:(UIButton *)sender
{
    if (!self.isMenuOpen) {
        [self.view layoutIfNeeded];
        self.alphaView.hidden = NO;
        [sender setImage:[UIImage imageNamed:@"closeIcon"]
                forState:UIControlStateNormal];
        self.addImageSpaceCNST.constant = 134;
        self.addVideoSpaceCNST.constant = 71;
        self.addFolderSpaceCNST.constant = 8;
        self.addImageLB.hidden = NO;
        self.addVideoLB.hidden = NO;
        self.addFolderLB.hidden = NO;
        if (self.conveyor.ID == 0)
            self.addFolderLB.textColor = [UIColor lightGrayColor];
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];
        self.isMenuOpen = YES;
    } else {
        [self.view layoutIfNeeded];
        self.alphaView.hidden = YES;
        [sender setImage:[UIImage imageNamed:@"addButton"]
                forState:UIControlStateNormal];
        self.addImageSpaceCNST.constant = -65;
        self.addVideoSpaceCNST.constant = -65;
        self.addFolderSpaceCNST.constant = -65;
        self.addImageLB.hidden = YES;
        self.addVideoLB.hidden = YES;
        self.addFolderLB.hidden = YES;
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];
        self.isMenuOpen = NO;
    }
}

- (IBAction)openMenu:(id)sender
{
    if (self.menu.isOpen) {
        [self.menu close];
    }
    [self.menu showFromNavigationController:self.navigationController];
    self.menu.appearsBehindNavigationBar = NO;
}

- (IBAction)addFolder
{
    if (self.isInternetReachable) {
        UIAlertController *alertCreateFolder = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Nombrar Folder"]
                                                                                   message:[CPLanguajeUtils languajeSelectedForString:@"Favor de escribir el nombre del folder que se desea crear"]
                                                                            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *accept = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Aceptar"]
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                                                           name:UITextFieldTextDidChangeNotification
                                                                                                         object:nil];
                                                           [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                                                                               title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                                                                                mode:MRProgressOverlayViewModeIndeterminate
                                                                                            animated:YES];
                                                           [CPBucket saveBucketWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                                name:((UITextField *)[alertCreateFolder.textFields objectAtIndex:0]).text
                                                                                          conveyorID:self.conveyor.ID
                                                                                           createdAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                                                                           updatedAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                                                                   completionHandler:^(BOOL success) {
                                                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                                                           [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview animated:YES];
                                                                                           if (success) {
                                                                                               [self obtainData];
                                                                                               [self setUpView];
                                                                                               [self.tableView reloadData];
                                                                                               [alertCreateFolder dismissViewControllerAnimated:YES
                                                                                                                                     completion:nil];
                                                                                           } else {
                                                                                               UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al crear el folder"]
                                                                                                                                                              message:[CPLanguajeUtils languajeSelectedForString:@"Favor de tratar más tarde"]
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
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Cancelar"]
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                                                           name:UITextFieldTextDidChangeNotification
                                                                                                         object:nil];
                                                           [alertCreateFolder dismissViewControllerAnimated:YES
                                                                                                 completion:nil];
                                                       }];
        [alertCreateFolder addAction:accept];
        [alertCreateFolder addAction:cancel];
        
        [alertCreateFolder addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(alertTextFieldDidChange:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:textField];
            textField.placeholder = [CPLanguajeUtils languajeSelectedForString:@"Nombre del Folder"];
        }];
        accept.enabled = NO;
        [self presentViewController:alertCreateFolder
                           animated:YES
                         completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"¡ATENCIÓN!"]
                                                                       message:[CPLanguajeUtils languajeSelectedForString:@"Por el momento no hay conexión a internet, intentar más tarde"]
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
}

#pragma mark - NSNotificationCenter Methods
- (void)alertTextFieldDidChange:(NSNotification *)notification
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *textfield = alertController.textFields.firstObject;
        UIAlertAction *accept = alertController.actions.firstObject;
        accept.enabled = textfield.text.length > 0;
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"dataSheetSegue"]) {
        CPDataSheetViewController *dataSheetController = segue.destinationViewController;
        dataSheetController.conveyor = self.conveyor;
        dataSheetController.clientName = self.clientName;
    } else if ([segue.identifier isEqualToString:@"ImageSegue"]) {
        CPImageViewController *imageViewController = segue.destinationViewController;
        imageViewController.cpImage = self.globalImage;
        imageViewController.serialNumber = self.conveyor.serialNumber;
        imageViewController.coverImgID = self.conveyor.coverImgID;
        imageViewController.isConveyorCache = self.conveyor.ID == 0 ? YES : NO;
    } else if ([segue.identifier isEqualToString:@"MovieSegue"]) {
        CPVideoViewController *videoViewController = segue.destinationViewController;
        videoViewController.cpVideo = self.globalVideo;
        videoViewController.serialNumber = self.conveyor.serialNumber;
        videoViewController.isConveyorCache = self.conveyor.ID == 0 ? YES : NO;
    } else if ([segue.identifier isEqualToString:@"FolderSegue"]) {
        CPFolderViewController *folderViewController = segue.destinationViewController;
        folderViewController.bucket = self.globalBucket;
        folderViewController.serialNumber = self.conveyor.serialNumber;
    } else if ([segue.identifier isEqualToString:@"EditConveyorSegue"]) {
        CPAddEditConveyorViewController *addEditConveyorViewController = segue.destinationViewController;
        addEditConveyorViewController.conveyor = self.conveyor;
        addEditConveyorViewController.isEditable = YES;
        addEditConveyorViewController.isCache = NO;
        addEditConveyorViewController.clientID = self.clientID;
    } else if ([segue.identifier isEqualToString:@"AddImageSegue"]) {
        CPAddImageViewController *addImageViewController = segue.destinationViewController;
        addImageViewController.image = nil;
        addImageViewController.isEditable = NO;
        addImageViewController.conveyorID = self.conveyor.ID == 0 ? self.conveyor.createdAt : self.conveyor.ID;
        addImageViewController.bucketID = 0;
        addImageViewController.isCacheConveyor = self.conveyor.ID == 0 ? YES : NO;
    } else if ([segue.identifier isEqualToString:@"AddVideoSegue"]) {
        CPAddVideoViewController *addVideoController = segue.destinationViewController;
        addVideoController.video = nil;
        addVideoController.isEditable = NO;
        addVideoController.isCache = NO;
        addVideoController.conveyorID = self.conveyor.ID == 0 ? self.conveyor.createdAt : self.conveyor.ID;
        addVideoController.bucketID = 0;
        addVideoController.isCacheConveyor = self.conveyor.ID == 0 ? YES : NO;
    } else if ([segue.identifier isEqualToString:@"EstimatedLifeSegue"]) {
        CPEstimatedLifeViewController *estimatedLifeViewController = segue.destinationViewController;
        estimatedLifeViewController.conveyorID = self.conveyor.ID;
        estimatedLifeViewController.estimatedLife = self.estimatedLife;
        estimatedLifeViewController.tonnage = self.tonnage;
        estimatedLifeViewController.aproxChangeDate = self.aproxChangeDate;
        estimatedLifeViewController.recommendedConveyorIn = self.recommendedConveyorIn;
        estimatedLifeViewController.recommendedConveyorMm = self.recommendedConveyorMn;
    } else if ([segue.identifier isEqualToString:@"TrackingSegue"]) {
        CPBandTrackingViewController *bandTrackingViewController = segue.destinationViewController;
        bandTrackingViewController.trackingUrl = self.conveyor.trackingUrl;
    } else if ([segue.identifier isEqualToString:@"ReportSegue"]) {
        CPReportViewController *reportViewController = segue.destinationViewController;
        reportViewController.report = self.globalReport;
    } else if ([segue.identifier isEqualToString:@"RecommendedBandSegue"]) {
        CPQuoteRequestViewController *quoteRequestViewController = segue.destinationViewController;
        quoteRequestViewController.recommendedConveyorIn = self.recommendedConveyorIn;
        quoteRequestViewController.recommendedConveyorMm = self.recommendedConveyorMn;
        quoteRequestViewController.conveyorID = self.conveyor.ID;
    }
}

@end
