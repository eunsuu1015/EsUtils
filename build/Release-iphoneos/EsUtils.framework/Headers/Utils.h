//
//  Utils.h
//  MMA
//
//  Created by Authlabs on 17/09/2019.
//  Copyright © 2019 Authlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN


@interface Utils : NSObject


#pragma mark - LOG

/// 로그 출력 여부 설정
+(void)setLog:(BOOL)log;


#pragma mark - UI Color

/// RGB를 UIColor로 변환
+(UIColor *)colorWithRGBHex:(NSUInteger)RGBHex;

/// RGB를 UIColor로 변환
+(UIColor *)colorWithRGBHex:(NSUInteger)RGBHex alpha:(CGFloat)alpha;


#pragma mark - UI Custom

/// 그림자 효과 추가
+(void)addShadow:(id)viewId color:(UIColor*)color opacity:(float)opacity radius:(float)radius;

/// 라운드 처리
+(void)addRadius:(id)viewId radius:(int)radius;

/// 뷰를 원모양으로 만들기
+(void)makeCircle:(id)viewId;


#pragma mark - Size

/// 디바이스 가로 사이즈 조회
+(CGFloat)getDeviceWidthSize;

/// 디바이스 세로 사이즈 조회
+(CGFloat)getDeviceHeightSize;


#pragma mark - Default Dialog

/// 토스트 출력 (메인큐에서 진행)
+(void)showToast:(NSString*)title msg:(nonnull NSString*)msg sec:(int)sec vc:(nonnull UIViewController*)vc;

/// 기본 다이얼로그 출력  (메인큐에서 진행)
+(void)showDialog:(NSString*)title msg:(nonnull NSString*)msg vc:(nonnull UIViewController*)vc action:(void (^ __nullable)(UIAlertAction *action))action;

/// 기본 다이얼로그 출력. 다이얼로그만 종료 (메인큐에서 진행)
+(void)showDialogNonEvent:(NSString*)title msg:(nonnull NSString *)msg vc:(UIViewController *)vc;

/// 기본 다이얼로그 출력. 다이얼로그 종료 시 화면도 종료됨  (메인큐에서 진행)
+(void)showDialogDismissEvent:(NSString*)title msg:(nonnull NSString*)msg vc:(nonnull UIViewController*)vc dismissAnimated:(BOOL)animated;


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


#pragma mark - 형변환

/// String -> Hex로 변환
+(NSString *) stringToHex:(nonnull NSString *)string;

/// Data -> String
+(NSString*) stringToUTF8Data:(nonnull NSData *)data;

/// String -> Data
+(NSData*) utf8DataToString:(nonnull NSString *) string;


#pragma mark - Base64

/// Base64 인코딩
+(NSString*)encodeBase64:(nonnull NSString*)plainString;

/// Base64 디코딩
+(NSString*)decodeBase64:(nonnull NSString*)base64String;


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


#pragma mark - 디바이스 정보

/// 디바이스 OS 버전 조회
+(NSString*) getOsVer;


#pragma mark - Network

/// 네트워크가 연결되어있는지 여부
+(BOOL) isConnectNetwork;

/// 현재 네트워크 상태 가져오기
+(int) getNetworkStatus;


#pragma mark - TouchID, FaceID 체크

/// TouchID/FaceID 사용 가능한지 여부 체크
+(BOOL)isAvailableBio;

/// TouchID/FaceID 상태 체크
+(int)checkBioState;

/// FaceID/TouchID 여부
+(BOOL)isFaceID;

/// Bio 인증 진행. TouchID/FaceID 창 출력
+(void)performBioAuth:(NSString*)guideText finishHandler:(void (^)(int resultCode))finishHandler;


#pragma mark - Date

/// 현재 날짜 조회
+(NSString*)getDate;

/// 현재 시간 조회
+(NSString*)getTime;

/// 현재 날짜 및 시간 조회
+(NSString*)getDateTime;

/// 포맷 형식에 맞춰 현재 날짜 또는 날짜 및 시간 조회
+(NSString*)getDateTimeWithFormat:(nonnull NSString*)format;

/// 날짜 비교
+(NSInteger)compareFromStand:(nonnull NSDate *)standard toTarget:(nonnull NSDate *)target;

/// 날짜 텍스트를 NSDate 타입으로 변경
+(NSDate*)stringToDate:(nonnull NSString*)string;


#pragma mark - Etc

/// 설정화면으로 이동 (퍼미션 허용 등을 위해)
+(void)openSetting;


@end

NS_ASSUME_NONNULL_END
