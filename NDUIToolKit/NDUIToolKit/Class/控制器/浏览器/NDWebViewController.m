//
//  NDWebViewController.m
//  NDUIToolKit
//
//  Created by zhangx on 15/9/7.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDWebViewController.h"
#import "CordovaViewController.h"

@interface NDWebViewController ()<CordovaViewControllerDelegate>{
    NSString *_url; ///< 跳转地址
    CordovaViewController *cordovaVC; ///< cordova vc对象
    UIButton *backBtn;  ///< 插件模式的返回按钮
    
    UIView *firstPageLeftView; ///< 只有单个页面的时候左边按钮
    UIView *mutilPageLeftView; ///< 多层页面的时候左边按钮多了一个关闭功能
}

@end

@implementation NDWebViewController

#pragma mark 根据url初始化对象
- (instancetype)initWithUrl:(NSString *)url
{
    return [self initWithUrl:url isCustomNavBar:NO];
}

#pragma mark 根据url、导航条类型 初始化对象
- (instancetype)initWithUrl:(NSString *)url isCustomNavBar:(BOOL)isCustomNavBar
{
    self = [super init];
    if (self) {
        _url = url;
        [self createBackBtn];   //创建返回按钮
        [self createLeftView];   //创建左边视图
        
        _isCustomNavBar = isCustomNavBar;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    cordovaVC = [[CordovaViewController alloc] init:_url];
//    cordovaVC.startPage = _url;
    cordovaVC.delegate = self;
    
    
    if (_isCustomNavBar) {   //自定义导航栏
        self.navigationBarHidden = YES;
        backBtn.hidden = NO;
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstPageLeftView];
        cordovaVC.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        self.navigationBarHidden = NO;
        backBtn.hidden = YES;
    }
    
    [self.view addSubview:cordovaVC.view];
}

#pragma mark - CordovaViewControllerDelegate start
#pragma mark 加载完毕
- (void)didLoadFinish
{
    self.title = [cordovaVC.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if([cordovaVC.webView canGoBack]){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mutilPageLeftView];
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstPageLeftView];
    }
}
#pragma mark CordovaViewControllerDelegate end
#pragma mark -

#pragma mark 创建返回按钮
- (void)createBackBtn
{
    backBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 25, 50, 25);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    backBtn.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.8].CGColor;
    backBtn.layer.cornerRadius = 2.0f;
    backBtn.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.4];
    backBtn.layer.borderWidth = 1.0f;
}

#pragma mark 创建左边视图
- (void)createLeftView
{
    firstPageLeftView = [self navBackBtnWithTarget:self action:@selector(backAction:)];

    mutilPageLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NDUI_NAV_BAR_HEIGHT * 2 + 5, NDUI_NAV_BAR_HEIGHT)];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(NDUI_NAV_BAR_HEIGHT + 5, 0, NDUI_NAV_BAR_HEIGHT, NDUI_NAV_BAR_HEIGHT);
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:NDUI_LABEL_DEFUALT_FONT_SIZE];
    
    [mutilPageLeftView addSubview:[self navBackBtnWithTarget:self action:@selector(webviewBackAction:)]];
    [mutilPageLeftView addSubview:closeBtn];
}

#pragma mark 网页回退
- (void)webviewBackAction:(id)sender
{
    if([cordovaVC.webView canGoBack]){
        [cordovaVC.webView goBack];
    }else{
        [cordovaVC.webView stopLoading];
        cordovaVC.webView.delegate = nil;
        [self backAction:nil];
    }
}

#pragma mark 导航条返回按钮
- (UIButton *)navBackBtnWithTarget:(id)target action:(SEL)action
{
    UIButton *navBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navBackBtn.frame = CGRectMake(0, 0, NDUI_NAV_BAR_HEIGHT, NDUI_NAV_BAR_HEIGHT);
    [navBackBtn setTitle:@"返回" forState:UIControlStateNormal];
    [navBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navBackBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    navBackBtn.titleLabel.font = [UIFont systemFontOfSize:NDUI_LABEL_DEFUALT_FONT_SIZE];
    
    UIButton *iconImage = [UIButton buttonWithType:UIButtonTypeCustom];
    iconImage.frame = CGRectMake(- 15, 0, 24, 44);
    [iconImage setImage:[UIImage imageInUIToolKitProject:@"voipBackArrow"] highLightImage:nil];
    [iconImage addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [navBackBtn addSubview:iconImage];
    
    return navBackBtn;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
