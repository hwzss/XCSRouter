//
//  XCSRouterRequest.m
//  XCSRouter
//
//  Created by kaifa on 2018/11/15.
//  Copyright © 2018年 MC_MaoDou. All rights reserved.
//

#import "XCSRouterProcesser.h"
#import "XCSRouterRequestProtocl.h"
#import <UIKit/UIKit.h>


/**
 Returns a percent-escaped string following RFC 3986 for a query string key or value.
 RFC 3986 states that the following characters are "reserved" characters.
    - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="

 In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
 query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
 should be percent-escaped in the query string.
    - parameter string: The string to be percent-escaped.
    - returns: The percent-escaped string.
 */
NSString * XAFPercentEscapedStringFromString(NSString *string) {
    static NSString * const kXAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kXAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";

    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kXAFCharactersGeneralDelimitersToEncode stringByAppendingString:kXAFCharactersSubDelimitersToEncode]];

    // FIXME: https://github.com/XAFNetworking/XAFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];

    static NSUInteger const batchSize = 50;

    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;

    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);

        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];

        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];

        index += range.length;
    }

    return escaped;
}


@interface XAFQueryStringPair : NSObject
@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (instancetype)initWithField:(id)field value:(id)value;

- (NSString *)URLEncodedStringValue;
@end

@implementation XAFQueryStringPair

- (instancetype)initWithField:(id)field value:(id)value {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.field = field;
    self.value = value;

    return self;
}

- (NSString *)URLEncodedStringValue {
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return XAFPercentEscapedStringFromString([self.field description]);
    } else {
        return [NSString stringWithFormat:@"%@=%@", XAFPercentEscapedStringFromString([self.field description]), XAFPercentEscapedStringFromString([self.value description])];
    }
}

@end


static NSArray * XAFQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];

    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];

    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = dictionary[nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:XAFQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:XAFQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:XAFQueryStringPairsFromKeyAndValue(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[XAFQueryStringPair alloc] initWithField:key value:value]];
    }

    return mutableQueryStringComponents;
}

static NSArray * XAFQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    return XAFQueryStringPairsFromKeyAndValue(nil, dictionary);
}

static NSString * XAFQueryStringFromParameters(NSDictionary *parameters) {
    if (!parameters) {
        return nil;
    }
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (XAFQueryStringPair *pair in XAFQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair URLEncodedStringValue]];
    }

    return [mutablePairs componentsJoinedByString:@"&"];
}




// FIXME: 逻辑不够清晰，待梳理
static NSMapTable * _request_cache() {
    static NSMapTable *_request_cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _request_cache = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory  valueOptions:NSPointerFunctionsWeakMemory];
    });
    return _request_cache;
}

static NSString * __key(NSString *url, NSDictionary *params) {
    if (!params) {
        return url;
    }
    return [NSString stringWithFormat:@"%@%@", url, XAFQueryStringFromParameters(params)];
}

static inline __attribute__((always_inline)) void router_cache(id ob, NSString *key) {
    [_request_cache() setObject:ob forKey:key];
}

static inline __attribute__((always_inline)) id router_get_cache(NSString *key) {
    return [_request_cache() objectForKey:key];
}

@implementation XCSRouterProcesser

- (void)requestUrl:(NSString *)url parsedResult:(XCSRouterUrlParsedModel *)parsedResult registeredData:(id )registeredData {
    // FIXME: 缓存的 key 不同，应该包含参数
    // 查看缓存下是否存在该VC, 同一个url下，不跳转多次同一个界面
    NSString *key = __key(url, parsedResult.paramsDict);
    
    id cache = router_get_cache(key);
    if(cache && cache == [self presentingVc]) return;
    
    id routerResult;
    NSDictionary *params = parsedResult.paramsDict;
    
    if (!registeredData) {
        // 没有注册，检测对应url 是否能转为一个 class, 且是否是一个 controller, 是则进行处理
        Class _router_class = NSClassFromString(parsedResult.registedKey);
        if (!_router_class) return;
        if ([_router_class isSubclassOfClass:[UIViewController class]]) {
            routerResult = [self processVcRouterWithClass:_router_class
                                                      url:url
                                                   params:params
                                           registeredData:registeredData];
        }
    }else {
        if ([registeredData isKindOfClass:[NSString class]]) {
            Class __class = NSClassFromString(registeredData);
            if (!__class) return;
            if ([__class isSubclassOfClass:[UIViewController class]]) {
                routerResult = [self processVcRouterWithClass:__class
                                                          url:url
                                                       params:params
                                               registeredData:registeredData];
            }else {
                NSLog(@"XCSRouterRequest---not support this registed registeredData");
            }
        }else {
            NSString *__classStr = NSStringFromClass([registeredData class]);
            if ([__classStr isEqualToString:@"__NSMallocBlock__"] ||
                [__classStr isEqualToString:@"__NSGlobalBlock__"] ) {
                id(^_request_block)(NSDictionary *params) = registeredData;
                routerResult = _request_block(params);
            }
        }
    }
    
    !routerResult?: router_cache(routerResult, key);
}

- (id)processVcRouterWithClass:(Class )vcClass url:(NSString *)url params:(NSDictionary *)params registeredData:(id )registeredData {
    id object = [[vcClass alloc] init];
    id routerResult = object;
    // 查看viewcontroller是否有实现自己的处理方法，有就他自己处理，没有就直接创建push跳转
    BOOL didRouter = false;
    if ([object conformsToProtocol:@protocol(XCSRouterRequestProtocl)]) {
        if ([object respondsToSelector:@selector(XCSRouterRequeset:)]) {
            XCSRouterRequest *request = [[XCSRouterRequest alloc] initWithUrl:url params:params registedData:registeredData];
            didRouter = [object XCSRouterRequeset:request];
        }
    }
    
    if (!didRouter) {
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            // TODO: 添加参数校验，检查是否有这个属性，能否进行赋值，不能则跳过，避免不必要的错误
            [object setValue:obj forKeyPath:key];
        }];
        [[self presentingVc].navigationController pushViewController:object animated:YES];
    }
 
    return routerResult;
}

/**
 返回当前显示的控制器
 */
- (UIViewController *)presentingVc {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];        
        NSMutableArray *viewVcWindows = [NSMutableArray new];
        NSMutableArray *noViewVcWindows = [NSMutableArray new];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                if ([tmpWin.rootViewController isMemberOfClass:[UIViewController class]]) {
                    [viewVcWindows addObject:tmpWin];
                } else {
                    [noViewVcWindows addObject:tmpWin];
                }
            }
        }

        if (noViewVcWindows.count > 0) {
            window = noViewVcWindows[0];
        } else if (viewVcWindows.count > 0) {
            window = viewVcWindows[0];
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    
    if (result.navigationController) {
        result = result.navigationController.topViewController;
    }
    
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *) result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *) result topViewController];
    }
    
    return result;
}


@end
