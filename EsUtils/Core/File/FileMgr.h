//
//  FileMgr.h
//  ViewCollect
//
//  Created by Authlabs on 2020/04/24.
//  Copyright © 2020 Authlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileMgr : NSObject

/// 파일명과 함께 초기화
/// @param name 파일 이름
-(id)initWithFileName:(NSString*)name;

/// 파일 패스를 파일명으로 설정
-(NSString*)setFilePath:(NSString*)fileName;

#pragma mark - Save

/// DEFAULT_FILE_KEY에 값 저장
/// FILE은 초기화 시 설정한 파일 (없으면 default 파일)
/// @param value 저장할 값
/// @param isAppend YES : 이전 데이터에 내용 추가, NO : 새로운 데이터로 덮기
-(BOOL)saveFile:(NSString*)value isAppend:(BOOL)isAppend;

/// 파일에 데이터 저장
/// FILE은 초기화 시 설정한 파일 (없으면 default 파일)
/// @param key 저장 키
/// @param value 저장할 값
/// @param isAppend YES : 이전 데이터에 내용 추가, NO : 새로운 데이터로 덮기
-(BOOL)saveFileKey:(NSString*)key value:(NSString*)value isAppend:(BOOL)isAppend;


#pragma mark - Load

/// DEFAULT_FILE_KEY에서 값 가져옴
/// FILE은 초기화 시 설정한 파일 (없으면 default 파일)
-(NSString*)loadFile;

/// key에서 값 가져옴
/// FILE은 초기화 시 설정한 파일 (없으면 default 파일)
/// @param key 조회할 키
-(NSString*)loadFileKey:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
