//
//  NDTDLoadView.m
//  NDTDRequest(AFNetworking)
//
//  Created by 林 on 7/13/15.
//  Copyright (c) 2015 林. All rights reserved.
//

#import "NDTDLoadView.h"
#import "MBProgressHUD.h"

@implementation NDTDLoadView
{
    MBProgressHUD *HUD;
    UIView *_loadFatherView;
}

-(instancetype)init:(UIView *)loadFatherView
{
    self = [super init];
    if (self) {
        HUD = [[MBProgressHUD alloc] initWithView:loadFatherView];
        HUD.tag = 5201314;
        _loadFatherView = loadFatherView;
    }
    return self;
}

-(void)removeView
{
    [HUD removeFromSuperview];
    HUD = nil;
    [self removeFromSuperview];
}
-(void)dealloc
{
    HUD = nil;
}

-(BOOL)isAddHud
{
    for (int i=0; i<_loadFatherView.subviews.count; i++) {
        id classView = [_loadFatherView.subviews objectAtIndex:i];
        if ([classView isMemberOfClass:[MBProgressHUD class]]) {
            MBProgressHUD *newHud = (MBProgressHUD *)classView;
            if (newHud.tag == 5201314) {
                return YES;
            }
        }
    }
    return NO;
}

-(void)customLoadView:(id)requestData
{
    /*
    //这边添加自定义加载视图,没定义将采用默认的MBProgressHUD进行加载
    if ([requestData isMemberOfClass:[NDTDHTTPRequestData class]] && requestData!=nil) {
        NDTDHTTPRequestData *newRequest = (NDTDHTTPRequestData *)requestData;
        NSLog(@"newRequest.loadFatherView.bounds=%@",NSStringFromCGRect(newRequest.loadFatherView.bounds));
        self.frame = CGRectMake(0, 0,800,568);
        self.backgroundColor = [UIColor greenColor];
        UIView *testView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 120)];
        testView.backgroundColor = [UIColor redColor];
        [self addSubview:testView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 120)];
        titleLabel.text = newRequest.loadRemindString;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [testView addSubview:titleLabel];
    }
     */

}

-(void)customOperationView:(id)requestData
{
    //这边添加自定义操作视图，没定义将采用默认的MBProgressHUD进行加载
    if ([requestData isMemberOfClass:[NDTDHTTPRequestData class]] && requestData!=nil) {
    }
}

-(void)showLoadedView:(id)requestData
{
    
    if ([requestData isMemberOfClass:[NDTDHTTPRequestData class]] && requestData!=nil) {
        NDTDHTTPRequestData *newRequestData = (NDTDHTTPRequestData *)requestData;
        if (newRequestData.loadFatherView !=nil) {
            [self customLoadView:requestData];
            if ([self isAddHud]==NO) {
                [newRequestData.loadFatherView addSubview:HUD];
            }
            NDTDLoadView *loadView = [[NDTDLoadView alloc]init];
            [loadView customLoadView:requestData];
            if (loadView.subviews.count>0) {
                //加载自定义视图
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.color = [UIColor clearColor];
                HUD.customView = loadView;
            }
            else
            {
                HUD.mode = MBProgressHUDModeIndeterminate;
                HUD.labelText = newRequestData.loadRemindString;
            }
            [HUD show:YES];
        }
    }
    
}

-(void)showOperationView:(id)requestData
{
    
    if ([requestData isMemberOfClass:[NDTDHTTPRequestData class]] && requestData!=nil) {
        NDTDHTTPRequestData *newRequestData = (NDTDHTTPRequestData *)requestData;
        if (newRequestData.loadFatherView !=nil) {
            if ([self isAddHud]==NO) {
                [newRequestData.loadFatherView addSubview:HUD];
            }
            NDTDLoadView *loadView = [[NDTDLoadView alloc]init];
            [loadView customOperationView:requestData];
            if (loadView.subviews.count>0) {
                HUD.customView = loadView;
            }
            else
            {
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                HUD.labelText = newRequestData.operationRemindString;
            }
            HUD.mode = MBProgressHUDModeCustomView;
            [HUD show:YES];
            [HUD hide:YES afterDelay:operationalViewOfTime];
        }
    }
}

-(void)hiddenLoadedView:(id)requestData
{
    if ([requestData isMemberOfClass:[NDTDHTTPRequestData class]]) {
        NDTDHTTPRequestData *newRequestData = (NDTDHTTPRequestData *)requestData;
        if (newRequestData.loadFatherView !=nil) {
            //BOOL isHide=[MBProgressHUD hideHUDForView:newRequestData.loadFatherView animated:YES];  //隐藏
            [HUD hide:YES afterDelay:0.2];
        }
    }
}

@end
