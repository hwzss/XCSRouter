//
//  XCSRouterRequest.h
//  XCSRouter
//
//  Created by kaifa on 2018/12/29.
//  Copyright © 2018 MC_MaoDou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCSRouterRequest : NSObject

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) id registerData;

- (id)initWithUrl:(NSString *)url params:(NSDictionary *)params registedData:(id )data;

@end

NS_ASSUME_NONNULL_END
