//
//  XCSRouterDataPrcessFactorProctol.h
//  XCSRouter
//
//  Created by kaifa on 2018/11/15.
//  Copyright © 2018年 MC_MaoDou. All rights reserved.
//

#ifndef XCSRouterDataPrcessFactorProctol_h
#define XCSRouterDataPrcessFactorProctol_h

#import "XCSRouterUrlParserProctol.h"

@protocol XCSRouterDataPrcessFactorProctol <NSObject>

@required
- (void)requestUrl:(NSString *)url parsedResult:(XCSRouterUrlParsedModel *)parsedResult registeredData:(id )registeredData;

@end

#endif /* XCSRouterDataPrcessFactorProctol_h */
