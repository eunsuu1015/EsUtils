//
//  Utils.h
//  MMA
//
//  Created by Authlabs on 17/09/2019.
//  Copyright © 2019 Authlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface Utils : NSObject


#pragma mark - LOG

/// 로그 출력 여부 설정
+(void)setLog:(BOOL)log;


#pragma mark - Storyboard

/// 스토리보드에서 네비게이션 컨트롤러 pushViewController 진행
+(void)storyboardPushVC:(nonnull NSString*)openVC naviVC:(nonnull UINavigationController*)naviVC animated:(BOOL)animated;

/// 스토리보드에서 일반 뷰컨트롤러 presentViewController 진행
+(void)storyboardPresentVC:(nonnull NSString*)openVC selfVC:(nonnull UIViewController*)selfVC animated:(BOOL)animated;


#pragma mark - Random

/// 랜덤 문자 생성 (영어 대문자, 영어 소문자, 숫자)
+(NSString *)makeRandomNumAlpha:(int)length;

/// 랜덤수 생성
+(NSString *)makeRandomNum:(int)length;


#pragma mark - App Exit

/// 0.3초 후에 서스펜드 상태로 나감.
+(void)exitApp;

/// 0.3초 후에 서스펜드 상태로 나가면서, 직전에 네비게이션 컨트롤러 루트뷰컨트롤러로 이동함
+(void)exitAppMoveVC:(nonnull UINavigationController*)naviVC;


#pragma mark - Version

/// 앱 버전 조회
+(NSString*)getAppVersion;

/// 앱스토어 버전 조회
+(NSString*)getAppStoreVersion;

/// 앱 업데이트 필요 여부 체크
+(BOOL)isNeedUpdate:(nonnull NSString *)appVersion appStoreVersion:(nonnull NSString*)appStoreVersion;

/// 앱스토어로 이동. appId는 앱스토어에 업로드 후 appId 얻어서 사용 가능.
+(void)goAppStore:(nonnull NSString*)appId;


#pragma mark - Network

/// 네트워크가 연결되어있는지 여부
+(BOOL) isConnectNetwork;

/// 현재 네트워크 상태 가져오기
+(int) getNetworkStatus;


#pragma mark - Etc

/// 설정화면으로 이동 (퍼미션 허용 등을 위해)
+(void)openSetting;


@end

NS_ASSUME_NONNULL_END
