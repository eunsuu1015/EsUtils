//
//  ErrorMgr.h
//  EsUtils
//
//  Created by ParkEunSu on 2021/11/09.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    ERROR_CODE_NONE             = 0,
    
#pragma mark 공통
    ERROR_NULL_PARAM            = -10000,
    
#pragma mark 암호화
    ERROR_NULL_KEY              = -11000,
    ERROR_FAIL_GEN_KEY_PAIR     = -11001,
    
} ERROR;


@interface ErrorMgr : NSObject

+(ErrorMgr *)sharedInstance;

@property (nonatomic, strong) NSString* errMsg;
@property (nonatomic) int errCode;


@end

NS_ASSUME_NONNULL_END
