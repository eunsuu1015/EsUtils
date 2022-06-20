//
//  NetworkMgr.m
//  EsUtils
//
//  Created by ParkEunSu on 2022/04/18.
//  Copyright © 2022 ParkEunSu. All rights reserved.
//

#import "NetworkMgr.h"
#import "Reachability.h"

@implementation NetworkMgr

/// 네트워크 연결되어있는지 여부
+(BOOL)isConnectNetwork {
    BOOL state = NO;
    @try {
        NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
        if (netStatus == NotReachable) {
            // 네트워크 미연결 상태
            state = NO;
        } else {
            // 네트워크 연결 상태
            state = YES;
        }
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        state = NO;
    }
    return state;
    
}

/// 현재 네트워크 상태 가져오기
+(int)getNetworkStatus {
    @try {
        return (int)[[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return 0;
    }
}

@end
