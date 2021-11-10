//
//  JsonMgr.h
//  EsUtils
//
//  Created by EunSu on 2020/02/09.
//  Copyright © 2020 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JsonMgr : NSObject

#pragma mark - 값 조회

+(NSString*)getStringFromJson:(NSString*)jsonString withKey:(NSString*)key;
+(int)getIntFromJson:(NSString*)jsonString withKey:(NSString*)key;
+(NSMutableArray*)getArrayFromJson:(NSString*)jsonString withKey:(NSString*)key;
+(NSMutableDictionary*)getDicFromJson:(NSString*)jsonString withKey:(NSString*)key;

+(NSString*)getStringFromJsonDic:(NSMutableDictionary*)jsonDic withKey:(NSString*)key;
+(int)getIntFromJsonDic:(nonnull NSMutableDictionary*)jsonDic withKey:(nonnull NSString*)key;


#pragma mark - 값 변환 (JsonMgr & HttpUtils 중복으로 있음)

+(NSMutableDictionary*)jsonToDic:(nonnull NSString*)json;
+(NSString*)dicToJson:(nonnull NSMutableDictionary*)dic;
+(NSString*)queryStringToJson:(nonnull NSString*)queryString;
+(NSString*)jsonToQueryString:(nonnull NSString*)json;

#pragma mark - 값 삭제

+(NSString *)jsonStringRemoveKey:(NSString*)key jsonString:(NSString*)jsonString;


@end

NS_ASSUME_NONNULL_END
