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
+(UIColor *)colorWithRGBHex:(NSUInteger)RGBHex {
    @try {
        CGFloat red = ((CGFloat)((RGBHex & 0xFF0000) >> 16)) / 255.0f;
        CGFloat green = ((CGFloat)((RGBHex & 0xFF00) >> 8)) / 255.0f;
        CGFloat blue = ((CGFloat)((RGBHex & 0xFF))) / 255.0f;
        return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}

/// RGB를 UIColor로 변환
+(UIColor *)colorWithRGBHex:(NSUInteger)RGBHex alpha:(CGFloat)alpha {
    @try {
        CGFloat red = ((CGFloat)((RGBHex & 0xFF0000) >> 16)) / 255.0f;
        CGFloat green = ((CGFloat)((RGBHex & 0xFF00) >> 8)) / 255.0f;
        CGFloat blue = ((CGFloat)((RGBHex & 0xFF))) / 255.0f;
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}


#pragma mark - UI Custom

/// 그림자 효과 추가
+(void)addShadow:(id)viewId color:(UIColor*)color opacity:(float)opacity radius:(float)radius {
    @try {
        UIView *view = (UIView*)viewId;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:view.bounds];
        [view.layer setMasksToBounds:NO];
        [view.layer setShadowColor:[color CGColor]];
        [view.layer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
        [view.layer setShadowOpacity:opacity];
        [view.layer setShadowRadius:radius];
        [view.layer setShadowPath:shadowPath.CGPath];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
}

/// 버튼 텍스트, 텍스트 색상 변경 및 언더라인 추가
+(void)addBtnUnderline:(UIButton*)btn text:(NSString*)text textColor:(UIColor*)textColor {
    @try {
        NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:text];
        [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
        [commentString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, [commentString length])];
        [btn setAttributedTitle:commentString forState:UIControlStateNormal];
        
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
}

/// 라운드 처리
+(void)makeRadius:(int)radius viewId:(id)viewId {
    @try {
        UIView *view = (UIView*)viewId;
        view.clipsToBounds = YES;
        view.layer.cornerRadius = radius;
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
}

/// 뷰를 원모양으로 만들기
+(void)makeCircle:(id)viewId {
    @try {
        UIView *view = (UIView*)viewId;
        view.layer.cornerRadius = view.frame.size.width/2;
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
}

/// 뷰 테두리 추가
/// @param width 테두리 두께
+(void)setBorderLine:(UIView*)viewId width:(int)width color:(UIColor*)color {
    viewId.clipsToBounds = YES;
    viewId.layer.borderWidth = width;
    viewId.layer.borderColor = color.CGColor;
}

/// 그라데이션 추가
+(void)setGradient:(id)viewId isVertical:(BOOL)isVertical firstColor:(UIColor*)firstColor secondColor:(UIColor*)secondColor {
    @try {
        UIView *view = (UIView*)viewId;
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = view.layer.bounds;
        
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)firstColor.CGColor,
                                (id)secondColor.CGColor,
                                nil];
        if (isVertical) {
            gradientLayer.startPoint = CGPointMake(0.0, 0.0);
            gradientLayer.endPoint = CGPointMake(0.0, 1.0);
        } else {
            gradientLayer.startPoint = CGPointMake(0.0, 0.0);
            gradientLayer.endPoint = CGPointMake(1.0, 0.0);
        }
        [view.layer insertSublayer:gradientLayer atIndex:0];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
}

#pragma mark - UILabel Custom

/// 라벨 사이에 spacing 추가
+(void)addLabelSpacing:(float)spacing label:(UILabel*)label {
    @try {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
        [attributedString addAttribute:NSKernAttributeName
                                 value:@(spacing)
                                 range:NSMakeRange(0, [label.text length])];
        label.attributedText = attributedString;
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
}

@end
