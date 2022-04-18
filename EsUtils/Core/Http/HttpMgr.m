//
//  HttpCommManager.m
//  AllTestProj
//
//  Created by Authlabs on 04/11/2019.
//  Copyright © 2019 Authlabs. All rights reserved.
//

#import "HttpMgr.h"

#import "HttpOSMgr.h"
#import "HttpLibMgr.h"


@implementation HttpMgr


#pragma mark - AFNetworking Http

+(void)postLibJSONString:(NSString*)url aram:(NSString *)param header:(nullable NSDictionary*)header timeout:(int)timeout
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure {
    [HttpLibMgr postJSONString:url param:param header:header timeout:timeout success:success failure:failure];
}

+(void)postLibJSONDic:(NSString *)url param:(NSDictionary *)param header:(nullable NSDictionary*)header timeout:(int)timeout
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure {
    [HttpLibMgr postJSONDic:url param:param header:header timeout:timeout success:success failure:failure];
}

+(void)postLibQueryString:(NSString *)url param:(NSString *)param header:(nullable NSDictionary*)header timeout:(int)timeout
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure {
    [HttpLibMgr postQueryString:url param:param header:header timeout:timeout success:success failure:failure];
}

+(void)postLibQueryDic:(NSString *)url param:(NSDictionary *)param header:(nullable NSDictionary*)header timeout:(int)timeout
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure {
    [HttpLibMgr postQueryDic:url param:param header:header timeout:timeout success:success failure:failure];
}


#pragma mark - OS

+(void)postOsJsonString:(NSString*)url param:(NSString*)param header:(nullable NSDictionary*)header timeout:(int)timeout urlSession:(nullable id <NSURLSessionDelegate>)urlSession
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure {
    [HttpOSMgr postJSONString:url param:param header:header timeout:timeout urlSession:urlSession success:success failure:failure];
}

+(void)postOsJSONDic:(NSString*)url param:(NSDictionary*)param header:(nullable NSDictionary*)header timeout:(int)timeout urlSession:(nullable id <NSURLSessionDelegate>)urlSession
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure {
    [HttpOSMgr postJSONDic:url param:param header:header timeout:timeout urlSession:urlSession success:success failure:failure];
}

+(void)postOsJSONData:(NSString*)url param:(NSData*)param header:(nullable NSDictionary*)header timeout:(int)timeout urlSession:(nullable id <NSURLSessionDelegate>)urlSession
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure {
    [HttpOSMgr postJSONData:url param:param header:header timeout:timeout urlSession:urlSession success:success failure:failure];
}

@end
