//
//  CPClientInfoViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 11/23/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPClientInfoViewController.h"
#import "CPLanguajeUtils.h"
#import "DejalActivityView.h"
#import "CPClient.h"
#import "CPConveyor.h"
#import "SWTableViewCell.h"
#import "CPDateUtils.h"
#import "CPAddEditConveyorViewController.h"
#import "CPConveyorInfoViewController.h"
#import "MRProgress.h"
#import "CPUser.h"

@interface CPClientInfoViewController ()
<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, UISearchResultsUpdating>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *clientNameLB;
@property (weak, nonatomic) IBOutlet UILabel *corporationLB;
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
@property (weak, nonatomic) IBOutlet UILabel *cityLB;
@property (weak, nonatomic) IBOutlet UILabel *countryLB;
@property (weak, nonatomic) IBOutlet UILabel *dealerTextLB;
@property (weak, nonatomic) IBOutlet UILabel *dealerLB;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *regionTextLB;
@property (weak, nonatomic) IBOutlet UILabel *regionLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeigthCNST;
@property (nonatomic, assign) CGFloat lastContentOffset;

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) NSMutableArray *clientConveyorArray;
@property (strong, nonatomic) CPConveyor *globalConveyor;
@property (strong, nonatomic) UIImage *image;
@end

@implementation CPClientInfoViewController

#pragma mark - UIViewController LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.lastContentOffset = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"serialNumber"
                                                         ascending:YES
                                                          selector:@selector(caseInsensitiveCompare:)];
    NSArray *tempSortedArray = [NSArray array];
    tempSortedArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"conveyorsArray"]];
    tempSortedArray = [tempSortedArray sortedArrayUsingDescriptors:@[sort]];
    self.allConveyorsArray = [NSMutableArray arrayWithArray:tempSortedArray];
    [self obtainData];
    [self.tableView reloadData];
}

- (void)setUpView
{
    self.title = self.client.name;
    [self obtainData];
    [self.tableView reloadData];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
    self.imageView.clipsToBounds = YES;
    
    __block UIImage *image;
    [DejalKeyboardActivityView activityViewForView:self.imageView withLabel:@""];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:self.client.imageLink];
        __block NSData *imageData = nil;
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            imageData = [NSData dataWithContentsOfURL:url];
            image = [UIImage imageWithData:imageData];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [DejalKeyboardActivityView removeViewAnimated:YES];
                if (image) {
                    self.imageView.image = image;
                }
                else {
                    self.imageView.image = [UIImage imageNamed:@"defaultCompany"];
                }
            });
        });
    });
    self.clientNameLB.text = self.client.name;
    self.corporationLB.text = self.client.corporation;
    self.addressLB.text = self.client.address;
    self.cityLB.text = self.client.city;
    self.countryLB.text = self.client.country;
    self.dealerTextLB.text = [CPLanguajeUtils languajeSelectedForString:@"Distribuidor asociado:"];
    self.dealerLB.text = self.client.dealer;
    self.regionTextLB.text = [CPLanguajeUtils languajeSelectedForString:@"Región:"];
    self.regionLB.text = self.client.region;
    
    self.searchResults = [[NSMutableArray alloc] initWithCapacity:self.clientConveyorArray.count];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.searchController.active = NO;
}

- (void)obtainData
{
    self.clientConveyorArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.allConveyorsArray.count; i++) {
        CPConveyor *conveyor = self.allConveyorsArray[i];
        if (conveyor.clientID == self.client.ID) {
            [self.clientConveyorArray addObject:conveyor];
        }
    }
}

#pragma mark - UITableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.searchController.active ? self.searchResults.count : self.clientConveyorArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier
                                  containingTableView:tableView
                                   leftUtilityButtons:nil
                                  rightUtilityButtons:[self rightButtonsConveyor]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.delegate = self;
    }
    CPConveyor *conveyor = self.searchController.active ? [self.searchResults objectAtIndex:indexPath.row] : [self.clientConveyorArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"conveyorIcon"];
    cell.textLabel.text = conveyor.serialNumber;
    cell.textLabel.textColor = [UIColor colorWithRed:112.0/255.0
                                               green:117.0/255.0
                                                blue:113.0/255.0
                                               alpha:1.0];
    cell.detailTextLabel.text = cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@", [CPLanguajeUtils languajeSelectedForString:@"Editado"], [CPDateUtils stringFromTimeStamp:@(conveyor.updatedAt)]];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:112.0/255.0
                                                     green:117.0/255.0
                                                      blue:113.0/255.0
                                                     alpha:1.0];
    
    return cell;
}

