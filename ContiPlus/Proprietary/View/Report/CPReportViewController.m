//
//  CPReportViewController.m
//  ContiPlus
//
//  Created by Jonathan Jimenez Sandoval on 1/1/15.
//  Copyright (c) 2015 Jonathan Jimenez Sandoval. All rights reserved.
//

#import "CPReportViewController.h"
#import "CPReport.h"
#import "MRProgress.h"
#import "CPLanguajeUtils.h"

@interface CPReportViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation CPReportViewController

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
    NSString *url = [self.report.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.title = self.report.name;
    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.navigationBar.superview
                                        title:[CPLanguajeUtils languajeSelectedForString:@"Procesando..."]
                                         mode:MRProgressOverlayViewModeIndeterminate
                                     animated:YES];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:requestObj];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    self.webView.scalesPageToFit = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIView *v = self.webView;
    while (v) {
        v.backgroundColor = [UIColor whiteColor];
        v = [v.subviews firstObject];
    }
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[CPLanguajeUtils languajeSelectedForString:@"Error al abrir el reporte"]
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
