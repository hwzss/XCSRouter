//
//  XCSRouterDataCenter.m
//  MC_XiaoChuShuo
//
//  Created by kaifa on 2018/11/13.
//  Copyright © 2018年 MC_MaoDou. All rights reserved.
//

#import "XCSRouterDataCenter.h"

@interface XCSRouterDataCenter ()

@property (nonatomic, strong) NSMutableDictionary *routerDictionary;

@end

@implementation XCSRouterDataCenter

- (NSMutableDictionary *)routerDictionary {
    if (!_routerDictionary) {
        _routerDictionary = [NSMutableDictionary new];
    }
    return _routerDictionary;
}

- (BOOL)registerObject:(id<NSCopying> )object forUrl:(NSString *)url {
    if (!url || !object) {
        return NO;
    }
    NSMutableDictionary *router = self.routerDictionary;
    [router setObject:object forKey:url];
    return YES;
}

- (id<NSCopying>)objectForUrl:(NSString *)url {
    if (!url) {
        return nil;
    }
    NSMutableDictionary *router = self.routerDictionary;
    return [router objectForKey:url];
}


@end
