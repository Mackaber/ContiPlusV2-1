//
//  CPFolderViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/9/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPFolderViewController.h"
#import "CPBucket.h"
#import "CPImage.h"
#import "CPVideo.h"
#import "CPNote.h"
#import "CPLanguajeUtils.h"
#import "CPDateUtils.h"
#import "CPImageViewController.h"
#import "CPVideoViewController.h"
#import "CPNoteViewController.h"
#import "CPAddImageViewController.h"
#import "MRProgress.h"
#import "CPAddNoteViewController.h"
#import "CPReport.h"
#import "CPUser.h"
#import "CPReportViewController.h"
#import "CPAddVideoViewController.h"

@interface CPFolderViewController ()
<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *generalArray;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchResults;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addImageSpaceCNST;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addVideoSpaceCNST;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addNoteSpaceCNST;
@property (weak, nonatomic) IBOutlet UILabel *addImageLB;
@property (weak, nonatomic) IBOutlet UILabel *addVideoLB;
@property (weak, nonatomic) IBOutlet UILabel *addNoteLB;

@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (nonatomic) BOOL isMenuOpen;
@property (strong, nonatomic) CPImage *globalImage;
@property (strong, nonatomic) CPVideo *globalVideo;
@property (strong, nonatomic) CPNote *globalNote;
@property (strong, nonatomic) CPReport *globalReport;
@property (weak, nonatomic) IBOutlet UIButton *addBT;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *eraseBucketBT;
@property (weak, nonatomic) IBOutlet UIButton *titleBT;

@end

@implementation CPFolderViewController

#pragma mark - UIViewController LifeCycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self obtainData];
    [self setUpView];
    self.searchResults = [[NSMutableArray alloc] initWithCapacity:self.generalArray.count];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.searchController.active = NO;
}

- (void)setUpView
{
    [self setUpTitleWithName:self.bucket.name];
    self.addImageSpaceCNST.constant = -65;
    self.addVideoSpaceCNST.constant = -65;
    self.addNoteSpaceCNST.constant = -65;
    self.alphaView.hidden = YES;
    self.addImageLB.hidden = YES;
    self.addVideoLB.hidden = YES;
    self.addNoteLB.hidden = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
    self.addImageLB.text = [CPLanguajeUtils languajeSelectedForString:@"Agregar imagen"];
    self.addVideoLB.text = [CPLanguajeUtils languajeSelectedForString:@"Agregar video"];
    self.addNoteLB.text = [CPLanguajeUtils languajeSelectedForString:@"Agregar nota"];
    [self.addBT setImage:[UIImage imageNamed:@"addButton"]
                forState:UIControlStateNormal];
    self.isMenuOpen = NO;
    self.eraseBucketBT.title = [CPLanguajeUtils languajeSelectedForString:@"Eliminar"];
}

- (void)setUpTitleWithName:(NSString *)name
{
    NSString *folderName = [NSString stringWithFormat:@"%@", name];
    NSMutableAttributedString *folderAttrName = [[NSMutableAttributedString alloc] initWithString:folderName];
    [folderAttrName addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"TrebuchetMS-Bold"
                                                 size:18.0]
                           range:NSMakeRange(0, name.length)];
    self.titleBT.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleBT.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleBT setAttributedTitle:folderAttrName
                            forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpView];
    [self obtainData];
    [self.tableView reloadData];
    self.navigationController.navigationBar.hidden = NO;
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:YES];
}

