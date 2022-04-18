//
//  HttpUtls.h
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

#define CONTENT_TYPE_APPLICATION_URLENCODED @"application/x-www-form-urlencoded; charset=UTF-8"
#define CONTENT_TYPE_APPLICATION_JSON @"application/json"
#define CONTENT_TYPE_TEXT_JSON @"text/json"
#define CONTENT_TYPE_TEXT_JAVASCRIPT @"text/javascript"
#define CONTENT_TYPE_TEXT_HTML @"text/html"
#define CONTENT_TYPE_TEXT_XML @"text/xml"

#define ACCEPT @"accept"
#define USER_AGENT @"User-Agent"
#define CONTENT_TYPE @"Content-Type"
#define CONTENT_LENGTH @"Content-Length"

@interface HttpUtil : NSObject

/// 공백 제거
/// @param string 공백 제거할 텍스트
+(NSString *)trim:(NSString *)string;

/// JSON, Query String 형식에 맞는 헤더 추가
+(NSMutableDictionary*)setDefaultDic:(BOOL)isJson;

/// header를 sessionManager에 추가
+(AFHTTPSessionManager*)setLibHeader:(NSDictionary*)dic sessionManager:(AFHTTPSessionManager *)sessionManager;

/// header를 urlRequest에 추가
+(NSMutableURLRequest*)addOsHeader:(NSDictionary*)dic urlRequest:(NSMutableURLRequest*)urlRequest;

@end

NS_ASSUME_NONNULL_END
