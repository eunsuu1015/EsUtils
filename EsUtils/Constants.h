//
//  Constants.h
//  KhnpAuthApp
//
//  Created by Authlabs on 2020/01/13.
//  Copyright © 2020 Authlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//#ifdef DEBUG
//#define LOG_START   NSLog(@"start", __PRETTY_FUNCTION__, __LINE__);
//#define LOG_END     NSLog(@"end", __PRETTY_FUNCTION__, __LINE__);
//#define NSLog(fmt, ...) NSLog((@"%s[%d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//    #define LOG_START
//    #define LOG_END
    #define NSLog(...)
//#endif

#pragma mark - Flag Value

static BOOL IS_DEBUG_LOG = YES; // 로그 출력 여부 / 빌드 시 NO
static BOOL IS_TMP_FLAG = NO;

#pragma mark - 상수

#define TEXT_ERR_JSON @"상수 예시"


#pragma mark - ENUM

typedef NS_ENUM(int, MODE_EXAMPLE) {
    MODE_NONE = 0,
    MODE_REGISTER,
    MODE_AUTH       
};

NS_ASSUME_NONNULL_END
