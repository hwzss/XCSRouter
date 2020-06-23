//
//  XCSRouterRequestProtocl.h
//  XCSRouter
//
//  Created by kaifa on 2018/11/15.
//  Copyright © 2018年 MC_MaoDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCSRouterRequest.h"

NS_ASSUME_NONNULL_BEGIN


@protocol XCSRouterRequestProtocl <NSObject>

@optional
// FIXME: 这里不一定需要返回对象，反而需压返回用户是否自己处理里跳转动作，没有的还是需要我们自己处理，以便用户自己进行参数解析设值
- (BOOL)XCSRouterRequeset:(XCSRouterRequest *)request;

@end


NS_ASSUME_NONNULL_END
