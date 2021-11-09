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

@interface HttpUtls : NSObject

+(NSString *)trim:(NSString *)strInput;
+(NSMutableDictionary*)setDefaultDic:(BOOL)isJson;
+(AFHTTPSessionManager*)setLibHeader:(NSDictionary*)dic sessionManager:(AFHTTPSessionManager *)sessionManager;
+(NSMutableURLRequest*)addOsHeader:(NSDictionary*)dic urlRequest:(NSMutableURLRequest*)urlRequest;

#pragma mark - 값 변환 (JsonMgr & HttpUtils 중복으로 있음)

+(NSMutableDictionary*)jsonToDic:(nonnull NSString*)json;
+(NSString*)dicToJson:(nonnull NSMutableDictionary*)dic;
+(NSString*)queryStringToJson:(nonnull NSString*)queryString;
+(NSString*)jsonToQueryString:(nonnull NSString*)json;


@end

NS_ASSUME_NONNULL_END
