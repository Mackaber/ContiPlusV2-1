//
//  CPNotificationViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/12/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPNotificationViewController.h"
#import "CPNotification.h"
#import "CPLanguajeUtils.h"
#import "CPDateUtils.h"

@interface CPNotificationViewController ()
<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *notificationsArray;
@end

@implementation CPNotificationViewController

#pragma mark - UIViewController Life Cycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createdAt"
                                                         ascending:NO];
    self.notificationsArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]
                                                                        objectForKey:@"notificationsArray"]];
    self.notificationsArray = [self.notificationsArray sortedArrayUsingDescriptors:@[sort]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (CPNotification *notif in self.notificationsArray) {
        notif.read = YES;
    }
    NSData *encodeNotificationsArray = [NSKeyedArchiver archivedDataWithRootObject:self.notificationsArray];
    [[NSUserDefaults standardUserDefaults] setObject:encodeNotificationsArray forKey:@"notificationsArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUpView
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0
                                                                           green:165.0/255.0
                                                                            blue:0.0
                                                                           alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = [CPLanguajeUtils languajeSelectedForString:@"Notificaciones"];
}

#pragma mark - UITableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.notificationsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotificationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:10];
    UILabel *notificationLabel = (UILabel *)[cell.contentView viewWithTag:20];
    
    CPNotification *cpNotification = self.notificationsArray[indexPath.row];
    dateLabel.text = [CPDateUtils comparitionStringFromTimeStamp:cpNotification.createdAt];
    if (!cpNotification.read) {
        notificationLabel.textColor = [UIColor blackColor];
    }
    notificationLabel.text = cpNotification.content;
    
    return cell;
}

#pragma mark - UITableView Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

@end
