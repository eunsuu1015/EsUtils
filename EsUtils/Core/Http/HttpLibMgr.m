//
//  HttpLibMgr.m
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import "HttpLibMgr.h"
#import "AFHTTPSessionManager.h"
#import "JSONMgr.h"
#import "HttpUtil.h"

@implementation HttpLibMgr

#pragma mark - 7.0 이상 사용 가능

#pragma mark - POST

+(void)postJSONString:(NSString *)url param:(NSString *)param header:(nullable NSDictionary*)header timeout:(int)timeout
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure {
    
    [self post:url param:param isJson:YES header:header timeout:timeout success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+(void)postJSONDic:(NSString *)url param:(NSDictionary *)param header:(nullable NSDictionary*)header timeout:(int)timeout
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure {
    
    // Dic -> String
    NSString *strParam = nil;
    if (param != nil) {
        NSMutableDictionary *mutableDicParam = [param mutableCopy];
        strParam = [JSONMgr dicToJson:mutableDicParam];
    }
    
    [self post:url param:strParam isJson:YES header:header timeout:timeout success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+(void)postQueryString:(NSString *)url param:(NSString *)param header:(nullable NSDictionary*)header timeout:(int)timeout
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure {
    
    [self post:url param:param isJson:NO header:header timeout:timeout success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+(void)postQueryDic:(NSString *)url param:(NSDictionary *)param header:(nullable NSDictionary*)header timeout:(int)timeout
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure {
    
    // Dic -> String
    NSString *strParam = nil;
    if (param != nil) {
        NSMutableDictionary *mutableDicParam = [param mutableCopy];
        strParam = [JSONMgr dicToJson:mutableDicParam];
    }
    
    [self post:url param:strParam isJson:NO header:header timeout:timeout success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


#pragma mark - 공통

/// GET
+ (void)get:(NSString *)url header:(nullable NSDictionary*)header timeout:(int)timeout
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // policy
    [sessionManager.requestSerializer setTimeoutInterval:timeout];
    [sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    [sessionManager.securityPolicy setAllowInvalidCertificates:YES];
    [sessionManager.securityPolicy setValidatesDomainName:NO];
    
    // header
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc] init];
    [dicHeader addEntriesFromDictionary:header];
    sessionManager = [HttpUtil setLibHeader:header sessionManager:sessionManager];
    
    [sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

/// POST
/// @param param isJson : YES = JSON String / isJson : NO = Query String
+(void)post:(NSString*)url param:(NSString *)param isJson:(BOOL)isJson header:(nullable NSDictionary*)header timeout:(int)timeout
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    if (isJson) {
        sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    // policy
    [sessionManager.requestSerializer setTimeoutInterval:timeout];
    [sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    [sessionManager.securityPolicy setAllowInvalidCertificates:YES];
    [sessionManager.securityPolicy setValidatesDomainName:NO];
    
    // header
    NSMutableDictionary *dicHeader = [HttpUtil setDefaultDic:isJson];
    [dicHeader addEntriesFromDictionary:header];
    sessionManager = [HttpUtil setLibHeader:dicHeader sessionManager:sessionManager];
    
    // param
    id finalParams = nil;
    if (isJson) {   // json이면 dictionary로 보냄
        NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] init];
        dicParams = [JSONMgr jsonToDic:param];
        finalParams = dicParams;
    } else {        // query면 string으로 보냄
        finalParams = param;
    }
    
    [sessionManager POST:url parameters:finalParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


@end
