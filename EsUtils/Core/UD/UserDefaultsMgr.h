//
//  UserDefaultsMgr.h
//  EsUtils
//
//  Created by EunSu on 2020/02/09.
//  Copyright © 2020 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDefaultsMgr : NSObject

#pragma mark - String

+(NSString *) loadUdString:(NSString*)key;
+(void) saveUdString:(NSString*)key value:(NSString*)value;

#pragma mark - Int
+(NSInteger) loadUdInt:(NSString*)key;
+(void) saveUdInt:(NSString*)key value:(NSInteger)value;

#pragma mark - Comm

+(void) deleteUd:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
