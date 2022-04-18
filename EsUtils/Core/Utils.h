//
//  Utils.h
//  MMA
//
//  Created by ParkEunSu on 17/09/2019.
//  Copyright © 2019 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface Utils : NSObject


#pragma mark - LOG

/// 로그 출력 여부 설정
/// @param log 출력 여부 설정
+(void)setLog:(BOOL)log;


#pragma mark - Storyboard

/// 스토리보드에서 네비게이션 컨트롤러 pushViewController 진행
/// @param openVC push할 뷰컨트롤러
/// @param naviVC push시킬 네비게이션컨트롤러 (일반적으로 self.navigationController)
/// @param animated 오픈 시 애니메이션 여부
+(void)storyboardPushVC:(nonnull NSString*)openVC naviVC:(nonnull UINavigationController*)naviVC animated:(BOOL)animated;

/// 스토리보드에서 일반 뷰컨트롤러 presentViewController 진행
/// @param openVC present할 뷰컨트롤러
/// @param selfVC present시킬 현재 뷰컨트롤러 (일반적으로 self)
/// @param animated 오픈 시 애니메이션 여부
+(void)storyboardPresentVC:(nonnull NSString*)openVC selfVC:(nonnull UIViewController*)selfVC animated:(BOOL)animated;


#pragma mark - Random

/// 랜덤 문자 생성 (영어 대문자, 영어 소문자, 숫자)
/// @param length 랜덤 문자 길이
+(NSString *)makeRandomNumAlpha:(int)length;

/// 랜덤수 생성
/// @param length 랜덤수 길이
+(NSString *)makeRandomNum:(int)length;


#pragma mark - App Exit

/// 0.3초 후에 서스펜드 상태로 나감.
+(void)exitApp;

/// 0.3초 후에 서스펜드 상태로 나가면서, 직전에 네비게이션 컨트롤러 루트뷰컨트롤러로 이동함
+(void)exitAppMoveVC:(nonnull UINavigationController*)naviVC;


#pragma mark - Version

/// 앱 업데이트 필요 여부 체크
/// @param appVersion 앱 버전
/// @param appStoreVersion 앱스토어 버전
+(BOOL)isNeedUpdate:(nonnull NSString *)appVersion appStoreVersion:(nonnull NSString*)appStoreVersion;

/// 앱 업데이트 필요 여부 체크 (메이저, 마이너 2개만 체크함)
/// @param appVersion 앱 버전
/// @param appStoreVersion 앱스토어 버전
/// return 0 : 버전 동일 또는 불필요(비교 실패)
/// return 1 : 선택 업데이트 필요 (Patch 버전)
/// return 2 : 필수 업데이트 필요 (Major, Minor 버전)
+(int)isNeedUpdateMajorMinor:(NSString *)appVersion appStoreVersion:(NSString*)appStoreVersion;


#pragma mark - AppStore

/// 앱스토어로 이동. appId는 앱스토어에 업로드 후 appId 얻어서 사용 가능.
/// @param appId 앱아이디. 앱스토어 업로드 후 앱스토어 커넥트에서 조회 가능
+(void)goAppStore:(nonnull NSString*)appId;

@end

NS_ASSUME_NONNULL_END
