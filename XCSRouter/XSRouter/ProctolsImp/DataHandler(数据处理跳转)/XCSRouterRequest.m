//
//  XCSRouterRequest.m
//  XCSRouter
//
//  Created by kaifa on 2018/12/29.
//  Copyright © 2018 MC_MaoDou. All rights reserved.
//

#import "XCSRouterRequest.h"

@implementation XCSRouterRequest

- (id)initWithUrl:(NSString *)url params:(NSDictionary *)params registedData:(id )data {
    self = [super init];
    if (self) {
        _urlStr = url;
        _params = params;
        _registerData = data;
    }
    return self;
}

@end
