//
//  HttpUtls.m
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import "HttpUtil.h"

@implementation HttpUtil

/// 공백 제거
+(NSString *)trim:(NSString *)string {
    NSCharacterSet *cs = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSUInteger len = [string length];
    int start, end;
    unichar c;
    
    for (start=0; start < len; start++) {
        c = [string characterAtIndex:start];
        if ( [cs characterIsMember:c] == NO ) break;
    }
    
    for (end=(len-1); end >= start; end--) {
        c = [string characterAtIndex:end];
        if ( [cs characterIsMember:c] == NO ) break;
    }
    
    NSRange r = NSMakeRange(start, end-start+1);
    NSString *trimmed = [string substringWithRange:r];
    
    return trimmed;
}

/// JSON, Query String 형식에 맞는 헤더 추가
+(NSMutableDictionary*)setDefaultDic:(BOOL)isJson {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (isJson) {   // JSON
        [dic setObject:@"application/json; charset=UTF-8" forKey:@"Content-Type"];
        
    } else {        // Query String
        [dic setObject:@"application/x-www-form-urlencoded; charset=UTF-8" forKey:@"Content-Type"];
    }
    // TODO: 적용 되는지, 문제 없는지 확인 필요
    [dic setObject:@"application/json; text/json; text/javascript; text/html" forKey:@"accept"];
    return dic;
}

/// header를 sessionManager에 추가
+(AFHTTPSessionManager*)setLibHeader:(NSDictionary*)dic sessionManager:(AFHTTPSessionManager *)sessionManager {
    NSArray *arrHeader = [dic allKeys];
    for (int i = 0; i < arrHeader.count; i++) {
        NSString *key = arrHeader[i];
        NSString *value = [dic objectForKey:key];
        [sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    return sessionManager;
}

/// header를 urlRequest에 추가
+(NSMutableURLRequest*)addOsHeader:(NSDictionary*)dic urlRequest:(NSMutableURLRequest*)urlRequest {
    NSArray *arrHeader = [dic allKeys];
    for (int i = 0; i < arrHeader.count; i++) {
        NSString *key = arrHeader[i];
        NSString *value = [dic objectForKey:key];
        [urlRequest addValue:value forHTTPHeaderField:key];
    }
    return urlRequest;
}

@end
