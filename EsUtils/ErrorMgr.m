//
//  ErrorMgr.m
//  EsUtils
//
//  Created by Authlabs on 2021/11/09.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import "ErrorMgr.h"

@implementation ErrorMgr

+(ErrorMgr *)sharedInstance {
    static ErrorMgr *mgr = nil;
    static dispatch_once_t onceToken;
    
    if (mgr == nil) {
        dispatch_once(&onceToken, ^{
            mgr = [[ErrorMgr alloc] init];
        });
    }
    return mgr;
}

-(nullable NSString *)getMsgFromErrCode:(int)errCode {
    NSString *errMsg = @"알 수 없는 오류 발생";
            
    ERROR code = errCode;
    
    switch (code) {
        case ERROR_CODE_NONE:
            return @"오류 없음";

#pragma mark 공통
            
        case ERROR_NULL_PARAM:
            return @"파라미터 중 null 값이 있습니다.";
            
#pragma mark 암호화
        case ERROR_NULL_KEY:
            return @"암호화 키가 없습니다.";
        
        default:    // 스마트 컨트랙트 오류
            return errMsg;
    }
}

/// 에러코드 설정하면 에러메시지 자동으로 설정
-(void)setErrCode:(int)errCode {
    _errCode = errCode;
    _errMsg = [self getMsgFromErrCode:errCode];
}

@end
