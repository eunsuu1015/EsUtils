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
+(NSData*)sha256ToFromByte:(NSData*)input;
+(NSData*)sha256ToByte:(NSString*)input;
+(NSString*)sha256ToString:(NSString*)input;

#pragma mark - HMAC SHA256
+(NSString*)hmacSha256:(NSString*)key data:(NSString*)data;

#pragma mark - BASE64 ENCODE / DECODE
+(NSData *)encodeB64ToData:(NSData*)input;
+(NSString *)encodeB64ToString:(NSData *)input;
+(NSData*)encodeB64StringToData:(NSString*)input;
+(NSString*)encodeB64StringToString:(NSString*)imput;
+(NSString*)decodeB64ToString:(NSData*)input;
+(NSString*)base64forData:(NSData*)theData;

#pragma mark - UTF8 ENCODE / DECODE
+(NSData*)encodeUTF8:(NSString*)input;
+(NSString*)decodeUTF8:(NSData*)input;

#pragma mark - SR
+(NSString*)generateSR:(int)length;

@end

NS_ASSUME_NONNULL_END
