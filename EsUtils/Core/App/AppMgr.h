//
//  AppMgr.h
//  EsUtils
//
//  Created by ParkEunSu on 2022/04/18.
//  Copyright © 2022 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppMgr : NSObject

/// 앱 버전 조회
+(NSString*)getAppVersion;

/// 앱스토어 버전 조회
+(NSString*)getAppStoreVersion;

/// bundleId로 앱스토어 버전 조회
/// @param bundleId bundleId
+(NSString*)getAppStoreVersion:(NSString*)bundleId;


#pragma mark - App

/// bundleID 조회
+(NSString*)getBundleId;

/// 설정 앱 - 해당 앱 화면으로 이동
/// 퍼미션 허용 등을 위해 설정화면으로 이동할 때 사용
+(void)openSetting;

@end

NS_ASSUME_NONNULL_END
