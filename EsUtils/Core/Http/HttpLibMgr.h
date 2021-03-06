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

+(void)postJSONString:(NSString *)url param:(NSString *)param header:(nullable NSDictionary*)header timeout:(int)timeout
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;

+(void)postJSONDic:(NSString *)url param:(NSDictionary *)param header:(nullable NSDictionary*)header timeout:(int)timeout
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

+(void)postQueryString:(NSString *)url param:(NSString *)param header:(nullable NSDictionary*)header timeout:(int)timeout
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;

+(void)postQueryDic:(NSString *)url param:(NSDictionary *)param header:(nullable NSDictionary*)header timeout:(int)timeout
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
