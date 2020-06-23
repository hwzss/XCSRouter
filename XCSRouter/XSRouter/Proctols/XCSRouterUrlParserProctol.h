//
//  XCSRouterUrlParserProctol.h
//  XCSRouter
//
//  Created by kaifa on 2018/11/15.
//  Copyright © 2018年 MC_MaoDou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCSParamPack : NSObject

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *type;

- (id)unpack;

@end

@interface XCSRouterUrlParsedModel : NSObject

@property (nonatomic, copy) NSString *registedKey;
@property (nonatomic, strong) NSDictionary *paramsDict;

@end

@protocol XCSRouterUrlParserProctol <NSObject>

- (XCSRouterUrlParsedModel *)parserUrl:(NSString *)url;
- (XCSRouterUrlParsedModel *)parserUrl:(NSString *)url valist:(va_list)va;

@optional
- (XCSRouterUrlParsedModel *)parserUrls:(NSString *)url, ...NS_FORMAT_FUNCTION(1,2) ;

@end


NS_ASSUME_NONNULL_END
