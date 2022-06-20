//
//  EncAES.m
//  Framework_Core
//
//  Created by ParkEunSu on 2020/07/28.
//  Copyright © 2020 ParkEunSu. All rights reserved.
//

#import "EncAES.h"
#import "EncUtil.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation EncAES

#pragma mark - enc

/// AES 암호화
+(NSString*)encryptString:plainText key:(NSString*)key iv:(char*)iv  keySize:(int)keySize {
    NSData *plainData = [EncUtil encodeUTF8:plainText];
    NSData *result = [self encrypt:plainData keys:key iv:iv keySize:keySize];
    return [EncUtil encodeB64ToString:result];
}

/// AES 암호화
+(NSData*)encrypt:(NSData*)plainText keys:(NSString*)key iv:(char*)iv keySize:(int)keySize {
    if (key == nil) {
        [ErrorMgr.sharedInstance setErrCode:ERROR_NULL_KEY];
        return nil;
    }
    
    if (plainText == nil) {
        [ErrorMgr.sharedInstance setErrCode:ERROR_NULL_PARAM];
        return nil;
    }
    
    char keyPtr[keySize+1];
    bzero( keyPtr, sizeof(keyPtr) );
    
    // NSString keys -> NSData keys (원래는 keys를 NSString로 받아서 했던 과정인데 NSData로 받아서 주석처리)
    [key getCString: keyPtr maxLength: sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    size_t numBytesEncrypted = 0x00;
    
    // NSString plainText -> NSData valueData (원래는 plainText를 NSString로 받아서 했던 과정인데 NSData로 받아서 주석처리)
    //    NSData *valueData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    // temp add
    NSData *valueData = plainText;
    
    NSUInteger dataLength = [valueData length];
    //    size_t     bufferSize = dataLength + kCCBlockSizeAES128;  // keySize로 변경
    size_t     bufferSize = dataLength + keySize;
    void      *buffer     = malloc(bufferSize);
    //    const unsigned char iv[] = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
    
    CCCryptorStatus result = CCCrypt( kCCEncrypt,
                                     //                                     kCCAlgorithmAES128,  // keySize로 변경
                                     keySize,
                                     kCCOptionPKCS7Padding,
                                     keyPtr,
                                     keySize,
                                     iv,
                                     [valueData bytes], [valueData length],
                                     buffer, bufferSize,
                                     &numBytesEncrypted );
    
    if (result == kCCSuccess)
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    else
        free(buffer);
    return nil;
}


#pragma mark - dec

+(NSString*)decryptString:(NSString*)encText keys:(NSString*)key iv:(char*)iv  keySize:(int)keySize {
    NSData *encData = [EncUtil encodeB64StringToData:encText];
    NSData *result = [self decrypt:encData key:key iv:iv keySize:keySize];
    return [EncUtil decodeUTF8:result];
}

+(NSData*)decrypt:(NSData*)encText key:(NSString*)key iv:(char*)iv keySize:(int)keySize {
    if (key == nil) {
        [ErrorMgr.sharedInstance setErrCode:ERROR_NULL_KEY];
        return nil;
    }
    
    if (encText == nil) {
        [ErrorMgr.sharedInstance setErrCode:ERROR_NULL_PARAM];
        return nil;
    }
    
    char  keyPtr[keySize + 0x01];
    bzero( keyPtr, sizeof(keyPtr) );
    
    // NSString keys -> NSData keys (원래는 keys를 NSString로 받아서 했던 과정인데 NSData로 받아서 주석처리)
    //    // fetch key data
    [key getCString: keyPtr maxLength: sizeof(keyPtr) encoding: NSUTF8StringEncoding];
    
    // NSString encText -> NSData valueData (원래는 encText를 NSString로 받아서 했던 과정인데 NSData로 받아서 주석처리)
    //    NSData *valueData = [[NSData alloc] initWithBase64EncodedString:encText options:0];
    
    // temp add
    NSData *valueData = encText;
    
    NSUInteger dataLength     = [valueData length];
    //    size_t     bufferSize     = dataLength + kCCBlockSizeAES128;  // keySize로 변경
    size_t     bufferSize     = dataLength + keySize;
    void      *buffer_decrypt = malloc(bufferSize);
    //    const unsigned char iv[] = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
    
    size_t numBytesDecrypted    = 0x00;
    CCCryptorStatus result = CCCrypt( kCCDecrypt,
                                     //                                     kCCAlgorithmAES128,  // keySize로 변경
                                     keySize,
                                     kCCOptionPKCS7Padding,
                                     keyPtr,
                                     keySize,
                                     iv,
                                     [valueData bytes], [valueData length],
                                     buffer_decrypt, bufferSize,
                                     &numBytesDecrypted );
    
    if (result == kCCSuccess)
        return [NSData dataWithBytesNoCopy:buffer_decrypt length:numBytesDecrypted];
    else
        return nil;
}

@end
