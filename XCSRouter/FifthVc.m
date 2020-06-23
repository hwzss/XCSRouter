//
//  FifthVc.m
//  XCSRouter
//
//  Created by huwuzhen on 2019/10/18.
//  Copyright © 2019 MC_MaoDou. All rights reserved.
//

#import "FifthVc.h"
#import "XSRouter/XCSRouter.h"
#import "XCSRouterRequestProtocl.h"

@interface FifthVc ()<XCSRouterRequestProtocl>

@end

@implementation FifthVc

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
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)XCSRouterRequeset:(XCSRouterRequest *)request {
    NSString *param = [request.params objectForKey:@"aKey"];
    self.title = param;
    return NO;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
