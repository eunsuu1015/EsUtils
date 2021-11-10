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

+(void)setString:(NSString*)key value:(NSString*)value;
+(NSString*)getString:(NSString*)key;

#pragma mark - Int

+(void)setInt:(NSString*)key value:(int)value;
+(int)getInt:(NSString*)key;

#pragma mark - BOOL

+(void)setBool:(NSString*)key value:(BOOL)value;
+(BOOL)getBool:(NSString*)key;


#pragma mark - Comm

+(void)delete:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
