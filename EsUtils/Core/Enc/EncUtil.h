//
//  EncUtil.h
//  Framework_Core
//
//  Created by Authlabs on 2020/07/28.
//  Copyright © 2020 Authlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EncUtil : NSObject

#pragma mark - SHA256

/// SHA256 해시
/// @param input 해시할 값
+(NSString*)sha256:(NSString*)input;

/// SHA256 해시
/// @param input 해시할 값
+(NSData*)sha256ToFromByte:(NSData*)input;

/// SHA256 해시
/// @param input 해시할 값
+(NSData*)sha256ToByte:(NSString*)input;


#pragma mark - HMAC SHA256

/// HMAC SHA256 해시
/// @param key 키
/// @param data 데이터
+(NSString*)hmacSha256:(NSString*)key data:(NSString*)data;


#pragma mark - BASE64 ENCODE / DECODE

/// NSData -> NSData
+(NSData *)encodeB64ToData:(NSData*)input;

/// NSData -> NSString
+(NSString *)encodeB64ToString:(NSData*)input;

/// NSString -> NSData
+(NSData*)encodeB64StringToData:(NSString*)input;

/// NSData -> NSString
+(NSString*)decodeB64ToString:(NSData*)input;

// NSString -> NSString
+(NSString*)encodeB64StringToString:(NSString*)input;

/// NSData -> NSString
+(NSString*)base64forData:(NSData*)input;


#pragma mark - UTF8 ENCODE / DECODE

// NSString -> NSData
+(NSData*)encodeUTF8:(NSString*)input;

// NSData -> NSString
+(NSString*)decodeUTF8:(NSData*)input;


#pragma mark - SR

/// SecRandom 생성
/// @param length 길이
+(NSString*)generateSR:(int)length;

@end

NS_ASSUME_NONNULL_END