- (void)obtainData
{
    self.generalArray = [NSMutableArray array];
    NSMutableArray *sortedArray = [NSMutableArray array];
    NSArray *tempImgArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"imagesArray"]];
    for (CPImage *img in tempImgArray) {
        if (img.bucketID == self.bucket.ID) {
            [sortedArray addObject:img];
        }
    }
    
    NSArray *tempVidArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"videosArray"]];
    for (CPVideo *video in tempVidArray) {
        if (video.bucketID == self.bucket.ID) {
            [sortedArray addObject:video];
        }
    }
    
    NSArray *tempNoteArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"notesArray"]];
    for (CPNote *note in tempNoteArray) {
        if (note.bucketID == self.bucket.ID) {
            [sortedArray addObject:note];
        }
    }
    
    NSArray *tempReportArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"reportsArray"]];
    for (CPReport *report in tempReportArray) {
        if (report.bucketID == self.bucket.ID) {
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
    [self.tableView reloadData];
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
    static NSString *CellIdentifier = @"FolderCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    UIImage *image;
    CPObject *object = self.searchController.active ? self.searchResults[indexPath.row] : self.generalArray[indexPath.row];
    if ([object isKindOfClass:[CPImage class]]) {
        image = [UIImage imageNamed:@"photoIcon"];
    } else if ([object isKindOfClass:[CPVideo class]]) {
        image = [UIImage imageNamed:@"videoIcon"];
    } else if ([object isKindOfClass:[CPNote class]]) {
        image = [UIImage imageNamed:@"noteIcon"];
    } else if ([object isKindOfClass:[CPReport class]]) {
        image = [UIImage imageNamed:@"reportIcon"];
    }
    cell.textLabel.text = object.name;
    cell.textLabel.textColor = [UIColor colorWithRed:112.0/255.0
                                               green:117.0/255.0
                                                blue:113.0/255.0
                                               alpha:1.0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [CPLanguajeUtils languajeSelectedForString:@"Editado"], [CPDateUtils stringFromTimeStamp:@(object.createdAt)]];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:112.0/255.0
                                                     green:117.0/255.0
                                                      blue:113.0/255.0
                                                     alpha:1.0];
    cell.imageView.image = image;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPObject *object = self.searchController.active ? self.searchResults[indexPath.row] : self.generalArray[indexPath.row];
    if ([object isKindOfClass:[CPImage class]]) {
        self.globalImage = (CPImage *)object;
        [self performSegueWithIdentifier:@"FolderImageSegue"
                                  sender:self];
    } else if ([object isKindOfClass:[CPVideo class]]) {
        self.globalVideo = (CPVideo *)object;
        [self performSegueWithIdentifier:@"FolderVideoSegue"
                                  sender:self];
    } else if ([object isKindOfClass:[CPNote class]]) {
        self.globalNote = (CPNote *)object;
        [self performSegueWithIdentifier:@"FolderNoteSegue"
                                  sender:self];
    } else if ([object isKindOfClass:[CPReport class]]) {
        self.globalReport = (CPReport *)object;
        [self performSegueWithIdentifier:@"ReportSegue"
                                  sender:self];
    }
}

#pragma mark - UITableView Delegate Methods
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

#pragma mark - IBAtion Methods
- (IBAction)openCloseMenu:(UIButton *)sender
{
    if (!self.isMenuOpen) {
        [self.view layoutIfNeeded];
        self.alphaView.hidden = NO;
        [sender setImage:[UIImage imageNamed:@"closeIcon"]
                forState:UIControlStateNormal];
        self.addImageSpaceCNST.constant = 134;
        self.addVideoSpaceCNST.constant = 71;
        self.addNoteSpaceCNST.constant = 8;
        self.addImageLB.hidden = NO;
        self.addVideoLB.hidden = NO;
        self.addNoteLB.hidden = NO;
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
        self.addNoteSpaceCNST.constant = -65;
        self.addImageLB.hidden = YES;
        self.addVideoLB.hidden = YES;
        self.addNoteLB.hidden = YES;
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.view layoutIfNeeded];
                         }];
        self.isMenuOpen = NO;
    }
}

