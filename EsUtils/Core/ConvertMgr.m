//
//  ConvertMgr.m
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import "ConvertMgr.h"

@implementation ConvertMgr

#pragma mark - 형변환

/// String -> Hex로 변환
+(NSString*)stringToHex:(nonnull NSString *)string {
    NSMutableString *hexString = [[NSMutableString alloc] init];
    @try {
        // String -> Hex String (정상적인 hex가 맞는지 확인 필요)
        NSUInteger len = [string length];
        unichar *chars = malloc(len * sizeof(unichar));
        [string getCharacters:chars];
        
        for(NSUInteger i = 0; i < len; i++ ) {
            [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
        }
        free(chars);
        
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        hexString = nil;
        
    }
    return hexString;
}

/// Data -> String
+(NSString*)stringToUTF8Data:(nonnull NSData *)data {
    @try {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}

/// String -> Data
+(NSData*)utf8DataToString:(nonnull NSString *) string {
    @try {
        return [string dataUsingEncoding:NSUTF8StringEncoding];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}


#pragma mark - Base64

/// Base64 인코딩
+(NSString*)encodeBase64:(nonnull NSString*)plainString {
    NSString *base64String = nil;
    @try {
        NSData *plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
        base64String = [plainData base64EncodedStringWithOptions:0];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        base64String = nil;
    }
    return base64String;
}

/// Base64 디코딩
+(NSString*)decodeBase64:(nonnull NSString*)base64String {
    @try {
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
        return [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        return nil;
    }
}

// TODO: 확인 필요
/// Base64 디코딩
+ (NSString*)base64forData:(NSData*)theData {
    @try {
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
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}

@end
