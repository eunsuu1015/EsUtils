//
//  NetworkMgr.h
//  EsUtils
//
//  Created by ParkEunSu on 2022/04/18.
//  Copyright © 2022 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkMgr : NSObject

/// 네트워크 연결되어있는지 여부
+(BOOL)isConnectNetwork;

/// 현재 네트워크 상태 가져오기
/// NetworkStatus
/// - NotReachable 0 : 네트워크 미연결 or Exception 발생
/// - ReachableViaWWAN : LTE
/// - ReachableViaWiFi : 와이파이
+(int)getNetworkStatus;

@end

NS_ASSUME_NONNULL_END
