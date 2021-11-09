//
//  EncRSA.h
//  Framework_Core
//
//  Created by Authlabs on 2020/07/28.
//  Copyright © 2020 Authlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *keyTagPub = @"com.es1015.encrypt.pubkey";
static NSString *keyTagPri = @"com.es1015.encrypt.prikey";
    

typedef void (^RSACompletionBlock2)(void);

/// RSA 암호화 클래스. EncMgr클래스를 통해 호출한다
/// 현재 개인키로 암호화, 공개키로 복호화는 기능 작동이 안된다
@interface EncRSA : NSObject


-(instancetype)init;

#pragma mark - 암호화

/// 공개키로 암호화 (사용 가능)
/// 공개키로 암호화 시, 개인키로 복호화 진행
/// @param publicKey 공개키
/// @param plainText 암호화할 값
/// @return 암호화된 값
+(NSData*)encryptByPublicKey:(SecKeyRef)publicKey plainText:(NSData*)plainText;

/// 개인키로 암호화 (사용 불가)
/// 개인키로 암호화 시, 공개키로 복호화 진행
/// @param privateKey 개인키
/// @param plainText 암호화할 값
/// @return 암호화된 값
+(NSData*)encryptByPrivateKey:(SecKeyRef)privateKey plainText:(NSData*)plainText;


#pragma mark - 복호화

/// 공개키로 복호화 (사용 불가)
/// 개인키로 암호화된 값 복호화 시 사용
/// @param publicKey 공개키
/// @param encText 암호화된 값
/// @return 복호화된 값
+(NSData*)decryptByPublicKey:(SecKeyRef)publicKey encText:(NSData*)encText;

/// 개인키로 복호화 (사용 가능)
/// 공개키로 암호화된 값 복호화 시 사용
/// @param privateKey 개인키
/// @param encText 암호화된 값
/// @return 복호화된 값
+(NSData*)decryptByPrivateKey:(SecKeyRef)privateKey encText:(NSData*)encText;


#pragma mark - 키 객체 가져오기

/// 공개키 객체 가져오기
/// @return 공개키
+(SecKeyRef)getPublicKeyRef;

/// 개인키 객체 가져오기
/// @return 개인키
+(SecKeyRef)getPrivateKeyRef;


#pragma mark - 키쌍 생성

/// 기존에 사용하던 동기식 함수
-(void)generateRSAKeyPair:(void (^)(void))completion;

/// 동기식. 추가한 함수. 결과 리턴
/// 200728 설명 추가. AuthTL_Core 에서 사용하고 있는 함수.
/// @return 생성 결과
+(BOOL)generateRSAKeyPairSync;


#pragma mark - 키쌍 삭제

/// 키 쌍 삭제
+(void)deleteKeyPairRSA;


#pragma mark - 키쌍 존재 여부 확인

/// 키쌍 존재 여부 확인
+(BOOL)isKeyPairExist;


#pragma mark - 키 태그 관리

/// 공개키 태그 조회
/// @return 공개키 태그
+(NSString*)getKeyAllTagPub;

/// 개인키 태그 조회
/// @return 개인키 태그
+(NSString*)getKeyAllTagPri;

/// 공개키 태그 설정
/// @param tag 설정할 공개키 태그
+(void)setKeyTagPub:(NSString *)tag;

/// 개인키 태그 설정
/// @param tag 설정할 공개키 태그
+(void)setKeyTagPri:(NSString *)tag;

/// 키 태그 마지막 글자 조회(?)
+(NSString*)getKeyTagLastString;



@end

NS_ASSUME_NONNULL_END
