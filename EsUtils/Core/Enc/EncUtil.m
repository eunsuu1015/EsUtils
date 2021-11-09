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

/// 일반적으로 이걸 많이 사용함
/// SHA256 해시
/// @param input 해시할 값
+(NSString*)sha256:(NSString*)input {
    NSLog(@"start#");
    @try {
        if (input == nil || [input isEqualToString:@""]) {
            NSLog(@"return : nil");
            return nil;
        }
        
        const char *s = [input cStringUsingEncoding:NSASCIIStringEncoding];
        NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
        uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
        CC_SHA256(keyData.bytes, keyData.length, digest);
        NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
        
        NSMutableString *sbuf = [NSMutableString stringWithCapacity:out.length * 2];
        const unsigned char *buf = out.bytes;
        
        int i = 0;
        for(i = 0; i < out.length; ++i){
            [sbuf appendFormat:@"%02X", (NSUInteger)buf[i]];
        }
        
        sbuf = [sbuf lowercaseString];
        
        if (sbuf == nil || [sbuf isEqualToString:@""]) {
            // 해시 실패
            NSLog(@"return : nil#");
            return nil;
        }
        
        NSLog(@"end#");
        return sbuf;
        
    } @catch (NSException *exception) {
        
    }
    return nil;
}


/// SHA256 해시
/// @param input 해시할 값
+(NSData*)sha256ToFromByte:(NSData*)input {
    NSLog(@"start#");
    
    if (input == nil) {
        NSLog(@"return : nil");
        return nil;
    }
    
    // NSData -> NSString
    NSString *strInData = [self decodeUTF8:input];
    
    if (strInData == nil || [strInData isEqualToString:@""]) {
        NSLog(@"str 값은 nil 이거나 공백이 아니어야 합니다");
        NSLog(@"return : nil#");
        return nil;
    }
    
    NSString *result = [EncUtil sha256:strInData];
        
    // NSString -> NSData
    NSData *data = nil;
    data = [self encodeUTF8:result];
    
    if (data == nil) {
        NSLog(@"return : nil");
        return nil;
    }
    
    NSLog(@"end");
    return data;
}


/// SHA256 해시
/// @param input 해시할 값
+(NSData*)sha256ToByte:(NSString*)input {
    NSLog(@"start#");
    
    if (input == nil || [input isEqualToString:@""]) {
        // parameter null check
        NSLog(@"return : nil");
        return nil;
    }
    
    NSString *result = [EncUtil sha256:input];
    
    // NSString -> NSData
    NSData *data = nil;
    data = [self encodeUTF8:result];
    
    if (data == nil) {
        NSLog(@"return : nil");
        return nil;
    }
    
    NSLog(@"end");
    return data;
}

#pragma mark - HMAC SHA256

+(NSString*)hmacSha256:(NSString*)key data:(NSString*)data {
    NSLog(@"start. key : %@ / data : %@", key, data);
    
    if (key == nil || data == nil) {
        NSLog(@"key 또는 data nil");
        return nil;
    }
    
    @try {
        
        const char *cKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
        const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
        unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
        CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
        NSData *hash = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
        
        NSString* s = [EncUtil base64forData:hash];
        
        NSString *base64String = [hash base64EncodedStringWithOptions:0];
        
        NSLog(@"data : %@", s);
        
        NSLog(@"base64String : %@", base64String);
        
        return s;
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
    
    return nil;
    
}

#pragma mark - BASE64 ENCODE / DECODE

// 맞춤
// NSData -> NSData
+(NSData *)encodeB64ToData:(NSData*)input {
    NSData *result = [input base64EncodedDataWithOptions:0];
    NSLog(@"return : %@", result);
    return result;
}

// NSData -> NSString
+(NSString *)encodeB64ToString:(NSData *)input {
//    NSData *result = [[NSData alloc] initWithBase64EncodedString:input options:0];
    NSString *result = [input base64EncodedStringWithOptions:0];
    NSLog(@"return : %@", result);
    return result;
}

// NSString -> NSData
+(NSData*)encodeB64StringToData:(NSString*)input {
    // encode nsstring -> nsdata
    NSData *dataResult = [[NSData alloc] initWithBase64EncodedString:input options:0];
    if (dataResult == nil) {
        // base64 디코딩 실패
        // 오류코드&메시지 추가
        NSLog(@"return : nil#");
        return nil;
    }
    return dataResult;
}

// NSData -> NSString
+(NSString*)decodeB64ToString:(NSData*)input {
    // http://iosdevelopertips.com/core-services/encode-decode-using-base64.html
//    NSString *strResult = [input base64EncodedStringWithOptions:0];
    
    // Decoded NSString from the NSData
    // decode nsdata -> nsstring
    NSString *strResult = [[NSString alloc] initWithData:input encoding:NSUTF8StringEncoding];
    
    if (strResult == nil || [strResult isEqualToString:@""]) {
        // base64 디코딩 실패
        // 오류코드&메시지 추가
        NSLog(@"return : nil#");
        return nil;
    }
    return strResult;
}

// NSString -> NSString
+(NSString*)encodeB64StringToString:(NSString*)imput {
    NSData *plainData = [imput dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64String = [plainData base64Encoding];                              // pre iOS7
    }
    
    return base64String;
}


+(NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {  value |= (0xFF & input[j]);  }  }  NSInteger theIndex = (i / 3) * 4;  output[theIndex + 0] = table[(value >> 18) & 0x3F];
        output[theIndex + 1] = table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6) & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0) & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
}


#pragma mark - UTF8 ENCODE / DECODE

// NSString -> NSData
+(NSData*)encodeUTF8:(NSString*)input {
    NSData *dataResult = [input dataUsingEncoding:NSUTF8StringEncoding];
    if (dataResult == nil) {
        NSLog(@"return : nil#");
        return nil;
    }
    return dataResult;
}

// NSData -> NSString
+(NSString*)decodeUTF8:(NSData*)input {
    NSString *strResult = [[NSString alloc] initWithData:input encoding:NSUTF8StringEncoding];
    if (strResult == nil || [strResult isEqualToString:@""]) {
        // base64 디코딩 실패
        // 오류코드&메시지 추가
        NSLog(@"return : nil#");
        return nil;
    }
    
    return strResult;
}


#pragma mark - SR

+(NSString*)generateSR:(int)length {
    
    uint8_t buffer[length];
    
    int nResult = SecRandomCopyBytes(kSecRandomDefault, length, buffer);
    
    NSData *dataResult = nil;
    NSMutableString *hex = nil;
    
    if (nResult == 0) {
        // 생성 성공
        
        // buffer -> NSString 으로 변환
        // hex (제대로 된 값 나옴)
        hex = [[NSMutableString alloc] initWithCapacity:length];
        for (NSInteger index = 0; index < length; index++) {
            [hex appendFormat: @"%02x", buffer[index]];
        }
        
    } else {
        // 생성 실패
        
        NSLog(@"return : nil#");
        return nil;
    }
    
    NSLog(@"return : %@#", hex);
    return hex;
}
@end
