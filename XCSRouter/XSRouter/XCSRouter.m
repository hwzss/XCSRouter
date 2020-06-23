//
//  XCSRouter.m
//  MC_XiaoChuShuo
//
//  Created by kaifa on 2018/11/13.
//  Copyright © 2018年 MC_MaoDou. All rights reserved.
//

#import "XCSRouter.h"

#import "XCSRouterUrlParser.h"
#import "XCSRouterDataCenter.h"
#import "XCSRouterProcesser.h"

@interface XCSRouter ()

@property (nonatomic, strong) id<XCSRouterUrlParserProctol> routerParser;
@property (nonatomic, strong) id<XCSRouterDataStorageProctol> routerDataStorage;
@property (nonatomic, strong) id<XCSRouterDataPrcessFactorProctol> routerProcesser;

@end

@implementation XCSRouter

#pragma mark - initialize
- (instancetype)initDeafult {
    self = [super init];
    if (self) {
        _routerParser = [XCSRouterUrlParser new];
        _routerDataStorage = [XCSRouterDataCenter new];
        _routerProcesser = [XCSRouterProcesser new];
    }
    return self;
}

- (instancetype)initWithParser:(id<XCSRouterUrlParserProctol>)parser
                   dataStorage:(id<XCSRouterDataStorageProctol>)dataStorage
                     processer:(id<XCSRouterDataPrcessFactorProctol>)processer {
    self = [super init];
    if (self) {
        _routerParser = parser;
        _routerDataStorage = dataStorage;
        _routerProcesser = processer;
    }
    return self;
}

#pragma mark - router
- (void)router:(NSString *)urlStr {
    id <XCSRouterUrlParserProctol> parser = self.routerParser;
    id <XCSRouterDataStorageProctol> dataStorage = self.routerDataStorage;
    id <XCSRouterDataPrcessFactorProctol> processer = self.routerProcesser;
    XCSRouterUrlParsedModel *parsedResult = [parser parserUrl:urlStr];
    id data = [dataStorage objectForUrl:parsedResult.registedKey];
    [processer requestUrl:urlStr parsedResult:parsedResult registeredData:data];
}

- (void)routerFormatUrl:(NSString *)formatUrl, ... {
    id <XCSRouterUrlParserProctol> parser = self.routerParser;
    id <XCSRouterDataStorageProctol> dataStorage = self.routerDataStorage;
    id <XCSRouterDataPrcessFactorProctol> processer = self.routerProcesser;
    va_list pa;
    va_start(pa, formatUrl);
    XCSRouterUrlParsedModel *parsedResult = [parser parserUrl:formatUrl valist:pa];
    va_end(pa);
    id data = [dataStorage objectForUrl:parsedResult.registedKey];
    [processer requestUrl:formatUrl parsedResult:parsedResult registeredData:data];
}

#pragma mark - instance register
- (void)registerRouterUrl:(NSString *)url toHandlder:(XCSRouterHandlerBlock )handler {
    id <XCSRouterDataStorageProctol > dataStorage = self.routerDataStorage;
    [dataStorage registerObject:handler forUrl:url];
}

- (void)registerRouterUrl:(NSString *)url toControllerClassStr:(NSString *)classStr {
    id <XCSRouterDataStorageProctol > dataStorage = self.routerDataStorage;
    [dataStorage registerObject:classStr forUrl:url];
}

@end

@implementation XCSRouter (CUtils)

static XCSRouter * _shareRouter() {
    static XCSRouter *router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[XCSRouter alloc] initDeafult];
    });
    return router;
}

+ (id<XCSRouterUrlParserProctol>)routerParser {
    return _shareRouter().routerParser;
}

+ (id<XCSRouterDataStorageProctol>)routerDataStorage {
    return _shareRouter().routerDataStorage;
}

+ (id<XCSRouterDataPrcessFactorProctol>)routerProcesser {
    return _shareRouter().routerProcesser;
}

#pragma mark - class router
+ (void)router:(NSString *)urlStr {
    id <XCSRouterUrlParserProctol> parser = self.routerParser;
    id <XCSRouterDataStorageProctol> dataStorage = self.routerDataStorage;
    id <XCSRouterDataPrcessFactorProctol> processer = self.routerProcesser;
    XCSRouterUrlParsedModel *parsedResult = [parser parserUrl:urlStr];
    id data = [dataStorage objectForUrl:parsedResult.registedKey];
    [processer requestUrl:urlStr parsedResult:parsedResult registeredData:data];
}

+ (void)routerFormatUrl:(NSString *)formatUrl, ... {
    id <XCSRouterUrlParserProctol> parser = self.routerParser;
    id <XCSRouterDataStorageProctol> dataStorage = self.routerDataStorage;
    id <XCSRouterDataPrcessFactorProctol> processer = self.routerProcesser;
    va_list pa;
    va_start(pa, formatUrl);
    XCSRouterUrlParsedModel *parsedResult = [parser parserUrl:formatUrl valist:pa];
    va_end(pa);
    id data = [dataStorage objectForUrl:parsedResult.registedKey];
    [processer requestUrl:formatUrl parsedResult:parsedResult registeredData:data];
}

#pragma mark - class register
+ (void)registerRouterUrl:(NSString *)url toHandlder:(XCSRouterHandlerBlock )handler {
    id <XCSRouterDataStorageProctol > dataStorage = self.routerDataStorage;
    [dataStorage registerObject:handler forUrl:url];
}

+ (void)registerRouterUrl:(NSString *)url toControllerClassStr:(NSString *)classStr {
    id <XCSRouterDataStorageProctol > dataStorage = self.routerDataStorage;
    [dataStorage registerObject:classStr forUrl:url];
}

@end


