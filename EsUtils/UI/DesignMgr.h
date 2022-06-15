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
/// @param RGBHex RGBHex 값 ex) 0xFF00FF
+(UIColor *)colorWithRGBHex:(NSUInteger)RGBHex;

/// RGB를 UIColor로 변환
/// @param RGBHex REGHex 값 ex) 0xFF00FF
/// @param alpha 투명도 0.0 ~ 1.0
+(UIColor *)colorWithRGBHex:(NSUInteger)RGBHex alpha:(CGFloat)alpha;


#pragma mark - UI Custom

/// 그림자 효과 추가
/// @param viewId 그림자 효과 추가할 뷰
/// @param color 그림자 색상
/// @param opacity 불투명정도
/// @param radius 반경?
+(void)addShadow:(id)viewId color:(UIColor*)color opacity:(float)opacity radius:(float)radius;

/// 버튼 텍스트, 텍스트 색상 변경 및 언더라인 추가
/// @param btn 버튼 객체
/// @param text 텍스트
/// @param textColor 텍스트 색상
+(void)addBtnUnderline:(UIButton*)btn text:(NSString*)text textColor:(UIColor*)textColor;

/// 라운드 처리
/// @param radius 라운드 정도
/// @param viewId 라운드 처리할 뷰
+(void)makeRadius:(int)radius viewId:(id)viewId;

/// 뷰를 원모양으로 만들기
/// @param viewId 원모양으로 만들 뷰
+(void)makeCircle:(id)viewId;

/// 뷰 테두리 추가
/// @param viewId 테두리 추가할 뷰
/// @param width 테두리 두께
/// @param color 테두리 색상
+(void)setBorderLine:(UIView*)viewId width:(int)width color:(UIColor*)color;

/// 그라데이션 추가
/// @param viewId 뷰
/// @param isVertical YES : 세로 그라데이션, NO : 가로 그라데이션
/// @param firstColor 위 또는 왼쪽 색상
/// @param secondColor 아래 또는 오른쪽 색상
+(void)setGradient:(id)viewId isVertical:(BOOL)isVertical firstColor:(UIColor*)firstColor secondColor:(UIColor*)secondColor;

#pragma mark - UILabel Custom

/// 라벨 사이에 spacing 추가
/// @param spacing 간격
/// @param label 적용할 label
+(void)addLabelSpacing:(float)spacing label:(UILabel*)label;

@end

NS_ASSUME_NONNULL_END
