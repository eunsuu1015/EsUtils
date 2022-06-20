//
//  HttpCommManager.h
//  AllTestProj
//
//  Created by ParkEunSu on 04/11/2019.
//  Copyright © 2019 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpMgr : NSObject


#pragma mark - AFNetworking Http

+(void)postLibJSONString:(NSString*)url aram:(NSString *)param header:(nullable NSDictionary*)header timeout:(int)timeout
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

+(void)postLibJSONDic:(NSString *)url param:(NSDictionary *)param header:(nullable NSDictionary*)header timeout:(int)timeout
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;


+(void)postLibQueryString:(NSString *)url param:(NSString *)param header:(nullable NSDictionary*)header timeout:(int)timeout
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

+(void)postLibQueryDic:(NSString *)url param:(NSDictionary *)param header:(nullable NSDictionary*)header timeout:(int)timeout
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;

#pragma mark - OS


+(void)postOsJsonString:(NSString*)url param:(NSString*)param header:(nullable NSDictionary*)header timeout:(int)timeout urlSession:(nullable id <NSURLSessionDelegate>)urlSession
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;

+(void)postOsJSONDic:(NSString*)url param:(NSDictionary*)param header:(nullable NSDictionary*)header timeout:(int)timeout urlSession:(nullable id <NSURLSessionDelegate>)urlSession
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;

+(void)postOsJSONData:(NSString*)url param:(NSData*)param header:(nullable NSDictionary*)header timeout:(int)timeout urlSession:(nullable id <NSURLSessionDelegate>)urlSession
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
