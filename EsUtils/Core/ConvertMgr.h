//
//  ConvertMgr.h
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConvertMgr : NSObject

#pragma mark - 형변환

/// String -> Hex로 변환
/// @param string Hex로 변환할 String
+(NSString *)stringToHex:(nonnull NSString *)string;

/// Data -> String
/// @param data String으로 변경할 Data
+(NSString*)stringToUTF8Data:(nonnull NSData *)data;

/// String -> Data
/// @param string Data로 변경할 String
+(NSData*)utf8DataToString:(nonnull NSString *) string;


#pragma mark - Base64

/// Base64 인코딩
/// @param plainString 평문
+(NSString*)encodeBase64:(nonnull NSString*)plainString;

/// Base64 디코딩
/// @param base64String Base64 인코딩된 텍스트
+(NSString*)decodeBase64:(nonnull NSString*)base64String;

/// Base64 디코딩
+ (NSString*)base64forData:(NSData*)theData;

@end

NS_ASSUME_NONNULL_END
