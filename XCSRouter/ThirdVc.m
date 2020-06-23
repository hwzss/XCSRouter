//
//  ThirdVc.m
//  XCSRouter
//
//  Created by kaifa on 2019/1/25.
//  Copyright © 2019 MC_MaoDou. All rights reserved.
//

#import "ThirdVc.h"
#import "XCSRouterRequestProtocl.h"

@interface ThirdVc ()<XCSRouterRequestProtocl>

@end

@implementation ThirdVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(100, 100, 100, 100);
    [closeButton setTitle:@" 关闭  " forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL )XCSRouterRequeset:(XCSRouterRequest *)request {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:self animated:YES completion:nil];
    return YES;
}

@end
