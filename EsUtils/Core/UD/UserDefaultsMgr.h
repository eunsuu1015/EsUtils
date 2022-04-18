//
//  UserDefaultsMgr.h
//  EsUtils
//
//  Created by EunSu on 2020/02/09.
//  Copyright © 2020 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDefaultsMgr : NSObject

#pragma mark - String

/// 저장 String
/// @param key 키
/// @param value 값
+(void)setString:(NSString*)key value:(NSString*)value;

/// 조회 String
/// @param key 키
+(NSString*)getString:(NSString*)key;


#pragma mark - Int

/// 저장 Int
/// @param key 키
/// @param value 값
+(void)setInt:(NSString*)key value:(int)value;

/// 조회 Int
/// @param key 키
+(int)getInt:(NSString*)key;


#pragma mark - BOOL

/// 저장 Bool
/// @param key 키
/// @param value 값
+(void)setBool:(NSString*)key value:(BOOL)value;

/// 조회 Bool
/// @param key 키
+(BOOL)getBool:(NSString*)key;


#pragma mark - Comm

/// 삭제
/// @param key 키
+(void)deleteUd:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
