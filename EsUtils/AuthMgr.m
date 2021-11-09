//
//  AuthMgr.m
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import "AuthMgr.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation AuthMgr

#pragma mark - TouchID, FaceID 체크

/// TouchID/FaceID 사용 가능한지 여부 체크
/// 단순 가능/불가능 여부만 체크
+(BOOL)isAvailableBio {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    BOOL result = NO;
    @try {
        LAContext *myContext = [[LAContext alloc] init];
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            result = YES;
        } else {
            result = NO;
        }
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        result = NO;
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end. result : %d", __FUNCTION__, result);
    return result;
}

/// TouchID/FaceID 상태 체크
/// 불가능한 상태인 경우, 어떤 상태인지 리턴
/// 1 : 사용 가능한 상태
/// 그 외 : 사용 불가한 상태
+(int)checkBioState {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    int state = 0;
    @try {
        LAContext *myContext = [[LAContext alloc] init];
        NSError *authError = nil;
        
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            if (IS_DEBUG_LOG) NSLog(@"%s TouchID/FaceID 사용 가능", __FUNCTION__);
            state = 1;
            
        } else {
            if (IS_DEBUG_LOG) NSLog(@"%s TouchID/FaceID 사용 불가능", __FUNCTION__);
            state = (int)authError.code;
            switch (state) {
                case kLAErrorPasscodeNotSet:
                    // 암호 설정되지 않음
                    if (IS_DEBUG_LOG) NSLog(@"%s -5. 설정된 암호가 없음", __FUNCTION__);
                    break;
                    
                case kLAErrorTouchIDNotAvailable:   // -6
                    // faceID 권한 비허용
                    if (IS_DEBUG_LOG) NSLog(@"%s -6 FaceID 권한 비허용", __FUNCTION__);
                    break;
                    
                case kLAErrorTouchIDNotEnrolled:    // -7
                    // touchID, faceID 등록된거 없음
                    if (IS_DEBUG_LOG) NSLog(@"%s -7. 등록된 TouchID/FaceID 없음", __FUNCTION__);
                    break;
                    
                case kLAErrorTouchIDLockout:    // -8
                    // touchID, faceID 비활성화 상태
                    if (IS_DEBUG_LOG) NSLog(@"%s -8 TouchID/FaceID 비활성화 상태", __FUNCTION__);
                    break;
            }
        }
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        state = 0;
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end. return : %d", __FUNCTION__, state);
    return state;
}

/// FaceID/TouchID 여부
/// return YES : FaceID
/// return NO : TouchID
+(BOOL)isFaceID {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    BOOL result = NO;
    @try {
        LAContext *myContext = [[LAContext alloc] init];
        NSError *authError = nil;
        
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            
            if (@available(iOS 11.0, *)) {
                int type = myContext.biometryType;
                if (type == LABiometryTypeFaceID) {
                    if (IS_DEBUG_LOG) NSLog(@"%s faceID 지원 기기", __FUNCTION__);
                    result = YES;
                } else {
                    if (IS_DEBUG_LOG) NSLog(@"%s touchID 지원 기기", __FUNCTION__);
                    result = NO;
                }
            }
        } else {
            if (@available(iOS 11.0, *)) {
                int type = myContext.biometryType;
                if (type == LABiometryTypeFaceID) {
                    if (IS_DEBUG_LOG) NSLog(@"%s faceID 지원 기기", __FUNCTION__);
                    result = YES;
                } else {
                    if (IS_DEBUG_LOG) NSLog(@"%s touchID 지원 기기", __FUNCTION__);
                    result = NO;
                }
            }
        }
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        result = NO;
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end. return : %d", __FUNCTION__, result);
    return result;
}

/// Bio 인증 진행. TouchID/FaceID 창 출력
/// @param guideText TouchID 설명 문구. nil일 경우 default 문구 출력 (FaceID는 설명 문구 없음)
/// @param finishHandler 인증 완료 시 핸들러
+(void)performBioAuth:(NSString*)guideText finishHandler:(void (^)(int resultCode))finishHandler {
    if (IS_DEBUG_LOG) NSLog(@"%s start. guideText : %@", __FUNCTION__, guideText);
    @try {
        if (guideText != nil) {
            guideText = @"지문을 입력해주세요.";
        }
        LAContext *myContext = [[LAContext alloc] init];
        NSError *authError = nil;
        NSString *myLocalizedReasonString = guideText;
        
        //비밀번호 입력 버튼 없애기
        myContext.localizedFallbackTitle = @"";
        
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError *error) {
                if (success) {
                    if (IS_DEBUG_LOG) NSLog(@"%s end. return : 1", __FUNCTION__);
                    finishHandler(1);
                } else {
                    if (IS_DEBUG_LOG) NSLog(@"%s end. return : %d", __FUNCTION__, (int)error.code);
                    finishHandler((int)error.code);
                }
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //Touch ID 비활성화됨
                if (IS_DEBUG_LOG) NSLog(@"%s end. return : %d", __FUNCTION__, (int)authError.code);
                finishHandler((int)authError.code);
            });
        }
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        if (IS_DEBUG_LOG) NSLog(@"%s end. return : 0", __FUNCTION__);
        finishHandler(0);
    }
}

@end
