/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  MainViewController.h
//  PhonegapTest
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "CordovaViewController.h"

@implementation CordovaViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

-(id)init:(NSString *)url;
{
    self = [super init];
    if (self) {
        urlString = [NSString stringWithFormat:@"%@",url];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.

    [super viewWillAppear:animated];
}

-(void)dealloc
{
    
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.hidden = YES;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    if(urlString != nil)
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]]];
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

#pragma mark UIWebDelegate implementation

#pragma mark 页面正在载入时 弹出等待框
- (void)webViewDidStartLoad:(UIWebView *)theWebView
{
    [super webViewDidStartLoad:theWebView];
}

- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    
    theWebView.backgroundColor = [UIColor whiteColor];
    self.webView.hidden = NO;
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    if ([self.delegate respondsToSelector:@selector(didLoadFinish)]) {
        [self.delegate didLoadFinish];
    }
    
    [super webViewDidFinishLoad:theWebView];
}



- (void)webView:(UIWebView *)theWebView didFailLoadWithError:(NSError *)error
{
    self.webView.hidden = NO;
    [super webView:theWebView didFailLoadWithError:error];
    
    if ([self.delegate respondsToSelector:@selector(didLoadFinish)]) {
        [self.delegate didLoadFinish];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    if([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)])
    {
        return [self.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    else
    {
        return YES;
    }
    
    return YES;
}

@end

