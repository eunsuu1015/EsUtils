//
//  DefaultAlert.h
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DefaultAlert : NSObject

#pragma mark - Default Dialog

/// 토스트 출력 (메인큐에서 진행)
+(void)showToast:(NSString*)title msg:(nonnull NSString*)msg sec:(int)sec vc:(nonnull UIViewController*)vc;

/// 기본 다이얼로그 출력  (메인큐에서 진행)
+(void)showDialog:(NSString*)title msg:(nonnull NSString*)msg vc:(nonnull UIViewController*)vc action:(void (^ __nullable)(UIAlertAction *action))action;

/// 기본 다이얼로그 출력. 다이얼로그만 종료 (메인큐에서 진행)
+(void)showDialogNonEvent:(NSString*)title msg:(nonnull NSString *)msg vc:(UIViewController *)vc;

/// 기본 다이얼로그 출력. 다이얼로그 종료 시 화면도 종료됨  (메인큐에서 진행)
+(void)showDialogDismissEvent:(NSString*)title msg:(nonnull NSString*)msg vc:(nonnull UIViewController*)vc dismissAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
