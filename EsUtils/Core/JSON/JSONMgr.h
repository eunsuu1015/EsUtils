//
//  JsonMgr.h
//  EsUtils
//
//  Created by EunSu on 2020/02/09.
//  Copyright © 2020 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSONMgr : NSObject

#pragma mark - 값 조회
#pragma mark JSON String 에서 값 조회

/// JSON String 에서 String 값 가져오기
/// @param jsonString JSON String
/// @param key 값 조회할 키
+(NSString*)getStringFromJson:(NSString*)jsonString withKey:(NSString*)key;

/// JSON String 에서 int 가져오기
/// @param jsonString JSON String
/// @param key 값 조회할 키
+(int)getIntFromJson:(NSString*)jsonString withKey:(NSString*)key;

/// JSON String 에서 리스트 가져오기
/// @param jsonString JSON String
/// @param key 값 조회할 키
+(NSMutableArray*)getArrayFromJson:(NSString*)jsonString withKey:(NSString*)key;

/// Json String 에서 Dictionary 추출
/// @param jsonString JSON String
/// @param key 추출할 Dictionary key
+(NSMutableDictionary*)getDicFromJson:(NSString*)jsonString withKey:(NSString*)key;

#pragma mark JSON Dic에서 값 조회

/// JSON Dic에서 JSON String 가져오기
/// @param jsonDic JSON Dic
/// @param key 값 조회할 키
+(NSString*)getStringFromJsonDic:(NSMutableDictionary*)jsonDic withKey:(NSString*)key;


#pragma mark - 값 변환

/// String -> Dic 변환
/// @param json Dic으로 변환할 JSON String
+(NSMutableDictionary*)jsonToDic:(nonnull NSString*)json;

/// Dic -> String
/// @param dic JSON String으로 변환할 Dic
+(NSString*)dicToJson:(nonnull NSMutableDictionary*)dic;

/// Query String -> JSON String
/// @param queryString Query String
+(NSString*)queryStringToJson:(nonnull NSString*)queryString;

/// JSON String -> Query String
/// @param json JSON String
+(NSString*)jsonToQueryString:(nonnull NSString*)json;


#pragma mark - 값 삭제

// JSON에서 key값을 제외한 JSON을 다시 생성
// LInkedHashMap / NSSortDescriptor
+(NSString *)jsonStringRemoveKey:(NSString*)key jsonString:(NSString*)jsonString;

@end

NS_ASSUME_NONNULL_END
