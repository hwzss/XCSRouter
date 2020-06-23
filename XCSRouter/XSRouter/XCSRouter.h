//
//  XCSRouter.h
//  MC_XiaoChuShuo
//
//  Created by kaifa on 2018/11/13.
//  Copyright © 2018年 MC_MaoDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCSRouterDataStorageProctol.h"
#import "XCSRouterUrlParserProctol.h"
#import "XCSRouterDataPrcessFactorProctol.h"

NS_ASSUME_NONNULL_BEGIN

typedef id _Nullable (^XCSRouterHandlerBlock)(NSDictionary * _Nullable params);

/**
 小厨说路由管理
 */
@interface XCSRouter : NSObject

- (instancetype)initDeafult;
- (instancetype)initWithParser:(id<XCSRouterUrlParserProctol>)parser
                   dataStorage:(id<XCSRouterDataStorageProctol>)dataStorage
                     processer:(id<XCSRouterDataPrcessFactorProctol>)processer;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 根据协议路径跳转

 @param urlStr url协议路径
 */
- (void)router:(NSString *)urlStr;
- (void)routerFormatUrl:(NSString *)formatUrl, ... NS_FORMAT_FUNCTION(1,2);

/**
 注册路由协议

 @param url 对应 url 路径
 @param handler 协议对应的内容，一般放跳转代码在 block 中这样 id <XCSRouterDataPrcessFactorProctol> 执行 block 时就能跳转
 */
- (void)registerRouterUrl:(NSString *)url toHandlder:(XCSRouterHandlerBlock )handler;

/**
  注册路由协议

 @param url 对应url路径
 @param classStr 直接传class 在id <XCSRouterDataPrcessFactorProctol> 对象里处理得到的class信息，在进行跳转处理
 */
- (void)registerRouterUrl:(NSString *)url toControllerClassStr:(NSString *)classStr;

@end

/**
 默认的全局共享路由
 */
@interface XCSRouter (CUtils)

/**
 根据协议路径跳转

 @param urlStr url协议路径
 */
+ (void)router:(NSString *)urlStr;
+ (void)routerFormatUrl:(NSString *)formatUrl, ... NS_FORMAT_FUNCTION(1,2);

/**
 注册路由协议

 @param url 对应 url 路径
 @param handler 协议对应的内容，一般放跳转代码在 block 中这样 id <XCSRouterDataPrcessFactorProctol> 执行 block 时就能跳转
 */
+ (void)registerRouterUrl:(NSString *)url toHandlder:(XCSRouterHandlerBlock )handler;

/**
  注册路由协议

 @param url 对应 url 路径
 @param classStr 直接传 class 在 id <XCSRouterDataPrcessFactorProctol> 对象里处理得到的 class 信息，在进行跳转处理
 */
+ (void)registerRouterUrl:(NSString *)url toControllerClassStr:(NSString *)classStr;

@end

NS_ASSUME_NONNULL_END
