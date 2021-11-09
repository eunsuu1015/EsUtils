//
//  DesignMgr.m
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import "DesignMgr.h"

@implementation DesignMgr


#pragma mark - UI Color

/// RGB를 UIColor로 변환
/// @param RGBHex RGBHex 값 ex) 0xFF00FF
+(UIColor *)colorWithRGBHex:(NSUInteger)RGBHex {
    UIColor *color = nil;
    @try {
        CGFloat red = ((CGFloat)((RGBHex & 0xFF0000) >> 16)) / 255.0f;
        CGFloat green = ((CGFloat)((RGBHex & 0xFF00) >> 8)) / 255.0f;
        CGFloat blue = ((CGFloat)((RGBHex & 0xFF))) / 255.0f;
        color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        color = nil;
    }
    return color;
}

/// RGB를 UIColor로 변환
/// @param RGBHex REGHex 값 ex) 0xFF00FF
/// @param alpha 투명도 0.0 ~ 1.0
+(UIColor *)colorWithRGBHex:(NSUInteger)RGBHex alpha:(CGFloat)alpha {
    UIColor *color = nil;
    @try {
        CGFloat red = ((CGFloat)((RGBHex & 0xFF0000) >> 16)) / 255.0f;
        CGFloat green = ((CGFloat)((RGBHex & 0xFF00) >> 8)) / 255.0f;
        CGFloat blue = ((CGFloat)((RGBHex & 0xFF))) / 255.0f;
        color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        color = nil;
    }
    return color;
}


#pragma mark - UI Custom

/// 그림자 효과 추가
/// @param viewId 그림자 효과 추가할 뷰
/// @param color 그림자 색상
/// @param opacity 불투명정도
/// @param radius 반경?
+(void)addShadow:(id)viewId color:(UIColor*)color opacity:(float)opacity radius:(float)radius {
    if (IS_DEBUG_LOG) NSLog(@"%s start. opacity : %f / radius : %f", __FUNCTION__, opacity, radius);
    @try {
        // 뷰 그림자 효과
        UIView *view = (UIView*)viewId;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:view.bounds];
        [view.layer setMasksToBounds:NO];
        [view.layer setShadowColor:[color CGColor]];
        [view.layer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
        [view.layer setShadowOpacity:opacity];
        [view.layer setShadowRadius:radius];
        [view.layer setShadowPath:shadowPath.CGPath];
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end", __FUNCTION__);
}


/// 버튼 텍스트, 텍스트 색상 변경 및 언더라인 추가
/// @param btn 버튼 객체
/// @param text 텍스트
/// @param textColor 텍스트 색상
+(void)addBtnUnderline:(UIButton*)btn text:(NSString*)text textColor:(UIColor*)textColor {
    if (IS_DEBUG_LOG) NSLog(@"%s start. text : %@", __FUNCTION__, text);
    @try {
        NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:text];
        
        [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
        
        [commentString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, [commentString length])];
        
        [btn setAttributedTitle:commentString forState:UIControlStateNormal];
        
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end", __FUNCTION__);
}


/// 라운드 처리
/// @param viewId 라운드 처리할 뷰
/// @param radius 라운드 정도
+(void)addRadius:(id)viewId radius:(int)radius {
    if (IS_DEBUG_LOG) NSLog(@"%s start. radius : %d", __FUNCTION__, radius);
    @try {
        UIView *view = (UIView*)viewId;
        view.clipsToBounds = YES;
        view.layer.cornerRadius = radius;
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end", __FUNCTION__);
}

/// 뷰를 원모양으로 만들기
/// @param viewId 원모양으로 만들 뷰
+(void)makeCircle:(id)viewId {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    @try {
        UIView *view = (UIView*)viewId;
        view.layer.cornerRadius = view.frame.size.width/2;
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end", __FUNCTION__);
}


@end
