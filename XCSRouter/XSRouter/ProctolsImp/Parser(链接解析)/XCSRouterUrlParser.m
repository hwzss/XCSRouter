//
//  XCSRouterUrlParser.m
//  MC_XiaoChuShuo
//
//  Created by kaifa on 2018/11/13.
//  Copyright © 2018年 MC_MaoDou. All rights reserved.
//

#import "XCSRouterUrlParser.h"

@implementation XCSRouterUrlParser

#pragma - mark utils

#pragma mark - url's path and query
/// 分离 url 中的 path 和 query 部分
/// @param url url
static inline NSArray<NSString *>* _separate_path_query(NSString *url) {
    return [url componentsSeparatedByString:@"?"];
}

/// 分类 query 中参数段
/// @param query 参数部分
static inline NSArray<NSString *>* _separate_query_s_arg_segment(NSString *query) {
    return [query componentsSeparatedByString:@"&"];
}


#pragma mark - query's args
/// 从参数部分中，提取出key,value出来
/// @param query url 中 query 部分
static NSDictionary<NSString *, NSString *>* _parsing_query_s_arg_map(NSString *query) {
    NSMutableDictionary *res = [NSMutableDictionary new];
    NSArray *kvs = _separate_query_s_arg_segment(query);
    for (NSString *kv_str in kvs) {
        XCSQueryArgsSegment argSeg = _create_args_segment(kv_str);
        if (!argSeg.name) continue;
        [res setObject:argSeg.value forKey:argSeg.name];
    }
    return res;
}

/// 从参数部分中，提取出key,value出来，支持字符串中带有占位符
/// @param query url 中 query 部分
/// @param args 占位符对应字符串
static NSDictionary<NSString *, id>* _parsing_query_s_args_map(NSString *query, va_list args) {
    NSMutableDictionary *map = [NSMutableDictionary new];
    NSArray *kvs = _separate_query_s_arg_segment(query);
    for (NSString *kv_str in kvs) {
        XCSQueryArgsSegment argSeg = _create_args_segment(kv_str);
        if (!argSeg.name) continue;
        NSString *k = argSeg.name;
        NSString *v = argSeg.value;
        // 在参数值中有占位符的值，替换为真实的值
        if ([v hasPrefix:@"%"]) {
            // TODO: 这里类型补充，可以用 fmdb 里面的代码，excutaleUpdateFormat:sql, ....
            id res = NULL;
            if ([v isEqualToString:@"%@"] || [v isEqualToString:@"%p"]) {
                res = va_arg(args, id);
            }else if ([v isEqualToString:@"%d"]) {
                int ng = va_arg(args, int);
                res = @(ng);
            }else {
#ifdef DEBUG
                @throw [NSException exceptionWithName:@"_get_va_with_format error"
                                               reason:@"不支持的类型"
                                             userInfo:nil];
#else
                res = format;
#endif
            }
            if (res) [map setObject:res forKey:k];
        }else {
            [map setObject:v forKey:k];
        }
    }
    return map;
}

/// query 中参数解析结果
typedef struct {
    id name; /// 参数名
    id value; /// 参数值
} XCSQueryArgsSegment;

static XCSQueryArgsSegment _create_args_segment(NSString *segmentStr) {
    XCSQueryArgsSegment seg = {0};
    NSArray *segments = [segmentStr componentsSeparatedByString:@"="];
    if (segments.count != 2) return seg; /// 不为 2，则不合法，返回空
    
    seg.name = segments[0];
    seg.value = segments[1];
    return seg;
}

/// 根据占位符从多参数列表中取出对应的参数值
/// @param args 参数列表
/// @param format 占位符格式，如 %d、%@
static inline __attribute__((always_inline)) id _get_va_with_format(va_list args, NSString *format) {
    id res;
    if ([format isEqualToString:@"%@"] || [format isEqualToString:@"%p"]) {
        res = va_arg(args, id);
    }else if ([format isEqualToString:@"%d"]) {
        int ng = va_arg(args, int);
        res = @(ng);
    }else {
#ifdef DEBUG
        @throw [NSException exceptionWithName:@"_get_va_with_format error"
                                       reason:@"不支持的类型"
                                     userInfo:nil];
#else
        res = format;
#endif
    }
    return res;
}


static NSArray* _str_match_regex(NSString *str, NSString *regex) {
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matches = [re matchesInString:str
                                    options:0
                                      range:NSMakeRange(0, str.length)];
    //match: 所有匹配到的字符,根据() 包含级
    NSMutableArray *arr = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        for (NSInteger i = 0, len = match.numberOfRanges; i < len; i++) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [str substringWithRange:[match rangeAtIndex:i]];
            [arr addObject:component];
        }
    }
    return arr;
}


#pragma mark - public
- (XCSRouterUrlParsedModel *)parserUrl:(NSString *)url valist:(va_list)args {
    XCSRouterUrlParsedModel *md = [XCSRouterUrlParsedModel new];
    NSArray *url_s_p_q = _separate_path_query(url);
    md.registedKey = url_s_p_q.firstObject;
    if (url_s_p_q.count == 2) {
        md.paramsDict = _parsing_query_s_args_map(url_s_p_q[1], args);
    }
    return md;
}

- (XCSRouterUrlParsedModel *)parserUrl:(NSString *)url {
    XCSRouterUrlParsedModel *model = [XCSRouterUrlParsedModel new];
    NSArray *urls_p_q = _separate_path_query(url);
    model.registedKey = urls_p_q.firstObject;
    if (urls_p_q.count == 2) {
        model.paramsDict = _parsing_query_s_arg_map(urls_p_q[1]);
    }
    return model;
}

- (XCSRouterUrlParsedModel *)parserUrls:(NSString *)url, ...{
    XCSRouterUrlParsedModel *model = [XCSRouterUrlParsedModel new];
    NSArray *urls_p_q = _separate_path_query(url);
    model.registedKey = urls_p_q.firstObject;
    if (urls_p_q.count == 2) {
        va_list ap;
        va_start(ap, url);
        model.paramsDict = _parsing_query_s_args_map(urls_p_q[1], ap);
        va_end(ap);
    }
    return model;
}


@end
