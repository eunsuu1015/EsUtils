//
//  JsonMgr.m
//  EsUtils
//
//  Created by EunSu on 2020/02/09.
//  Copyright © 2020 ParkEunSu. All rights reserved.
//

#import "JSONMgr.h"


@implementation JSONMgr

#pragma mark - 값 조회
#pragma mark JSON String 에서 값 조회

/// JSON String 에서 String 값 가져오기
+(NSString*)getStringFromJson:(nonnull NSString*)jsonString withKey:(nonnull NSString*)key {
    NSMutableDictionary *json = [self jsonToDic:jsonString];
    return [json objectForKey:key];
}

/// JSON String 에서 int 가져오기
+(int)getIntFromJson:(nonnull NSString*)jsonString withKey:(nonnull NSString*)key {
    @try {
        NSMutableDictionary *json = [self jsonToDic:jsonString];
        NSString *strResult = [json objectForKey:key];
        if (strResult != nil) {
            return [strResult intValue];
        }
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
    return 0;
}

/// JSON String 에서 리스트 가져오기
+(NSMutableArray*)getArrayFromJson:(nonnull NSString*)jsonString withKey:(nonnull NSString*)key {
    NSMutableDictionary *json = [self jsonToDic:jsonString];
    return [json objectForKey:key];
}

/// Json String 에서 Dictionary 추출
+(NSMutableDictionary*)getDicFromJson:(NSString*)jsonString withKey:(NSString*)key {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        NSLog(@"error : %@", error.description);
        return nil;
    }
    return [json objectForKey:key];
}


#pragma mark JSON Dic에서 값 조회

/// JSON Dic에서 JSON String 가져오기
+(NSString*)getStringFromJsonDic:(nonnull NSMutableDictionary*)jsonDic withKey:(nonnull NSString*)key {
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
    return result;
}


#pragma mark - 값 변환

/// String -> Dic 변환
+(NSMutableDictionary*)jsonToDic:(nonnull NSString*)json {
    @try {
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        return [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}

/// Dic -> String
+(NSString*)dicToJson:(nonnull NSMutableDictionary*)dic {
    @try {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
        if (data != nil) {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}

/// Query String -> JSON String
+(NSString*)queryStringToJson:(nonnull NSString*)queryString {
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
        //json 데이터 출력할 때 한줄씩 띄워서 보여줌
        //    NSData *nsData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&serr];
        //json 데이터 출력할 때 쭉 일자로 보여줌
        NSData *nsData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:nil];
        //2. json으로 변환한 NSData를 NSString으로 바꾼다.
        return [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}

/// JSON String -> Query String
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
// LInkedHashMap / NSSortDescriptor
+(NSString *)jsonStringRemoveKey:(NSString*)key jsonString:(NSString*)jsonString {
    @try {
        // json 공백과 줄바꿈 제거
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString *tmp = [jsonString substringFromIndex:1];
        tmp = [tmp substringToIndex:tmp.length-1];
        NSArray *arr = [tmp componentsSeparatedByString:@","];
        NSMutableString *newJson = [[NSMutableString alloc] initWithString:@""];
        
        for (int i = 0; i < arr.count - 1; i++) {
            NSString *value = [arr objectAtIndex:i];
            if (![value containsString:key]) {
                [newJson appendString:value];
                [newJson appendString:@","];
            }
        }
        NSString *resultStr = [newJson substringToIndex:newJson.length-1];
        return [NSString stringWithFormat:@"{%@}", resultStr];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
    return nil;
}

@end
