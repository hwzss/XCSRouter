//
//  XCSRouterDataStorageProctol.h
//  XCSRouter
//
//  Created by kaifa on 2018/11/15.
//  Copyright © 2018年 MC_MaoDou. All rights reserved.
//

#ifndef XCSRouterDataStorageProctol_h
#define XCSRouterDataStorageProctol_h

@protocol XCSRouterDataStorageProctol <NSObject>

@required
- (BOOL)registerObject:(id<NSCopying> )object forUrl:(NSString *)url;
- (id<NSCopying>)objectForUrl:(NSString *)url;

@end


#endif /* XCSRouterDataStorageProctol_h */
