//
//  HttpUtls.m
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import "HttpUtls.h"

@implementation HttpUtls

+(NSString *)trim:(NSString *)strInput {
    NSCharacterSet *cs = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSUInteger len = [strInput length];
    int start, end;
    unichar c;
    
    for (start=0; start < len; start++) {
        c = [strInput characterAtIndex:start];
        if ( [cs characterIsMember:c] == NO ) break;
    }
    
    for (end=(len-1); end >= start; end--) {
        c = [strInput characterAtIndex:end];
        if ( [cs characterIsMember:c] == NO ) break;
    }
    
    NSRange r = NSMakeRange(start, end-start+1);
    NSString *trimmed = [strInput substringWithRange:r];
    
    return trimmed;
}

/// JSON, Query String 형식에 맞는 헤더 추가
/// @param isJson <#isJson description#>
+(NSMutableDictionary*)setDefaultDic:(BOOL)isJson {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (isJson) {   // JSON
        [dic setObject:@"application/json; charset=UTF-8" forKey:@"Content-Type"];
        [dic setObject:@"application/json" forKey:@"accept"];
        
    } else {        // Query String        
        [dic setObject:@"application/x-www-form-urlencoded; charset=UTF-8" forKey:@"Content-Type"];
    }
    return dic;
}

// header dic에 있는걸 sessionManager.requestSerializer 에 넣어야함.
+(AFHTTPSessionManager*)setHeader:(NSDictionary*)dic sessionManager:(AFHTTPSessionManager *)sessionManager {
    // dic에 있는걸 sessionManager.requestSerializer 에 넣어야함.
    NSArray *arrHeader = [dic allKeys];
    for (int i = 0; i < arrHeader.count; i++) {
        NSString *key = arrHeader[i];
        NSString *value = [dic objectForKey:key];
        [sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    return sessionManager;
}


#pragma mark - 값 변환

/// String -> Dic 변환
/// @param json Dic으로 변환할 JSON String
+(NSMutableDictionary*)jsonToDic:(nonnull NSString*)json {
    NSMutableDictionary *result = nil;
    @try {
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        result = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        result = nil;
    }
    return result;
}

/// Dic -> String
/// @param dic JSON String으로 변환할 Dic
+(NSString*)dicToJson:(nonnull NSMutableDictionary*)dic {
    NSString *result = nil;
    @try {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
        
        if (data == nil) {
            NSLog(@"NSData로 변경 실패");
        } else {
        result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        result = nil;
    }
    return result;
}

/// Query String -> JSON String
/// @param queryString Query String
+(NSString*)queryStringToJson:(nonnull NSString*)queryString {
    NSString *result = nil;
    @try {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSArray *arrComponents = [queryString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in arrComponents) {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
            NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
            [dict setObject:value forKey:key];
        }
        id data = dict;
        //json 데이터 출력할 때 한줄씩 띄워서 보여줌.
        //    NSData *nsData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&serr];
        //json 데이터 출력할 때 쭉 일자로 보여줌.
        NSData *nsData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:nil];
        //2. json으로 변환한 NSData를 NSString으로 바꾼다.
        result = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        result = nil;
    }
    return result;
}

/// JSON String -> Query String
/// @param json JSON String
+(NSString*)jsonToQueryString:(nonnull NSString*)json {
    NSString *result = @"";
    @try {
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        if (jsonObject != nil) {
            for (int i = 0; i < [[jsonObject allKeys] count]; i++) {
                NSString *key = [[jsonObject allKeys] objectAtIndex:i];
                NSDictionary *value = [jsonObject objectForKey:key];
                if (i == [[jsonObject allKeys] count] - 1) {
                    result = [NSString stringWithFormat:@"%@%@=%@", result, key, value];
                } else {
                    result = [NSString stringWithFormat:@"%@%@=%@&", result, key, value];
                }
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        result = nil;
    }
    return result;
}


@end
