//
//  HttpLibMgr.m
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import "HttpLibMgr.h"
#import "AFHTTPSessionManager.h"
#import "Utils.h"
#import "JsonMgr.h"
#import "HttpUtls.h"

@implementation HttpLibMgr

#pragma mark - 7.0 이상 사용 가능

#pragma mark - GET

/// GET
/// POST 형식과 동일하게 변경했는데, 실제로 적용이 되는지는 확인 필요함.
/// @param url url
// @param completionHandler 결과 핸들러
+ (void)get:(NSString *)url header:(nullable NSDictionary*)header success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc] init];
    [dicHeader addEntriesFromDictionary:header];
    
    sessionManager = [HttpUtls setHeader:header sessionManager:sessionManager];
    
    sessionManager.securityPolicy.allowInvalidCertificates = YES;
    sessionManager.securityPolicy.validatesDomainName = NO;
    
    [sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        NSMutableDictionary *dic = [responseDic copy];
        NSString *result = [HttpUtls dicToJson:dic];
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        
    }];
}


#pragma mark - POST

/// POST
/// @param url url
/// @param parameters 파라미터 (key&value 형식 또는 JSON으로 전달됨. JSON으로 전달되는 경우는 Dictionary로 변경함)
/// @param isJson JSON 형식 여부
// @param completionHandler 결과 핸들러
+ (void)post:(NSString *)url param:(NSString *)param isJson:(BOOL)isJson header:(nullable NSDictionary*)header
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure {
    
    [self post:url param:param isJson:isJson header:header success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


/// POST
/// @param url url
/// @param parameters 파라미터 (key&value 형식 또는 JSON으로 전달됨. JSON으로 전달되는 경우는 Dictionary로 변경함)
/// @param isJson JSON 형식 여부
// @param completionHandler 결과 핸들러
+ (void)performPostForFido:(NSString *)url param:(NSString *)param isJson:(BOOL)isJson header:(nullable NSDictionary*)header success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    [self post:url param:param isJson:isJson header:header success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


#pragma mark - 최종적으로 호출하는 공통 함수

// 최종적으로 호출하는 라이브러리 post 통신
+(void)post:(NSString*)url param:(NSString *)param isJson:(BOOL)isJson header:(nullable NSDictionary*)header success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *dicParams = [[NSMutableDictionary alloc] init];
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    if (isJson) {
        sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSMutableDictionary *dicHeader = [HttpUtls setDefaultDic:isJson];
    [dicHeader addEntriesFromDictionary:header];
    
    id finalParams = nil;
    
    if (isJson) {   // json이면 dictionary로 보냄
        if (dicParams != nil) {
            dicParams = [HttpUtls jsonToDic:param];
        }
        finalParams = dicParams;
        
    } else {        // query면 string으로 보냄
        finalParams = param;
    }
    
    sessionManager = [HttpUtls setHeader:dicHeader sessionManager:sessionManager];
    
    [sessionManager POST:url parameters:finalParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


@end
