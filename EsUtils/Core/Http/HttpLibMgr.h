//
//  HttpLibMgr.h
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpLibMgr : NSObject


+(void)get:(NSString *)url header:(nullable NSDictionary*)header success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


+(void)post:(NSString *)url parameters:(NSString *)parameters isJson:(BOOL)isJson header:(nullable NSDictionary*)header
               success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
