//
//  EncAES.m
//  Framework_Core
//
//  Created by Authlabs on 2020/07/28.
//  Copyright © 2020 Authlabs. All rights reserved.
//

#import "EncAES.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation EncAES

#pragma mark - AES 암호화 최종 호출 함수

+(NSData*)encrypt:(NSString*)keys iv:(char*)iv plainText:(NSData*)plainText keySize:(int)keySize {
    
    if (keys == nil) {
        // KSLOG_ERROR(@"키 없음");
        return nil;
    }
        
    if (plainText == nil) {
        // KSLOG_ERROR(@"값 없음");
        return nil;
    }
    
    char keyPtr[keySize+1];
    bzero( keyPtr, sizeof(keyPtr) );
    
    // NSString keys -> NSData keys (원래는 keys를 NSString로 받아서 했던 과정인데 NSData로 받아서 주석처리)
    [keys getCString: keyPtr maxLength: sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    size_t numBytesEncrypted = 0x00;
    
    // NSString plainText -> NSData valueData (원래는 plainText를 NSString로 받아서 했던 과정인데 NSData로 받아서 주석처리)
    //    NSData *valueData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    // temp add
    NSData *valueData = plainText;
    
    NSUInteger dataLength = [valueData length];
//    size_t     bufferSize = dataLength + kCCBlockSizeAES128;  // 200727 keySize로 변경
    size_t     bufferSize = dataLength + keySize;
    void      *buffer     = malloc(bufferSize);
    //    const unsigned char iv[] = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
    
    CCCryptorStatus result = CCCrypt( kCCEncrypt,
//                                     kCCAlgorithmAES128,  // 200727 keySize로 변경
                                     keySize,
                                     kCCOptionPKCS7Padding,
                                     keyPtr,
                                     keySize,
                                     iv,
                                     [valueData bytes], [valueData length],
                                     buffer, bufferSize,
                                     &numBytesEncrypted );
    
    if( result == kCCSuccess )
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    else
        // KSLOG_DEBUG(@"암호화 실패");
        
        free(buffer);
    return nil;
}

+(NSData*)decrypt:(NSString*)keys iv:(char*)iv encText:(NSData*)encText keySize:(int)keySize {
    
    if (keys == nil) {
        // KSLOG_ERROR(@"키 없음");
        return nil;
    }
        
    if (encText == nil) {
        // KSLOG_ERROR(@"값 없음");
        return nil;
    }
    
    char  keyPtr[keySize + 0x01];
    bzero( keyPtr, sizeof(keyPtr) );
    
    // NSString keys -> NSData keys (원래는 keys를 NSString로 받아서 했던 과정인데 NSData로 받아서 주석처리)
    //    // fetch key data
    [keys getCString: keyPtr maxLength: sizeof(keyPtr) encoding: NSUTF8StringEncoding];
    
    // NSString encText -> NSData valueData (원래는 encText를 NSString로 받아서 했던 과정인데 NSData로 받아서 주석처리)
    //    NSData *valueData = [[NSData alloc] initWithBase64EncodedString:encText options:0];
    
    // temp add
    NSData *valueData = encText;
    
    NSUInteger dataLength     = [valueData length];
//    size_t     bufferSize     = dataLength + kCCBlockSizeAES128;  // 200727 keySize로 변경
    size_t     bufferSize     = dataLength + keySize;
    void      *buffer_decrypt = malloc(bufferSize);
    //    const unsigned char iv[] = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
    
    size_t numBytesDecrypted    = 0x00;
    CCCryptorStatus result = CCCrypt( kCCDecrypt,
//                                     kCCAlgorithmAES128,  // 200727 keySize로 변경
                                     keySize,
                                     kCCOptionPKCS7Padding,
                                     keyPtr,
                                     keySize,
                                     iv,
                                     [valueData bytes], [valueData length],
                                     buffer_decrypt, bufferSize,
                                     &numBytesDecrypted );
    
    if( result == kCCSuccess )
        return [NSData dataWithBytesNoCopy:buffer_decrypt length:numBytesDecrypted];
    else
//       // KSLOG_DEBUG(@"복호화 실패");
        
        return nil;
}

@end