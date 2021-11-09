//
//  EncRSA.m
//  Framework_Core
//
//  Created by Authlabs on 2020/07/28.
//  Copyright © 2020 Authlabs. All rights reserved.
//

#import "EncRSA.h"
#import <CommonCrypto/CommonCryptor.h>

#if DEBUG
#define LOGGING_FACILITY(X, Y)    \
NSAssert(X, Y);

#define LOGGING_FACILITY1(X, Y, Z)    \
NSAssert1(X, Y, Z);
#else
#define LOGGING_FACILITY(X, Y)    \
if (!(X)) {            \
// KSLOG_DEBUG(Y);        \
}

#define LOGGING_FACILITY1(X, Y, Z)    \
if (!(X)) {                \
// KSLOG_DEBUG(Y, Z);        \
}
#endif

@interface EncRSA () {
@private
    NSOperationQueue * cryptoQueue;
    RSACompletionBlock2 _completion;
    size_t kSecAttrKeySizeInBitsLength;
}
@end

@implementation EncRSA


-(instancetype)init {
    if (self = [super init]) {
        cryptoQueue = [[NSOperationQueue alloc] init];
        kSecAttrKeySizeInBitsLength = 2048;
    }
    return self;
}


#pragma mark - 암호화

// 공개키로 암호화
+(NSData*)encryptByPublicKey:(SecKeyRef)publicKey plainText:(NSData*)plainText {
    SecKeyRef key = publicKey;
    
    // 에러 체크, 추가
    if (key == nil) {
        [ErrorMgr.sharedInstance setErrCode:ERROR_NULL_KEY];
        return nil;
    }
    
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = plainText;
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [NSMutableData dataWithCapacity:0];
    
    for (int i=0; i<blockCount; i++) {
        
        int bufferSize = (int)MIN(blockSize,[plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        
        OSStatus status = SecKeyEncrypt(key,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        
        if (status == noErr){
            NSData *encryptedBytes = [NSData dataWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
            
        } else {
            
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer) free(cipherBuffer);
    
    //    return [encryptedData base64EncodedStringWithOptions:0];
    return encryptedData;
}


// 전에 테스트했을 때 정상 작동 안했음
+(NSData*)encryptByPrivateKey:(SecKeyRef)privateKey plainText:(NSData*)plainText {
    SecKeyRef key = privateKey;
    
    // 에러 체크, 추가
    if (key == nil) {
        [ErrorMgr.sharedInstance setErrCode:ERROR_NULL_KEY];
        return nil;
    }
    
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = plainText;
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [NSMutableData dataWithCapacity:0];
    
    for (int i=0; i<blockCount; i++) {
        
        int bufferSize = (int)MIN(blockSize,[plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        
        OSStatus status = SecKeyEncrypt(key,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        
        if (status == noErr){
            NSData *encryptedBytes = [NSData dataWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
            
        } else {
            
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer) free(cipherBuffer);
    
    //    return [encryptedData base64EncodedStringWithOptions:0];
    return encryptedData;
}


#pragma mark - 복호화


// 전에 테스트했을 때 정상 작동 안했음
+(NSData*)decryptByPublicKey:(SecKeyRef)publicKey encText:(NSData*)encText {
    NSData *wrappedSymmetricKey = encText;
    
    if (wrappedSymmetricKey == nil) {
        // KSLOG_DEBUG(@"wrappedSymmetricKey nil");
        return nil;
    }
    
    // usingPublicKey 값에 따라 공개키 다는 개인키를 세팅한다
    SecKeyRef key = publicKey;
    
    // 에러 체크, 추가
    if (key == nil) {
        [ErrorMgr.sharedInstance setErrCode:ERROR_NULL_KEY];
        return nil;
    }
    
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    size_t keyBufferSize = [wrappedSymmetricKey length];
    
    NSMutableData *bits = [NSMutableData dataWithLength:keyBufferSize];
    OSStatus sanityCheck = SecKeyDecrypt(key,
                                         kSecPaddingPKCS1,
                                         (const uint8_t *) [wrappedSymmetricKey bytes],
                                         cipherBufferSize,
                                         [bits mutableBytes],
                                         &keyBufferSize);
    
    if (sanityCheck != 0) {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:sanityCheck userInfo:nil];
        // KSLOG_DEBUG(@"Error: %@", [error description]);
        return nil;
    }
    
    NSAssert(sanityCheck == noErr, @"Error decrypting, OSStatus == %ld.", (long)sanityCheck);
    
    
    [bits setLength:keyBufferSize];
    
    //    return [[NSString alloc] initWithData:bits encoding:NSUTF8StringEncoding];
    return bits;
}

// 개인키로 복호화
+(NSData*)decryptByPrivateKey:(SecKeyRef)privateKey encText:(NSData*)encText {
    NSData *wrappedSymmetricKey = encText;
    
    if (wrappedSymmetricKey == nil) {
        // KSLOG_DEBUG(@"%s wrappedSymmetricKey nil", __FUNCTION__);
        return nil;
    }
    
    // usingPublicKey 값에 따라 공개키 다는 개인키를 세팅한다
    SecKeyRef key = privateKey;
    
    // 에러 체크, 추가
    if (key == nil) {
        [ErrorMgr.sharedInstance setErrCode:ERROR_NULL_KEY];
        return nil;
    }
    
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    size_t keyBufferSize = [wrappedSymmetricKey length];
    
    NSMutableData *bits = [NSMutableData dataWithLength:keyBufferSize];
    OSStatus sanityCheck = SecKeyDecrypt(key,
                                         kSecPaddingPKCS1,
                                         (const uint8_t *) [wrappedSymmetricKey bytes],
                                         cipherBufferSize,
                                         [bits mutableBytes],
                                         &keyBufferSize);
    
    if (sanityCheck != 0) {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:sanityCheck userInfo:nil];
        // KSLOG_DEBUG(@"Error: %@", [error description]);
        return nil;
    }
    
    NSAssert(sanityCheck == noErr, @"Error decrypting, OSStatus == %ld.", (long)sanityCheck);
    
    
    [bits setLength:keyBufferSize];
    
    //    return [[NSString alloc] initWithData:bits encoding:NSUTF8StringEncoding];
    return bits;
}


#pragma mark - 키 객체 가져오기

+(SecKeyRef)getPublicKeyRef {
    
    OSStatus resultCode = noErr;
    SecKeyRef publicKeyRef = nil;
    
    NSMutableDictionary * queryPublicKey = [NSMutableDictionary dictionaryWithCapacity:0];
    // Set the public key query dictionary.
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:keyTagPub forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    // Get the key.
    resultCode = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKeyRef);
    
    if(resultCode != noErr) {
        // KSLOG_DEBUG(@"%s Error", __FUNCTION__);
        return nil;
    }
    
    queryPublicKey = nil;
    return publicKeyRef;
}

+(SecKeyRef)getPrivateKeyRef {
    
    OSStatus resultCode = noErr;
    SecKeyRef privateKeyRef = nil;
    
    NSMutableDictionary * queryPrivateKey = [NSMutableDictionary dictionaryWithCapacity:0];
    // Set the public key query dictionary.
    [queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPrivateKey setObject:keyTagPri forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryPrivateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    // Get the key.
    resultCode = SecItemCopyMatching((__bridge CFDictionaryRef)queryPrivateKey, (CFTypeRef *)&privateKeyRef);
    
    if(resultCode != noErr) {
        // KSLOG_DEBUG(@"%s Error", __FUNCTION__);
        return nil;
    }
    
    queryPrivateKey = nil;
    return privateKeyRef;
}


#pragma mark - 키쌍 생성

// 비동기식. 추가한 함수. 결과 리턴
// 200728 설명 추가. AuthTL_Core 에서 사용하고 있는 함수.
+ (BOOL)generateRSAKeyPairSync {
    OSStatus sanityCheck = noErr;
    SecKeyRef publicKeyRef = NULL;
    SecKeyRef privateKeyRef = NULL;
    
    int secAttrKeySizeInBitsLength = 2048;
    
    // First delete current keys.
    [EncRSA deleteKeyPairRSA];
    
    // Container dictionaries.
    NSMutableDictionary * privateKeyAttr = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary * publicKeyAttr = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary * keyPairAttr = [NSMutableDictionary dictionaryWithCapacity:0];
    
    // Set top level dictionary for the keypair.
    // 키 쌍에 대한 최상위 사전을 설정하십시오.
    [keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyPairAttr setObject:[NSNumber numberWithUnsignedInteger:secAttrKeySizeInBitsLength] forKey:(__bridge id)kSecAttrKeySizeInBits]; // keySizeInBitsLength = 2048
    
    // Set the private key dictionary.
    // 개인 키 사전을 설정하십시오.
    [privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [privateKeyAttr setObject:keyTagPri forKey:(__bridge id)kSecAttrApplicationTag];
    // See SecKey.h to set other flag values.
    
    // Set the public key dictionary.
    // 공개 키 사전을 설정하십시오.
    [publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [publicKeyAttr setObject:keyTagPub forKey:(__bridge id)kSecAttrApplicationTag];
    // See SecKey.h to set other flag values.
    
    // Set attributes to top level dictionary.
    // 속성을 최상위 사전으로 설정하십시오.
    [keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
    [keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];
    
    // SecKeyGeneratePair returns the SecKeyRefs just for educational purposes.
    // SecKeyGeneratePair는 교육 목적으로 만 SecKeyRef를 반환합니다.
    sanityCheck = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKeyRef, &privateKeyRef);
    // 키쌍 생성 여부 확인, 추가
    if (publicKeyRef == nil || privateKeyRef == nil) {
        //        AuthManager *lm = [AuthManager getInstance];
        //                [lm setErrorCode:LM_FAIL_GEN_RSA_KEY];
        //                [lm setErrorText:LM_FAIL_GEN_RSA_KEY_TXT];
        //                // KSLOG_DEBUG(@"%s errorCode : %d / errorText : %@", __FUNCTION__, [lm getErrorCode], [lm getErrorText]);
        // KSLOG_DEBUG(@"%s 키 생성 실패", __FUNCTION__);
        return NO;
    }
    
    LOGGING_FACILITY( sanityCheck == noErr && publicKeyRef != NULL && privateKeyRef != NULL, @"Something went wrong with generating the key pair." );
    return YES;
}


// 기존에 사용하던 동기식 함수
- (void)generateRSAKeyPairTest:(void (^)(BOOL isSuccess))success {
    // KSLOG_DEBUG(@"%s start", __FUNCTION__);
    NSInvocationOperation * genOp = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(generateKeyPairOperation) object:nil];
    [cryptoQueue addOperation:genOp];
    _completion = completion;
    success
}

// 기존에 사용하던 동기식 함수
- (void)generateRSAKeyPair:(RSACompletionBlock2)completion {
    // KSLOG_DEBUG(@"%s start", __FUNCTION__);
    NSInvocationOperation * genOp = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(generateKeyPairOperation) object:nil];
    [cryptoQueue addOperation:genOp];
    _completion = completion;
}

- (void)generateKeyPairOperation{
    @autoreleasepool {
        // Generate the asymmetric key (public and private)
        [self generateKeyPairRSA];
        [self performSelectorOnMainThread:@selector(generateKeyPairCompleted) withObject:nil waitUntilDone:NO];
    }
}

/**
 * RSA 키쌍 생성 완료
 
 */
- (void)generateKeyPairCompleted{
    if (_completion) {
        _completion();
    }
}

// 기존 동기식으로 진행하는 함수
- (void)generateKeyPairRSA {
    // KSLOG_DEBUG(@"%s start", __FUNCTION__);
    OSStatus sanityCheck = noErr;
    SecKeyRef publicKeyRef = NULL;
    SecKeyRef privateKeyRef = NULL;
    
    int secAttrKeySizeInBitsLength = 2048;
    
    // First delete current keys.
    [EncRSA deleteKeyPairRSA];
    
    // Container dictionaries.
    NSMutableDictionary * privateKeyAttr = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary * publicKeyAttr = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary * keyPairAttr = [NSMutableDictionary dictionaryWithCapacity:0];
    
    // Set top level dictionary for the keypair.
    [keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyPairAttr setObject:[NSNumber numberWithUnsignedInteger:secAttrKeySizeInBitsLength] forKey:(__bridge id)kSecAttrKeySizeInBits];
    
    // Set the private key dictionary.
    [privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [privateKeyAttr setObject:keyTagPri forKey:(__bridge id)kSecAttrApplicationTag];
    // See SecKey.h to set other flag values.
    
    // Set the public key dictionary.
    [publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [publicKeyAttr setObject:keyTagPub forKey:(__bridge id)kSecAttrApplicationTag];
    // See SecKey.h to set other flag values.
    
    // Set attributes to top level dictionary.
    [keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
    [keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];
    
    // SecKeyGeneratePair returns the SecKeyRefs just for educational purposes.
    //    sanityCheck = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKeyRef, &privateKeyRef);
    sanityCheck = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKeyRef, &privateKeyRef);
    
    // 키쌍 생성 여부 확인, 추가
    //    if (publicKeyRef == nil || privateKeyRef == nil) {
    if (publicKeyRef == nil || privateKeyRef == nil) {
        // KSLOG_DEBUG(@"%s RSA 키쌍 생성 실패. nil", __FUNCTION__);
        //        AuthManager *lm = [AuthManager getInstance];
        //        [lm setErrorCode:LM_FAIL_GEN_RSA_KEY];
        //        [lm setErrorText:LM_FAIL_GEN_RSA_KEY_TXT];
        //        // KSLOG_DEBUG(@"%s errorCode : %d / errorText : %@", __FUNCTION__, [lm getErrorCode], [lm getErrorText]);
    }
    
    LOGGING_FACILITY( sanityCheck == noErr && publicKeyRef != NULL && privateKeyRef != NULL, @"Something went wrong with generating the key pair." );
    // KSLOG_DEBUG(@"%s end", __FUNCTION__);
}


#pragma mark - 키상 삭제

+ (void)deleteKeyPairRSA {
    // KSLOG_DEBUG(@"%s start",__FUNCTION__);
    // KSLOG_DEBUG(@"%s tag key pub : %@", __FUNCTION__, keyTagPub);
    // KSLOG_DEBUG(@"%s tag key pri : %@", __FUNCTION__, keyTagPri);
    OSStatus sanityCheck = noErr;
    NSMutableDictionary * queryPublicKey        = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary * queryPrivateKey       = [NSMutableDictionary dictionaryWithCapacity:0];
    
    // Set the public key query dictionary.
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPublicKey setObject:keyTagPub forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Set the private key query dictionary.
    [queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPrivateKey setObject:keyTagPri forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // private key 삭제
    sanityCheck = SecItemDelete((__bridge CFDictionaryRef)queryPrivateKey);
    LOGGING_FACILITY1( sanityCheck == noErr || sanityCheck == errSecItemNotFound, @"Error removing private key, OSStatus == %ld.", (long)sanityCheck );
    if (sanityCheck != 0) {
        // KSLOG_DEBUG(@"%s fail private key delete. OSStatus : %ld", __FUNCTION__, (long)sanityCheck);
        // 에러 체크, 추가
        //        AuthManager *lm = [AuthManager getInstance];
        //                [lm setErrorCode:LM_FAIL_DEL_RSA_KEY];
        //                [lm setErrorText:LM_FAIL_DEL_RSA_KEY_TXT];
        //                // KSLOG_DEBUG(@"%s errorCode : %d / errorText : %@", __FUNCTION__, [lm getErrorCode], [lm getErrorText]);
        return;
    }
    
    // public key 삭제
    sanityCheck = SecItemDelete((__bridge CFDictionaryRef)queryPublicKey);
    LOGGING_FACILITY1( sanityCheck == noErr || sanityCheck == errSecItemNotFound, @"Error removing public key, OSStatus == %ld.", (long)sanityCheck );
    if (sanityCheck != 0) {
        // KSLOG_DEBUG(@"%s fail public key delete. OSStatus : %ld", __FUNCTION__, (long)sanityCheck);
        // 에러 체크, 추가
        //        AuthManager *lm = [AuthManager getInstance];
        //                [lm setErrorCode:LM_FAIL_DEL_RSA_KEY];
        //                [lm setErrorText:LM_FAIL_DEL_RSA_KEY_TXT];
        //                // KSLOG_DEBUG(@"%s errorCode : %d / errorText : %@", __FUNCTION__, [lm getErrorCode], [lm getErrorText]);
        return;
    }
    
    //    if (publicKeyRef) CFRelease(publicKeyRef);
    //    if (privateKeyRef) CFRelease(privateKeyRef);
    // KSLOG_DEBUG(@"%s end",__FUNCTION__);
}


#pragma mark - 키쌍 존재 여부 확인

/**
 * 키체인에 키쌍이 존재하는지 확인, 추가
 * @return  키쌍 존재 여부
 */
+(BOOL) isKeyPairExist {
    SecKeyRef privateKeyRef;
    SecKeyRef publicKeyRef;
    
    privateKeyRef = [EncRSA getPrivateKeyRef];
    publicKeyRef = [EncRSA getPublicKeyRef];
    
    if (publicKeyRef != nil && privateKeyRef != nil) {
        // KSLOG_DEBUG(@"%s return : Y #", __FUNCTION__);
        return YES;
    } else {
        // 키쌍 없는 경우
        //        AuthManager *lm = [AuthManager getInstance];
        //        [lm setErrorCode:LM_NO_REG_RSA_KEY];
        //        [lm setErrorText:LM_NO_REG_RSA_KEY_TXT];
        //        // KSLOG_DEBUG(@"%s errorCode : %d / errorText : %@", __FUNCTION__, [lm getErrorCode], [lm getErrorText]);
        // KSLOG_DEBUG(@"%s return : N #", __FUNCTION__);
        return NO;
    }
}


#pragma mark - 키 태그 가져오기

+(NSString*)getKeyAllTagPub {
    return keyTagPub;
}

+(NSString*)getKeyAllTagPri {
    return keyTagPri;
}

+(void)setKeyTagPub:(NSString *)tag {
    keyTagPub = tag;
}

+(void)setKeyTagPri:(NSString *)tag {
    keyTagPri = tag;
}

+(NSString*)getKeyTagLastString {
    NSString *str = [EncRSA getKeyAllTagPri];
    
    // 특정 인덱스부터 문자열 끝까지 반환
    NSString* tmp = [str substringFromIndex:str.length-1];
    // KSLOG_DEBUG(@"%@", tmp);
    
    return tmp;
}



@end
