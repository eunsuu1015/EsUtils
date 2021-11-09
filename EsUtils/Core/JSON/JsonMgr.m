//
//  JsonMgr.m
//  EsUtils
//
//  Created by EunSu on 2020/02/09.
//  Copyright © 2020 ParkEunSu. All rights reserved.
//

#import "JsonMgr.h"


@implementation JsonMgr

#pragma mark - 값 조회

/// JSON String 에서 String 값 가져오기
/// @param jsonString JSON String
/// @param key 값 조회할 키
+(NSString*)getStringFromJson:(nonnull NSString*)jsonString withKey:(nonnull NSString*)key {
    NSLog(@"start. jsonString : %@ / key : %@", jsonString, key);
    NSString *result = nil;
    @try {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        // NSData -> NSDictionary (JSON Object)
        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"error : %@", error.description);
        } else{
            result = [json objectForKey:key];
        }
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        result = nil;
    }
    NSLog(@"end. return : %@", result);
    return result;
}

/// JSON String 에서 리스트 가져오기
/// @param jsonString JSON String
/// @param key 값 조회할 키
+(NSMutableArray*)getArrayFromJson:(nonnull NSString*)jsonString withKey:(nonnull NSString*)key {
    NSLog(@"start. jsonString : %@ / withKey : %@", jsonString, key);
    NSMutableArray *result = nil;
    @try {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        // NSData -> NSDictionary (JSON Object)
        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"error : %@", error.description);
        } else {
        result = [json objectForKey:key];
        }
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        result = nil;
    }
    NSLog(@"end");
    return result;
}

/// JSON Dic에서 JSON String 가져오기
/// @param jsonDic JSON Dic
/// @param key 값 조회할 키
+(NSString*)getStringFromJsonDic:(nonnull NSMutableDictionary*)jsonDic withKey:(nonnull NSString*)key {
    NSLog(@"start. key : %@", key);
    NSString *result = nil;
    @try {
        NSString *jsonString = [self dicToJson:jsonDic];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        // NSData -> NSDictionary (JSON Object)
        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"error : %@", error.description);
        } else {
        result = [json objectForKey:key];
        }
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        result = nil;
    }
    NSLog(@"end. return : %@", result);
    return result;
}

/// JSON String 에서 int 가져오기
/// @param jsonString JSON String
/// @param key 값 조회할 키
+(int)getIntFromJson:(nonnull NSString*)jsonString withKey:(nonnull NSString*)key {
    NSLog(@"start. jsonString : %@ / key : %@", jsonString, key);
    int result = 0;
    @try {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        // NSData -> NSDictionary (JSON Object)
        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        
        if (error) {
            NSLog(@"error : %@", error.description);
            result = 0;
        } else {
        
        NSString *strResult = [json objectForKey:key];
        if (strResult == nil) {
            NSLog(@"값 가져오기 실패");
            result = 0;
        } else {

            result = [strResult intValue];
        }
        }
        
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        result = 0;
    }
    NSLog(@"end. return : %d", result);
    return  result;
}

/// Json String 에서 Dictionary 추출
/// @param jsonString JSON String
/// @param key 추출할 Dictionary key
+(NSMutableDictionary*)getDicFromJson:(NSString*)jsonString withKey:(NSString*)key {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    // NSData -> NSDictionary (JSON Object)
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        if (IS_DEBUG_LOG) NSLog(@"[ERROR] error : %@", error.description);
        return nil;
    }
    return [json objectForKey:key];
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


// JSON에서 key값을 제외한 JSON을 다시 생성
//LInkedHashMap / NSSortDescriptor
+(NSString *)jsonStringRemoveKey:(NSString*)key jsonString:(NSString*)jsonString {
    if (IS_DEBUG_LOG) NSLog(@"start");
    @try {
        // 200401 json 공백과 줄바꿈 제거
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        if (IS_DEBUG_LOG) NSLog(@"공백/줄바꿈 치환 후 json : %@", jsonString);
        NSString *tmp = [jsonString substringFromIndex:1];
        
        tmp = [tmp substringToIndex:tmp.length-1];
        NSArray *arr = [tmp componentsSeparatedByString:@","];
        
        // 새로 만들 json
        NSMutableString *newJson = [[NSMutableString alloc] initWithString:@""];
        
        for (int i = 0; i < arr.count - 1; i++) {
            NSString *value = [arr objectAtIndex:i];
            if (IS_DEBUG_LOG) NSLog(@"value : %@", value);
            if (![value containsString:key]) {
                [newJson appendString:value];
                [newJson appendString:@","];
            }
        }
        
        NSString *resultStr = [newJson substringToIndex:newJson.length-1];
        if (IS_DEBUG_LOG) NSLog(@"resultStr : %@", resultStr);
        resultStr = [NSString stringWithFormat:@"{%@}", resultStr];
        if (IS_DEBUG_LOG) NSLog(@"최종 json : %@", resultStr);
        
        return resultStr;
        
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"exception : %@", exception.description);
    }
    return nil;
}

@end
