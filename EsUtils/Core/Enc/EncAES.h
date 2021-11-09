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
@interface EncAES : NSObject

#pragma mark - enc

+(NSString*)encryptString:(NSString*)keys iv:(char*)iv plainText:(NSString*)plainText keySize:(int)keySize;

/// AES 암호화
/// @param keys 키
/// @param iv 이미지 벡터
/// @param plainText 암호화할 값
/// @param keySize 키 사이즈 (128, 256, ...)
/// @return 암호화된 값
+(NSData*)encrypt:(NSString*)keys iv:(char*)iv plainText:(NSData*)plainText keySize:(int)keySize;


#pragma mark - dec

+(NSString*)decryptString:(NSString*)keys iv:(char*)iv encText:(NSString*)encText keySize:(int)keySize;

/// AES 복호화
/// @param keys 키
/// @param iv 이미지 벡터
/// @param encText 복호화할 값
/// @param keySize 키 사이즈 (128, 256, ...)
/// @return 복호화된 값
+(NSData*)decrypt:(NSString*)keys iv:(char*)iv encText:(NSData*)encText keySize:(int)keySize;

@end

NS_ASSUME_NONNULL_END
