//
//  AuthMgr.h
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 인증수단 관련
@interface AuthMgr : NSObject

/// TouchID/FaceID 사용 가능한지 여부
+(BOOL)isAvailableBio;

/// TouchID/FaceID 상태 체크
/// 불가능한 상태인 경우, 어떤 상태인지 리턴
/// 1 : 사용 가능한 상태
/// 그 외 : 사용 불가한 상태
+(int)checkBioState;

/// FaceID/TouchID 여부
+(BOOL)isFaceID;

/// Bio 인증 진행. TouchID/FaceID 창 출력
/// @param guideText TouchID 설명 문구. nil일 경우 default 문구 출력 (FaceID는 설명 문구 없음)
/// @param finishHandler 인증 완료 시 핸들러
+(void)performBioAuth:(NSString*)guideText finishHandler:(void (^)(int resultCode))finishHandler;


@end

NS_ASSUME_NONNULL_END