- (IBAction)changeFolderName
{
    UIAlertController *alertEditFolder = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Nombrar Folder"]
                                                                               message:[CPLanguajeUtils languajeSelectedForString:@"Favor de escribir el nuevo nombre para folder"]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *accept = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Aceptar"]
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                                                                           title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                                                                            mode:MRProgressOverlayViewModeIndeterminate
                                                                                        animated:YES];
                                                       [CPBucket updateBucketWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                                ID:self.bucket.ID
                                                                                              name:((UITextField *)[alertEditFolder.textFields objectAtIndex:0]).text
                                                                                        conveyorID:self.bucket.conveyorID
                                                                                         createdAt:self.bucket.createdAt
                                                                                         updatedAt:[CPDateUtils timeStampFromDate:[NSDate date]]
                                                                                 completionHandler:^(BOOL success) {
                                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                                         [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview animated:YES];
                                                                                         if (success) {
                                                                                             [self setUpTitleWithName:((UITextField *)[alertEditFolder.textFields objectAtIndex:0]).text];
                                                                                             [alertEditFolder dismissViewControllerAnimated:YES
                                                                                                                                   completion:nil];
                                                                                         }
                                                                                     });
                                                                                 }];
                                                   }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Cancelar"]
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       [alertEditFolder dismissViewControllerAnimated:YES
                                                                                             completion:nil];
                                                   }];
    [alertEditFolder addAction:accept];
    [alertEditFolder addAction:cancel];
    
    [alertEditFolder addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = [CPLanguajeUtils languajeSelectedForString:@"Nombre del Folder"];
    }];
    [self presentViewController:alertEditFolder
                       animated:YES
                     completion:nil];
}

- (IBAction)eraseFolder:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"¡ATENCIÓN!"]
                                                                             message:[CPLanguajeUtils languajeSelectedForString:@"Al eliminar el folder no se podrá recuperar la información. ¿Desea continuar?"]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Sí"]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                                                                        title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                                                                         mode:MRProgressOverlayViewModeIndeterminate
                                                                                     animated:YES];
                                                    [CPBucket deleteBucketWithWithAuthenticationKey:[CPUser sharedUser].authKey
                                                                                               ID:self.bucket.ID
                                                                                completionHandler:^(BOOL success) {
                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                        [MRProgressOverlayView dismissOverlayForView:self.navigationController.navigationBar.superview
                                                                                                                            animated:YES];
                                                                                        if (success) {
                                                                                            [self.navigationController popViewControllerAnimated:YES];
                                                                                        } else {
                                                                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al borrar el folder"]
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
    UIAlertAction *no = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"No"]
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   [alertController dismissViewControllerAnimated:YES
                                                                                       completion:nil];
                                               }];
    [alertController addAction:yes];
    [alertController addAction:no];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FolderImageSegue"]) {
        CPImageViewController *imageViewController = segue.destinationViewController;
        imageViewController.cpImage = self.globalImage;
        imageViewController.serialNumber = self.serialNumber;
    } else if ([segue.identifier isEqualToString:@"FolderVideoSegue"]) {
        CPVideoViewController *videoViewController = segue.destinationViewController;
        videoViewController.cpVideo = self.globalVideo;
        videoViewController.serialNumber = self.serialNumber;
    } else if ([segue.identifier isEqualToString:@"FolderNoteSegue"]) {
        CPNoteViewController *noteViewController = segue.destinationViewController;
        noteViewController.cpNote = self.globalNote;
    } else if ([segue.identifier isEqualToString:@"AddImageSegue"]) {
        CPAddImageViewController *addImageViewController = segue.destinationViewController;
        addImageViewController.isCache = NO;
        addImageViewController.isEditable = NO;
        addImageViewController.conveyorID = self.bucket.conveyorID;
        addImageViewController.bucketID = self.bucket.ID;
    } else if ([segue.identifier isEqualToString:@"AddNoteSegue"]) {
        CPAddNoteViewController *addNoteViewController = segue.destinationViewController;
        addNoteViewController.isCache = NO;
        addNoteViewController.conveyorID = self.bucket.conveyorID;
        addNoteViewController.bucketID = self.bucket.ID;
    } else if ([segue.identifier isEqualToString:@"AddVideoSegue"]) {
        CPAddVideoViewController *addVideoViewController = segue.destinationViewController;
        addVideoViewController.isCache = NO;
        addVideoViewController.isEditable = NO;
        addVideoViewController.conveyorID = self.bucket.conveyorID;
        addVideoViewController.bucketID = self.bucket.ID;
    } else if ([segue.identifier isEqualToString:@"ReportSegue"]) {
        CPReportViewController *reportViewController = segue.destinationViewController;
        reportViewController.report = self.globalReport;
    }
}


@end
