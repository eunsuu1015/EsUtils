//
//  EncAES.h
//  Framework_Core
//
//  Created by Authlabs on 2020/07/28.
//  Copyright © 2020 Authlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// AES 암호화 클래스. EncMgr클래스를 통해 호출한다
// TODO: 확인 필요
@interface EncAES : NSObject

#pragma mark - enc

/// AES 암호화
+(NSString*)encryptString:plainText key:(NSString*)key iv:(char*)iv  keySize:(int)keySize;

/// AES 암호화
/// @param key 키
/// @param iv 이미지 벡터
/// @param plainText 암호화할 값
/// @param keySize 키 사이즈 (128, 256, ...)
/// @return 암호화된 값
+(NSData*)encrypt:(NSData*)plainText keys:(NSString*)key iv:(char*)iv keySize:(int)keySize;


#pragma mark - dec

/// AES 복호화
+(NSString*)decryptString:(NSString*)encText keys:(NSString*)key iv:(char*)iv  keySize:(int)keySize;

/// AES 복호화
/// @param key 키
/// @param iv 이미지 벡터
/// @param encText 복호화할 값
/// @param keySize 키 사이즈 (128, 256, ...)
/// @return 복호화된 값
+(NSData*)decrypt:(NSData*)encText key:(NSString*)key iv:(char*)iv keySize:(int)keySize;

@end

NS_ASSUME_NONNULL_END
