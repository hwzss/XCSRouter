//
//  SecondController.m
//  XCSRouter
//
//  Created by kaifa on 2018/11/15.
//  Copyright © 2018年 MC_MaoDou. All rights reserved.
//

#import "SecondController.h"
#import "XCSRouterRequestProtocl.h"
#import "XSRouter/XCSRouter.h"

@interface SecondController ()<XCSRouterRequestProtocl>

@end

@implementation SecondController

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [XCSRouter router:@"abc"];
}

- (BOOL )XCSRouterRequeset:(XCSRouterRequest *)request {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.rootViewController presentViewController:self animated:YES completion:nil];
    return YES;
}


@end
