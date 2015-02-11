//
//  CPWebViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 1/1/15.
//  Copyright (c) 2015 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPWebViewController.h"
#import "MRProgress.h"
#import "CPLanguajeUtils.h"
#import "DejalActivityView.h"

@interface CPWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation CPWebViewController

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
    [self setNeedsStatusBarAppearanceUpdate];
    [DejalBezelActivityView activityViewForView:self.view
                                      withLabel:@""];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:requestObj];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    self.webView.scalesPageToFit = YES;
}

#pragma mark - UIStatusBar White Color
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIWebView Delegate Methods
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error
{
    [DejalBezelActivityView removeViewAnimated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al mostrar la información"]
                                                                   message:[CPLanguajeUtils languajeSelectedForString:@"Favor de verificar tu conexión a internet o intentar más tarde"]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Ok"]
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   [alert dismissViewControllerAnimated:YES
                                                                             completion:nil];
                                                   [self dismissViewControllerAnimated:YES
                                                                            completion:nil];
                                               }];
    [alert addAction:ok];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - IBAction Methods
- (IBAction)returnToPreViewController
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}
@end
