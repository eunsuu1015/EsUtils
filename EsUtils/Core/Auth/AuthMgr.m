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

/// TouchID/FaceID 사용 가능한지 여부
+(BOOL)isAvailableBio {
    BOOL result = NO;
    @try {
        LAContext *myContext = [[LAContext alloc] init];
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            result = YES;
        } else {
            result = NO;
        }
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    return result;
}

/// TouchID/FaceID 상태 체크
/// 불가능한 상태인 경우, 어떤 상태인지 리턴
/// 1 : 사용 가능한 상태
/// 그 외 : 사용 불가한 상태
+(int)checkBioState {
    int state = 0;
    @try {
        LAContext *myContext = [[LAContext alloc] init];
        NSError *authError = nil;
        
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            // 사용 가능
            state = 1;
        } else {
            // 사용 불가능
            state = (int)authError.code;
            switch (state) {
                case kLAErrorPasscodeNotSet:
                    // 암호가 설정되지 않음
                    break;
                    
                case kLAErrorTouchIDNotAvailable:   // -6
                    // faceID 권한 비허용 상태
                    break;
                    
                case kLAErrorTouchIDNotEnrolled:    // -7
                    // touchID, faceID 등록되지 않음
                    break;
                    
                case kLAErrorTouchIDLockout:    // -8
                    // touchID, faceID 비활성화 상태
                    break;
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    return state;
}

/// FaceID/TouchID 여부
+(BOOL)isFaceID {
    BOOL result = NO;
    @try {
        LAContext *myContext = [[LAContext alloc] init];
        NSError *authError = nil;
        
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            if (@available(iOS 11.0, *)) {
                int type = myContext.biometryType;
                if (type == LABiometryTypeFaceID) {
                    NSLog(@"%s faceID 지원 기기", __FUNCTION__);
                    result = YES;
                } else {
                    NSLog(@"%s touchID 지원 기기", __FUNCTION__);
                    result = NO;
                }
            }
        } else {
            if (@available(iOS 11.0, *)) {
                int type = myContext.biometryType;
                if (type == LABiometryTypeFaceID) {
                    NSLog(@"%s faceID 지원 기기", __FUNCTION__);
                    result = YES;
                } else {
                    NSLog(@"%s touchID 지원 기기", __FUNCTION__);
                    result = NO;
                }
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    return result;
}

/// Bio 인증 진행. TouchID/FaceID 창 출력
+(void)performBioAuth:(NSString*)guideText finishHandler:(void (^)(int resultCode))finishHandler {
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
                    finishHandler(1);
                } else {
                    finishHandler((int)error.code);
                }
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //Touch ID 비활성화됨
                finishHandler((int)authError.code);
            });
        }
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        finishHandler(0);
    }
}

@end
