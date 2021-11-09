//
//  HttpOsMgr.m
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import "HttpOsMgr.h"
#import "Utils.h"
#import "JsonMgr.h"
#import "HttpUtls.h"

@implementation HttpOsMgr

#pragma mark - POST

/// 파라미터가 String 형식 (JSON)
+(void)postJSONString:(NSString*)url param:(NSString*)param header:(nullable NSDictionary*)header urlSession:(nullable id <NSURLSessionDelegate>)urlSession success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    // String -> Data
    NSData *dataParam = nil;
    if (param != nil) {
        dataParam = [param dataUsingEncoding:NSUTF8StringEncoding];
    }
        
    [self post:url param:dataParam isJson:YES header:header urlSession:urlSession success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 파라미터가 Dictionary 형식 (JSON)
+(void)postJSONDic:(NSString*)url param:(NSDictionary*)param header:(nullable NSDictionary*)header urlSession:(nullable id <NSURLSessionDelegate>)urlSession success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    // Dic -> String -> Data
    NSData *dataParam = nil;
    if (param != nil) {
        NSMutableDictionary *mutableDicParam = [param mutableCopy];
        NSString *strParam = [HttpUtls dicToJson:mutableDicParam];
        dataParam = [strParam dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    [self post:url param:dataParam isJson:YES header:header urlSession:urlSession success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 파라미터가 Data 형식 (JSON)
+(void)postJSONData:(NSString*)url param:(NSData*)param header:(nullable NSDictionary*)header urlSession:(nullable id <NSURLSessionDelegate>)urlSession success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    [self post:url param:param isJson:YES header:header urlSession:urlSession success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


#pragma mark - 최종적으로 호출하는 공통 함수

+(void)post:(NSString *)url param:(NSData *)param isJson:(BOOL)isJson header:(nullable NSDictionary*)header urlSession:(nullable id <NSURLSessionDelegate>)urlSession success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [urlRequest setTimeoutInterval:10];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSMutableDictionary *dicHeader = [HttpUtls setDefaultDic:isJson];
    [dicHeader addEntriesFromDictionary:header];
    
    NSArray *arrHeader = [dicHeader allKeys];
    for (int i = 0; i < arrHeader.count; i++) {
        NSString *key = arrHeader[i];
        NSString *value = [dicHeader objectForKey:key];
        [urlRequest addValue:value forHTTPHeaderField:key];
    }
    
    if (param != nil) {
        [urlRequest setHTTPBody:param];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    if (urlSession != nil) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:urlSession delegateQueue:nil];
    }
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            failure(error);
        } else {
            success(data);
        }
    }];
    [dataTask resume];
}

@end
