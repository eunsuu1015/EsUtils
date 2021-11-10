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
+(void)setString:(NSString*)key value:(NSString*)value {
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
+(NSString*)getString:(NSString*)key {
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
+(void)setInt:(NSString*)key value:(int)value {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:(NSInteger)value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 조회 Int
/// @param key 키
+(int)getInt:(NSString*)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger getData = [userDefaults integerForKey:key];
    return (int)getData;
}


#pragma mark - BOOL

+(void)setBool:(NSString*)key value:(BOOL)value {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
}

+(BOOL)getBool:(NSString*)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
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
