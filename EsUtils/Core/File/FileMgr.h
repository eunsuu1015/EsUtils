//
//  FileMgr.h
//  EsUtils
//
//  Created by ParkEunSu on 2022/06/20.
//  Copyright © 2022 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileMgr : NSObject

/// 이미지 파일 저장
/// @param image 이미지
/// @param name 파일명 (확장자 미포함 시 jpg로 강제 설정)
- (BOOL)saveImage:(UIImage *)image fileName:(NSString *)name;

/// 저장된 이미지 파일 가져오기
/// @param name 이미지 파일명 (확장자 미포함 시 jpg로 강제 설정)
- (UIImage*)getImage:(NSString*)name;

/// 이미지 파일 삭제
/// @param name 이미지 파일명 (확장자 미포함 시 jpg로 강제 설정)
- (BOOL)removeImage:(NSString *)name;

#pragma mark - Common

/// 파일 저장
/// @param data 저장할 데이터
/// @param fileName 파일명 (확장자 포함)
- (BOOL)saveData:(NSData *)data fileName:(NSString *)fileName;

/// 저장된 파일 가져오기
/// @param fileName 파일명 (확장자 포함)
- (NSData *)getData:(NSString*)fileName;

/// 파일 삭제
- (BOOL)removeData:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