#pragma mark - TableView Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableView.isEditing)
        [tableView deselectRowAtIndexPath:indexPath
                                 animated:YES];
        self.globalConveyor = self.searchController.active ? self.searchResults[indexPath.row] : self.clientConveyorArray[indexPath.row];
        [self performSegueWithIdentifier:@"ConveyorSegue"
                                  sender:self];

}

#pragma mark - ScrollView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.searchController.active) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            [self.view layoutIfNeeded];
            self.infoViewHeigthCNST.constant = 155;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [self.view layoutIfNeeded];
                             }];
        } else if (self.lastContentOffset < scrollView.contentOffset.y) {
            [self.view layoutIfNeeded];
            self.infoViewHeigthCNST.constant = 0;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [self.view layoutIfNeeded];
                             }];
        }
    }
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
                                                title:[CPLanguajeUtils languajeSelectedForString:@"Borrar"]];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell
didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CPConveyor *conveyor = self.searchController.active ? self.searchResults[indexPath.row] : self.clientConveyorArray[indexPath.row];
    switch (index) {
        case 0:
            [self.searchController.searchBar resignFirstResponder];
            self.globalConveyor = conveyor;
            [self performSegueWithIdentifier:@"editConveyorFromClientSegue"
                                      sender:self];
                break;
        case 1:
        {
            [self.searchController.searchBar resignFirstResponder];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"¡ATENCIÓN!"]
                                                                           message:[CPLanguajeUtils languajeSelectedForString:@"Al eliminar el transportador no se podrá recuperar la información y todos los elementos asociados se perderán. ¿Desea continuar?"]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *erase = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Si"]
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [MRProgressOverlayView showOverlayAddedTo:[[[UIApplication sharedApplication] windows] objectAtIndex:0]
                                                                                                  title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                                                                                   mode:MRProgressOverlayViewModeIndeterminate
                                                                                               animated:YES];
                                                              [CPConveyor deleteConveyorWithWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                                               ID:conveyor.ID
                                                                                                completionHandler:^(BOOL success) {
                                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                        [MRProgressOverlayView dismissOverlayForView:[[[UIApplication sharedApplication] windows] objectAtIndex:0]
                                                                                                                                            animated:YES];
                                                                                                        if (success) {
                                                                                                            [alert dismissViewControllerAnimated:YES
                                                                                                                                      completion:nil];
                                                                                                            [self.searchResults removeObject:conveyor];
                                                                                                            [self.clientConveyorArray removeObject:conveyor];
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

#pragma mark - UISearchController Delegate Methods
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [searchController.searchBar text];
    [self updateFilteredContentForConveyorSerialNumber:searchString];
    [self.tableView reloadData];
}

- (void)updateFilteredContentForConveyorSerialNumber:(NSString *)conveyorSerialNumber
{
    if (conveyorSerialNumber == nil || conveyorSerialNumber.length == 0) {
        self.searchResults = [self.clientConveyorArray mutableCopy];
        return;
    }
    
    [self.searchResults removeAllObjects];
    
    for (CPConveyor *conveyor in self.clientConveyorArray) {
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

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CPAddEditConveyorViewController *addEditConveyorViewController = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"editConveyorFromClientSegue"]) {
        addEditConveyorViewController.conveyor = self.globalConveyor;
        addEditConveyorViewController.isEditable = YES;
        addEditConveyorViewController.isCache = NO;
        addEditConveyorViewController.clientID = self.client.ID;
    } else if ([segue.identifier isEqualToString:@"addConveyorSegue"]) {
        addEditConveyorViewController.conveyor = nil;
        addEditConveyorViewController.isEditable = NO;
        addEditConveyorViewController.isCache = NO;
        addEditConveyorViewController.clientID = self.client.ID;
    } else if ([segue.identifier isEqualToString:@"ConveyorSegue"]) {
        CPConveyorInfoViewController *conveyorInfoController = segue.destinationViewController;
        conveyorInfoController.conveyor = self.globalConveyor;
        conveyorInfoController.clientName = self.client.name;
        conveyorInfoController.clientID = self.client.ID;
    }
    
}

@end
