//
//  CPBandTrackingViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 12/31/14.
//  Copyright (c) 2014 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPBandTrackingViewController.h"
#import "MRProgress.h"
#import "CPLanguajeUtils.h"

@interface CPBandTrackingViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation CPBandTrackingViewController

#pragma mark - UIViewController LifeCycle Methods
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
    self.navigationController.navigationBar.hidden = YES;
    [MRProgressOverlayView showOverlayAddedTo:self.webView
                                        title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                         mode:MRProgressOverlayViewModeIndeterminate
                                     animated:YES];
    NSURL *url = [NSURL URLWithString:self.trackingUrl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

#pragma mark - UIWebView Delegate Methods
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:20.0
                                                  target:self
                                                selector:@selector(closeConnection)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.timer invalidate];
    [MRProgressOverlayView dismissAllOverlaysForView:self.webView
                                            animated:YES];
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error
{
    [self.timer invalidate];
    [MRProgressOverlayView dismissAllOverlaysForView:self.webView
                                            animated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al visualizar el mapa"]
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

#pragma mark - NSTimer Method
- (void)closeConnection
{
    self.webView = nil;
    [MRProgressOverlayView dismissAllOverlaysForView:self.navigationController.navigationBar.superview
                                            animated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al visualizar el mapa"]
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

#pragma mark - IBAction Methods
- (IBAction)returnToPrevController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
