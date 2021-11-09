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


#pragma mark - TouchID, FaceID 체크

/// TouchID/FaceID 사용 가능한지 여부 체크
+(BOOL)isAvailableBio;

/// TouchID/FaceID 상태 체크
+(int)checkBioState;

/// FaceID/TouchID 여부
+(BOOL)isFaceID;

/// Bio 인증 진행. TouchID/FaceID 창 출력
+(void)performBioAuth:(NSString*)guideText finishHandler:(void (^)(int resultCode))finishHandler;


@end

NS_ASSUME_NONNULL_END
