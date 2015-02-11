//
//  CPWebViewSettingsViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 1/1/15.
//  Copyright (c) 2015 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPWebViewSettingsViewController.h"
#import "MRProgress.h"
#import "CPLanguajeUtils.h"

@interface CPWebViewSettingsViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation CPWebViewSettingsViewController

#pragma mark - UIViewController Lifecycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.webView.delegate = nil;
    self.webView = nil;
}

- (void)setUpView
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0
                                                                           green:165.0/255.0
                                                                            blue:0.0
                                                                           alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                        title:@""
                                         mode:MRProgressOverlayViewModeIndeterminate
                                     animated:YES];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:requestObj];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    self.webView.scalesPageToFit = YES;
}

#pragma mark - UIWebView Delegate Methods
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MRProgressOverlayView dismissAllOverlaysForView:self.navigationController.navigationBar.superview
                                            animated:YES];
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error
{
    [MRProgressOverlayView dismissAllOverlaysForView:self.navigationController.navigationBar.superview
                                            animated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al mostrar la información"]
                                                                   message:[CPLanguajeUtils languajeSelectedForString:@"Favor de verificar tu conexión a internet o intentar más tarde"]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Ok"]
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   [alert dismissViewControllerAnimated:YES
                                                                             completion:nil];
                                                   [self.navigationController popViewControllerAnimated:YES];
                                               }];
    [alert addAction:ok];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}


@end
