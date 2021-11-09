//
//  UserDefaultsMgr.m
//  EsUtils
//
//  Created by EunSu on 2020/02/09.
//  Copyright © 2020 ParkEunSu. All rights reserved.
//

#import "UserDefaultsMgr.h"

@implementation UserDefaultsMgr

#pragma mark - String

/// 저장 String
/// @param key 키
/// @param value 값
+(void)saveUdString:(NSString*)key value:(NSString*)value {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
}

/// 조회 String
/// @param key 키
+(NSString *)loadUdString:(NSString*)key {
    @try {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *getData = [userDefaults objectForKey:key];
        return getData;
        
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}


#pragma mark - Int

/// 저장 Int
/// @param key 키
/// @param value 값
+(void)saveUdInt:(NSString*)key value:(NSInteger)value {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 조회 Int
/// @param key 키
+(NSInteger)loadUdInt:(NSString*)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger getData = [userDefaults integerForKey:key];
    return getData;
}


#pragma mark - Common

/// 삭제
/// @param key 키
+(void)deleteUd:(NSString*)key {
    @try {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
}

@end
