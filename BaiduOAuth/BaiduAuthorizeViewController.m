//
//  BaiduAuthorizeViewController.m
//  Baidu SDK
//
//  Created by xiawh on 12-9-25.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//
#import "BaiduAuthorizeViewController.h"
#import "BaiduUtility.h"
#import "BaiduMacroDef.h"
#import "BaiduConfig.h"
#import "BaiduError.h"
#import "BaiduUserSessionManager.h"
#import <QuartzCore/QuartzCore.h>

#define BAIDU_AUTH_LOADING_VIEW_TAG         101

#define BAIDU_AUTH_STATUS_BAR_HEIGHT        20
#define BAIDU_AUTH_NAVIGATION_BAR_HEIGHT    45

@interface BaiduAuthorizeViewController()

- (NSURL *)oauthRequestURLWithScope:(NSString *)scope;

@end

@implementation BaiduAuthorizeViewController
@synthesize scope = _scope;
@synthesize delegate = _delegate;
@synthesize targetController = _targetController;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // Custom initialization
    [super loadView];
    CGFloat startY = 0.0f;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        startY = BAIDU_AUTH_STATUS_BAR_HEIGHT;
    }
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] init];
    navigationBar.frame = CGRectMake(0, startY, self.view.bounds.size.width, BAIDU_AUTH_NAVIGATION_BAR_HEIGHT);
    navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"百度账号"];
    navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)] autorelease];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem release];
    
    [self.view addSubview:navigationBar];
    [navigationBar release];
    
    UIWebView *authWeb = [[UIWebView alloc] init];
    authWeb.frame = CGRectMake(0, startY + BAIDU_AUTH_NAVIGATION_BAR_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - (startY + BAIDU_AUTH_NAVIGATION_BAR_HEIGHT));
    authWeb.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:authWeb];
    [authWeb release];
    
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor blackColor];
    indicatorView.bounds = CGRectMake(0, 0, 100, 100);
    indicatorView.center = authWeb.center;
    indicatorView.layer.cornerRadius = 8;
    indicatorView.layer.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7].CGColor;
    [authWeb addSubview:indicatorView];
    
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(50, 40);
    activityView.tag = BAIDU_AUTH_LOADING_VIEW_TAG;
    [indicatorView addSubview:activityView];
    [activityView release];
    [activityView startAnimating];
    
    UILabel *loadingLable = [[UILabel alloc] initWithFrame:CGRectMake(0,60,100,30)];
    loadingLable.text = [NSString stringWithFormat:@"加载中"];
    loadingLable.backgroundColor = [UIColor clearColor];
    loadingLable.textColor = [UIColor whiteColor];
    loadingLable.textAlignment = UITextAlignmentCenter;
    [indicatorView addSubview:loadingLable];
    [loadingLable release];
    [indicatorView release];
    
    indicatorView.hidden = YES;
    
    NSURL *url = [self oauthRequestURLWithScope:self.scope];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10;
    [authWeb loadRequest:request];
    authWeb.delegate = self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UIWebViewDelegate Method

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    BDLog(@"auth url:%@",url);
    NSString *query = [url fragment]; // url中＃字符后面的部分。
    if (!query) {
        query = [url query];
    }
    NSDictionary *params = [BaiduUtility parseURLParams:query];
    NSString *errorReason = [params objectForKey:@"error"];
    NSString *q = [url absoluteString];
    if( errorReason != nil && [q hasPrefix:BDAUTHORIZE_REDIRECTURI]) {
    
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(loginFailedWithError:)]) {
            BaiduError *error = [BaiduError errorWithOAuthResult:params];
            [self.delegate loginFailedWithError:error];
        }
        [self performSelector:@selector(close)];

        return NO;
    }
    
    NSString *accessToken = [params objectForKey:@"access_token"];
    if (nil != accessToken) {
        [[BaiduUserSessionManager shareUserSessionManager].currentUserSession saveUserSessionInfo:params];
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(loginDidSuccess)]) {
            [self.delegate loginDidSuccess];
        }
        [self performSelector:@selector(close)];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    UIView *indicatorView = [self.view viewWithTag:BAIDU_AUTH_LOADING_VIEW_TAG];
    indicatorView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIView *indicatorView = [self.view viewWithTag:BAIDU_AUTH_LOADING_VIEW_TAG];
    indicatorView.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(loginFailedWithError:)]) {
            [self performSelector:@selector(close)];
            [self.delegate loginFailedWithError:error];
        }
    }
}

- (NSURL *)oauthRequestURLWithScope:(NSString *)scope
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[BaiduConfig shareConfig].apiKey,@"client_id",
                                   scope,@"scope",
                                   BDAUTHORIZE_REDIRECTURI,@"redirect_uri",
                                   @"token",@"response_type",
                                   @"mobile",@"display",nil];
    
    return [BaiduUtility generateURL:BDAUTHORIZE_HOSTURL params:params];
}

- (void)close
{
    if ([NSClassFromString(@"UIViewController") instancesRespondToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            //nothing
        }];
    } else if ([NSClassFromString(@"UIViewController") instancesRespondToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    self.scope = nil;
    [super dealloc];
}
@end
