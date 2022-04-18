//
//  DefaultAlert.m
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import "DefaultAlert.h"

@implementation DefaultAlert

/// 토스트 출력 (메인큐에서 진행)
+(void)showToast:(NSString*)title msg:(nonnull NSString*)msg sec:(int)sec vc:(nonnull UIViewController*)vc {
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
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
}

/// 기본 다이얼로그 출력  (메인큐에서 진행)
+(void)showDialog:(NSString*)title msg:(nonnull NSString*)msg vc:(nonnull UIViewController*)vc action:(void (^ __nullable)(UIAlertAction *action))action {
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
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
}

/// 기본 다이얼로그 출력. 다이얼로그만 종료 (메인큐에서 진행)
+(void)showDialogNonEvent:(NSString*)title msg:(nonnull NSString *)msg vc:(UIViewController *)vc {
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
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
}

/// 기본 다이얼로그 출력. 다이얼로그 종료 시 화면도 종료됨  (메인큐에서 진행)
+(void)showDialogDismissEvent:(NSString*)title msg:(nonnull NSString*)msg vc:(nonnull UIViewController*)vc dismissAnimated:(BOOL)animated {
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
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
}


@end
