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

#import "CDVViewController.h"
#import "CDVCommandDelegateImpl.h"
#import "CDVCommandQueue.h"

@protocol CordovaViewControllerDelegate;

@interface CordovaViewController : CDVViewController{
    NSString *urlString;
}

@property(nonatomic,assign)id<CordovaViewControllerDelegate>delegate;  ///< 事件委托

-(id)init:(NSString *)url;

@end

@interface CordovaCommandQueue : CDVCommandQueue
@end


@protocol CordovaViewControllerDelegate <NSObject>
/**
 *  加载完毕
 */
- (void)didLoadFinish;

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end