//
//  HttpOsMgr.h
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpOsMgr : NSObject

/// 파라미터가 String 형식 (JSON)
+(void)postJSONString:(NSString*)url param:(NSString*)param header:(nullable NSDictionary*)header urlSession:(nullable id <NSURLSessionDelegate>)urlSession success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/// 파라미터가 Dictionary 형식 (JSON)
+(void)postJSONDic:(NSString*)url param:(NSDictionary*)param header:(nullable NSDictionary*)header urlSession:(nullable id <NSURLSessionDelegate>)urlSession success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/// 파라미터가 Data 형식 (JSON)
+(void)postJSONData:(NSString*)url param:(NSData*)param header:(nullable NSDictionary*)header urlSession:(nullable id <NSURLSessionDelegate>)urlSession success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
