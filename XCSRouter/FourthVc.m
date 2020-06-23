//
//  FourthVc.m
//  XCSRouter
//
//  Created by kaifa on 2019/1/25.
//  Copyright © 2019 MC_MaoDou. All rights reserved.
//

#import "FourthVc.h"

@interface FourthVc ()

@end

@implementation FourthVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(100, 100, 100, 100);
    [closeButton setTitle:@" 关闭  " forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    if (self.bgColor) {
        self.view.backgroundColor = self.bgColor;
    }
}

- (void)close {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
