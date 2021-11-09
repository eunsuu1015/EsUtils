//
//  DesignMgr.h
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DesignMgr : NSObject

#pragma mark - UI Color

/// RGB를 UIColor로 변환
+(UIColor *)colorWithRGBHex:(NSUInteger)RGBHex;

/// RGB를 UIColor로 변환
+(UIColor *)colorWithRGBHex:(NSUInteger)RGBHex alpha:(CGFloat)alpha;


#pragma mark - UI Custom

/// 그림자 효과 추가
+(void)addShadow:(id)viewId color:(UIColor*)color opacity:(float)opacity radius:(float)radius;

/// 라운드 처리
+(void)addRadius:(id)viewId radius:(int)radius;

/// 뷰를 원모양으로 만들기
+(void)makeCircle:(id)viewId;

@end

NS_ASSUME_NONNULL_END
