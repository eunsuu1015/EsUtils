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
+(NSString *) stringToHex:(nonnull NSString *)string;

/// Data -> String
+(NSString*) stringToUTF8Data:(nonnull NSData *)data;

/// String -> Data
+(NSData*) utf8DataToString:(nonnull NSString *) string;


#pragma mark - Base64

/// Base64 인코딩
+(NSString*)encodeBase64:(nonnull NSString*)plainString;

/// Base64 디코딩
+(NSString*)decodeBase64:(nonnull NSString*)base64String;


@end

NS_ASSUME_NONNULL_END
