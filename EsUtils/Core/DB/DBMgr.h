//
//  DBMgr.h
//  ViewCollect
//
//  Created by Authlabs on 2020/04/27.
//  Copyright © 2020 Authlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

// TODO: 참고용으로만 사용 (테스트 필요)
@interface DBMgr : NSObject

// 데이터베이스 경로
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *sql;

/// 초기화
-(instancetype)init;


#pragma mark - 공통
#pragma mark  Insert

/// String 값 저장 (인덱스에 해당하는 값이 있으면 update, 없으면 insert)
/// @param value 값
/// @param key 키
/// @param index 인덱스
-(BOOL)insertString:(NSString *)value key:(NSString *)key index:(int)index;

/// String 값 저장. 다음 인덱스에 무조건 저장
/// @param value 값
/// @param key 키
-(BOOL)insertString:(NSString *)value key:(NSString *)key;

/// Int 값 저장 (인덱스에 해당하는 값이 있으면 update, 없으면 insert)
/// @param value 값
/// @param key 키
/// @param index 인덱스
-(BOOL)insertInt:(int)value key:(NSString *)key index:(int)index;

/// Int 값 저장. 다음 인덱스에 무조건 저장
/// @param value 값
/// @param key 키
-(BOOL)insertInt:(int)value key:(NSString *)key;

#pragma mark Select

/// String 값 조회
/// @param key 키
/// @param index 인덱스
-(NSString*)loadString:(NSString*)key index:(int)index;

/// Int 값 조회
/// @param key 키
/// @param index 인덱스
-(int)loadInt:(NSString*)key index:(int)index;

/// 인덱스 데이터 조회
-(NSMutableDictionary *)load:(int)index;

/// 저장된 데이터 있는지 조회
/// @param key 키
/// @param index 인덱스
-(BOOL)isExist:(NSString *)key index:(int)index;

/// 저장된 데이터 있는지 조회
/// @param querySQL sql
-(BOOL)isExist:(NSString*)querySQL;


#pragma mark - Etc

/// 모든 데이터 출력
-(void)printAllDbData;

@end

NS_ASSUME_NONNULL_END
