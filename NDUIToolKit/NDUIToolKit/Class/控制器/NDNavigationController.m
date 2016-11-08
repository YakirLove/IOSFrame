//
//  NDNavigationController.m
//  NDUIToolKit
//
//  Created by zhangx on 15/8/27.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "NDNavigationController.h"

@interface NDNavigationController (){
    
}

@end

@implementation NDNavigationController

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.rootViewController = rootViewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
