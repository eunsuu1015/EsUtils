//
//  EncUtil.m
//  Framework_Core
//
//  Created by Authlabs on 2020/07/28.
//  Copyright © 2020 Authlabs. All rights reserved.
//

#import "EncUtil.h"
#import <CommonCrypto/CommonCryptor.h>  // SHA256
#import <CommonCrypto/CommonDigest.h>   // SHA256
#import <CommonCrypto/CommonHMAC.h>     // HMAC

@implementation EncUtil

#pragma mark - SHA256

/// SHA256 해시
+(NSString*)sha256:(NSString*)input {
    if (input == nil || [input isEqualToString:@""]) {
        return nil;
    }
    
    @try {
        const char *s = [input cStringUsingEncoding:NSASCIIStringEncoding];
        NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
        uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
        CC_SHA256(keyData.bytes, keyData.length, digest);
        NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
        
        NSMutableString *sbuf = [NSMutableString stringWithCapacity:out.length * 2];
        const unsigned char *buf = out.bytes;
        
        for(int i = 0; i < out.length; ++i){
            [sbuf appendFormat:@"%02X", (NSUInteger)buf[i]];
        }
        
        return [sbuf lowercaseString];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
    return nil;
}

/// SHA256 해시
+(NSData*)sha256ToFromByte:(NSData*)input {
    if (input == nil) {
        return nil;
    }
    
    // NSData -> NSString
    NSString *strInData = [self decodeUTF8:input];
    
    if (strInData == nil || [strInData isEqualToString:@""]) {
        return nil;
    }
    
    NSString *result = [EncUtil sha256:strInData];
    // NSString -> NSData
    return [self encodeUTF8:result];
}


/// SHA256 해시
/// @param input 해시할 값
+(NSData*)sha256ToByte:(NSString*)input {
    if (input == nil || [input isEqualToString:@""]) {
        return nil;
    }
    
    NSString *result = [EncUtil sha256:input];
    // NSString -> NSData
    return [self encodeUTF8:result];
}


#pragma mark - HMAC SHA256

/// HMAC SHA256 해시
+(NSString*)hmacSha256:(NSString*)key data:(NSString*)data {
    if (key == nil || data == nil) {
        return nil;
    }
    @try {
        const char *cKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
        const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
        unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
        CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
        NSData *hash = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
        return [EncUtil base64forData:hash];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}


#pragma mark - BASE64 ENCODE / DECODE

/// NSData -> NSData
+(NSData *)encodeB64ToData:(NSData*)input {
    return [input base64EncodedDataWithOptions:0];
}

/// NSData -> NSString
+(NSString *)encodeB64ToString:(NSData*)input {
    return [input base64EncodedStringWithOptions:0];
}

/// NSString -> NSData
+(NSData*)encodeB64StringToData:(NSString*)input {
    // encode nsstring -> nsdata
    return [[NSData alloc] initWithBase64EncodedString:input options:0];
}

/// NSData -> NSString
+(NSString*)decodeB64ToString:(NSData*)input {
    // http://iosdevelopertips.com/core-services/encode-decode-using-base64.html
    // Decoded NSString from the NSData
    // decode nsdata -> nsstring
    return [[NSString alloc] initWithData:input encoding:NSUTF8StringEncoding];
}

/// NSString -> NSString
+(NSString*)encodeB64StringToString:(NSString*)input {
    NSData *plainData = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = nil;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64String = [plainData base64Encoding];                              // pre iOS7
    }
    return base64String;
}

/// NSData -> NSString
+(NSString*)base64forData:(NSData*)input {
    const uint8_t* unitData = (const uint8_t*)[input bytes];
    NSInteger length = [input length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {  value |= (0xFF & unitData[j]);  }  }  NSInteger theIndex = (i / 3) * 4;  output[theIndex + 0] = table[(value >> 18) & 0x3F];
        output[theIndex + 1] = table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6) & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0) & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}


#pragma mark - UTF8 ENCODE / DECODE

// NSString -> NSData
+(NSData*)encodeUTF8:(NSString*)input {
    return [input dataUsingEncoding:NSUTF8StringEncoding];
}

// NSData -> NSString
+(NSString*)decodeUTF8:(NSData*)input {
    return [[NSString alloc] initWithData:input encoding:NSUTF8StringEncoding];
}


#pragma mark - SR

/// SecRandom 생성
/// @param length 길이
+(NSString*)generateSR:(int)length {
    uint8_t buffer[length];
    int nResult = SecRandomCopyBytes(kSecRandomDefault, length, buffer);
    NSMutableString *hex = nil;    
    if (nResult == 0) {
        // 생성 성공
        // buffer -> NSString 으로 변환
        hex = [[NSMutableString alloc] initWithCapacity:length];
        for (NSInteger index = 0; index < length; index++) {
            [hex appendFormat: @"%02x", buffer[index]];
        }
    }
    return hex;
}

@end
