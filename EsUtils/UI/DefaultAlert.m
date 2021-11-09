//
//  DefaultAlert.m
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import "DefaultAlert.h"

@implementation DefaultAlert


#pragma mark - Default Dialog

/// 토스트 출력 (메인큐에서 진행)
/// @param title 출력 타이틀 (타이틀 사용 안 할 경우, nil 또는 @"" 사용)
/// @param msg 출력 메시지
/// @param sec 토스트 노출 시간
/// @param vc 토스트 출력할 뷰컨트롤러 (보통 self)
+(void)showToast:(NSString*)title msg:(nonnull NSString*)msg sec:(int)sec vc:(nonnull UIViewController*)vc {
    if (IS_DEBUG_LOG) NSLog(@"%s start. title : %@ / msg : %@ / sec : %d", __FUNCTION__, title, msg, sec);
    @try {
        if (title == nil) {
            title = @"";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
            [vc presentViewController:alert animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alert dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        });
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end", __FUNCTION__);
}

/// 기본 다이얼로그 출력  (메인큐에서 진행)
/// @param title 출력 타이틀 (타이틀 사용 안 할 경우, nil 또는 @"" 사용)
/// @param msg 출력 메시지
/// @param vc 출력할 뷰컨트롤러 (보통 self)
/// @param action 버튼 이벤트
+(void)showDialog:(NSString*)title msg:(nonnull NSString*)msg vc:(nonnull UIViewController*)vc action:(void (^ __nullable)(UIAlertAction *action))action {
    if (IS_DEBUG_LOG) NSLog(@"%s start. title : %@ / msg : %@", __FUNCTION__, title, msg);
    @try {
        if (title == nil) {
            title = @"";
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:title
                                          message:msg
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"확인"
                                 style:UIAlertActionStyleDefault
                                 handler:action];
            
            [alert addAction:ok];
            [vc presentViewController:alert animated:YES completion:nil];
        });
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end", __FUNCTION__);
}

/// 기본 다이얼로그 출력. 다이얼로그만 종료 (메인큐에서 진행)
/// @param title 출력 타이틀 (타이틀 사용 안 할 경우, nil 또는 @"" 사용)
/// @param msg 출력 메시지
/// @param vc 출력할 뷰컨트롤러 (보통 self)
+(void)showDialogNonEvent:(NSString*)title msg:(nonnull NSString *)msg vc:(UIViewController *)vc {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    @try {
        if (title == nil) {
            title = @"";
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:title
                                          message:msg
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"확인"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:NO completion:nil];
            }];
            [alert addAction:ok];
            [vc presentViewController:alert animated:YES completion:nil];
        });
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end", __FUNCTION__);
}

/// 기본 다이얼로그 출력. 다이얼로그 종료 시 화면도 종료됨  (메인큐에서 진행)
/// @param title 출력 타이틀 (타이틀 사용 안 할 경우, nil 또는 @"" 사용)
/// @param msg 출력 메시지
/// @param vc 출력할 뷰컨트롤러 (보통 self)
/// @param animated 화면 종료 시 애니메이션 사용 여부
+(void)showDialogDismissEvent:(NSString*)title msg:(nonnull NSString*)msg vc:(nonnull UIViewController*)vc dismissAnimated:(BOOL)animated {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    @try {
        if (title == nil) {
            title = @"";
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:title
                                          message:msg
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"확인"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:NO completion:nil];
                [vc dismissViewControllerAnimated:animated completion:nil];
            }];
            [alert addAction:ok];
            [vc presentViewController:alert animated:YES completion:nil];
        });
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end", __FUNCTION__);
}


@end
