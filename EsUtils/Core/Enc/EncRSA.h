//
//  EncRSA.h
//  Framework_Core
//
//  Created by ParkEunSu on 2020/07/28.
//  Copyright © 2020 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *keyTagPub = @"com.es1015.encrypt.pubkey";
static NSString *keyTagPri = @"com.es1015.encrypt.prikey";


/// RSA 암호화 클래스. EncMgr클래스를 통해 호출한다
// TODO: 전체 테스트 필요. 개인키로 암호화, 공개키로 복호화는 아예 기능 작동 안됨
@interface EncRSA : NSObject


#pragma mark - 암호화

/// 공개키로 암호화
/// @param plainText 평문 텍스트
/// @param publicKey 공개키
+(NSString*)enryptString:(NSString*)plainText byPublicKey:(SecKeyRef)publicKey;

/// 공개키로 암호화
/// @param plainText 평문 데이터
/// @param publicKey 공개키
+(NSData*)encrypt:(NSData*)plainText byPublicKey:(SecKeyRef)publicKey;

// TODO: 작동 안됨
/// 개인키 암호화 (사용 불가)
/// @param plainText 평문 데이터
/// @param privateKey 개인키
+(NSData*)encrypt:(NSData*)plainText byPrivateKey:(SecKeyRef)privateKey;


#pragma mark - 복호화

// TODO: 작동 안됨
/// 공개키로 복호화 (사용 불가)
/// @param encText 암호화된 데이터
/// @param publicKey 공개키
+(NSData*)decrypt:(NSData*)encText byPublicKey:(SecKeyRef)publicKey;

/// 개인키로 복호화
/// @param encText 암호화된 텍스트
/// @param privateKey 개인키
+(NSString*)decryptString:(NSString*)encText byPrivateKey:(SecKeyRef)privateKey;

/// 개인키로 복호화
/// @param encText 암호화된 데이터
/// @param privateKey 개인키
+(NSData*)decrypt:(NSData*)encText byPrivateKey:(SecKeyRef)privateKey;


#pragma mark - 키 관리
#pragma mark 키 객체 가져오기

/// 공개키 가져오기
+(SecKeyRef)getPublicKeyRef;

/// 개인키 가져오기
+(SecKeyRef)getPrivateKeyRef ;

#pragma mark 키쌍 생성

// 비동기식 키쌍 생성
+(BOOL)generateRSAKeyPairSync;

#pragma mark 키쌍 삭제

/// 키 쌍 삭제
+(void)deleteKeyPairRSA;


#pragma mark 키쌍 존재 여부 확인

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

@end

NS_ASSUME_NONNULL_END
