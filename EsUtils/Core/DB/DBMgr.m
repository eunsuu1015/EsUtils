//
//  DBMgr.m
//  ViewCollect
//
//  Created by ParkEunSu on 2020/04/27.
//  Copyright © 2020 ParkEunSu. All rights reserved.
//

#import "DBMgr.h"

// 디비파일, 컬럼명 정의
const NSString *DB_NAME = @"DB_NAME.db";
const NSString *TABLE_NAME = @"TABLE_NAME";
const NSString *INDEX = @"_INDEX";
const NSString *STRING_VALUE = @"STRING_VALUE";
const NSString *INT_VALUE = @"INT_VALUE";

@implementation DBMgr


/// 초기화
-(instancetype)init {
    if (self = [super init]) {
        NSString *docsDir;
        NSArray *dirPaths;
        
        // 디비 파일 경로 설정
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        
        _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:DB_NAME]];
        [self makeDbFile];
    }
    return self;
}

/// 디비 오픈
/// 파일이 있다면 파일을 연다.
/// 파일이 없다면 파일 생성 후 파일을 연다.
-(BOOL)open {
    const char *dbpath = [_databasePath UTF8String];
    // 파일이 있다면, 파일을 열고
    // 파일이 없다면, 파일 생성 후 연다
    return sqlite3_open(dbpath, &_sql);
}

/// 디비 닫기
-(BOOL)close {
    sqlite3_close(_sql);
    return YES;
}

/// 파일 존재 여부 확인
-(BOOL)existDbFile {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath: _databasePath ] == NO) {
        // 디비 파일 없음
        return NO;
    } else {
        return YES;
    }
}

/// 디비 파일과 테이블 생성
-(BOOL)makeDbFile {
    @try {
        // 디비 파일 오픈 실패
        if ([self open] != SQLITE_OK) {
            return NO;
        }
        NSString *strCreate = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ VARCHAR(64),%@ INTEGER)",
                               TABLE_NAME,
                               INDEX,
                               STRING_VALUE,
                               INT_VALUE];
        char *errMsg;
        const char *sql_stmt = [strCreate UTF8String];
        
        if (sqlite3_exec(_sql, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
            // 디비 테이블 생성 실패
            NSLog(@"errMsg : %s", errMsg);
            [self close];
            return NO;
        } else {
            [self close];
            return YES;
        }
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return NO;
    }
}


#pragma mark - 공통
#pragma mark  Insert

/// String 값 저장 (인덱스에 해당하는 값이 있으면 update, 없으면 insert)
-(BOOL)insertString:(NSString *)value key:(NSString *)key index:(int)index {
    // 데이터 있는 경우는 update 진행
    if ([self isExist:key index:index]) {
        return [self updateString:value key:key index:index];
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES (%d, '%@')", TABLE_NAME, INDEX, key, 0,  value];
    return [self insert:insertSQL];
}

/// String 값 저장. 다음 인덱스에 무조건 저장
-(BOOL)insertString:(NSString *)value key:(NSString *)key {
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES ('%@')", TABLE_NAME, key, value];
    return [self insert:insertSQL];
}

/// Int 값 저장 (인덱스에 해당하는 값이 있으면 update, 없으면 insert)
-(BOOL)insertInt:(int)value key:(NSString *)key index:(int)index {
    // 데이터 있는 경우는 update 진행
    if ([self isExist:key index:index]) {
        return [self updateInt:value key:key index:index];
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES (%d, %d)", TABLE_NAME, INDEX, key, 0,  value];
    return [self insert:insertSQL];
}

/// Int 값 저장. 다음 인덱스에 무조건 저장
-(BOOL)insertInt:(int)value key:(NSString *)key {
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%d)", TABLE_NAME, key, value];
    return [self insert:insertSQL];
}

/// insert 공통
/// @param sql sql
-(BOOL)insert:(NSString*)sql {
    if (![self existDbFile]) {
        return NO;
    }
    
    // 디비 파일 오픈 실패
    if ([self open] != SQLITE_OK) {
        return NO;
    }
    
    @try {
        const char *query_stmt = [sql UTF8String];
        sqlite3_stmt *stmt;
        
        sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL);
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            // insert 성공
            sqlite3_finalize(stmt);
            [self close];
            return YES;
        } else {
            // insert 실패
            sqlite3_finalize(stmt);
            [self close];
            return NO;
        }
    } @catch (NSException *e) {
        return NO;
    }
    return YES;
}

#pragma mark Update

/// sring update. update는 insert에서 알아서 처리하기때문에, 외부에서 호출할 일 없음
/// @param value 값
/// @param key 키
/// @param index 인덱스
-(BOOL)updateString:(NSString*)value key:(NSString*)key index:(int)index {
    // 디비 오픈 성공
    NSString *querySQL = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@' WHERE %@=%d", TABLE_NAME, key, value, INDEX, 0];
    return [self update:querySQL];
}


/// insert update.  update는 insert에서 알아서 처리하기때문에, 외부에서 호출할 일 없음
/// @param value 값
/// @param key 키
/// @param index 인덱스
-(BOOL)updateInt:(int)value key:(NSString*)key index:(int)index {
    NSString *querySQL = [NSString stringWithFormat:@"UPDATE %@ SET %@=%d WHERE %@=%d", TABLE_NAME, key, value, INDEX, 0];
    return [self update:querySQL];
}

/// update
/// @param sql <#sql description#>
-(BOOL)update:(NSString*)sql {
    if (![self existDbFile]) {
        return NO;
    }
    
    // 디비 파일 오픈 실패
    if ([self open] != SQLITE_OK) {
        return NO;
    }
    
    @try {
        const char *query_stmt = [sql UTF8String];
        sqlite3_stmt *stmt;
        
        if( sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
            if(sqlite3_step(stmt) != SQLITE_DONE) {
                // update 실패
                sqlite3_finalize(stmt);
                [self close];
                return NO;
            }
            sqlite3_finalize(stmt);
        }
        [self close];
    } @catch(NSException *e) {
        return NO;
    }
    return YES;
}

#pragma mark Select

/// String 값 조회
-(NSString*)loadString:(NSString*)key index:(int)index {
    NSString* result = nil;
    if (![self existDbFile]) {
        return result;
    }
    
    // 디비 파일 오픈 실패
    if ([self open] != SQLITE_OK) {
        return result;
    }
    
    // 디비 파일 오픈 성공
    NSString *querySQL = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@=%d", key,TABLE_NAME, INDEX, index];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *stmt;
    
    if (sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
        NSString *result = @"";
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            @try {
                const char *value = sqlite3_column_text(stmt, 0);
                result = [NSString stringWithUTF8String:value];
                break;
            } @catch (NSException *e) {
            }
        }
        sqlite3_finalize(stmt);
    }
    [self close];
    return result;
}


/// Int 값 조회
-(int)loadInt:(NSString*)key index:(int)index {
    int result = -1;
    if (![self existDbFile]) {
        return result;
    }
    
    // 디비 파일 오픈 실패
    if ([self open] != SQLITE_OK) {
        return result;
    }
    NSString *querySQL = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@=%d", key,TABLE_NAME, INDEX, index];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *stmt;
    
    if (sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            @try {
                result = sqlite3_column_int(stmt, 0);
                break;
            } @catch (NSException *e) {
            }
        }
        sqlite3_finalize(stmt);
    }
    [self close];
    return result;
}

/// 인덱스 데이터 조회
-(NSMutableDictionary *)load:(int)index {
    if (![self existDbFile]) {
        return nil;
    }
    
    // 디비 파일 오픈 실패
    if ([self open] != SQLITE_OK) {
        return nil;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSString *querySQL = [NSString stringWithFormat:@"SELECT %@, %@, %@ FROM %@ WHERE %@=%d", INDEX, STRING_VALUE, INT_VALUE, TABLE_NAME, INDEX, index];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *stmt;
    
    if (sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            @try {
                int index = sqlite3_column_int(stmt, 0);
                const char *strVal = sqlite3_column_text(stmt, 1);
                int intVal = sqlite3_column_int(stmt, 2);
                
                dic[INDEX] = [NSString stringWithFormat:@"%d", index];
                dic[STRING_VALUE] = [NSString stringWithUTF8String:strVal];
                dic[INT_VALUE] = [NSString stringWithFormat:@"%d", intVal];
                
            } @catch (NSException *e) {
                return nil;
            }
        }
        sqlite3_finalize(stmt);
    }
    [self close];
    return dic;
}

#pragma mark - Delete

- (BOOL)deleteAt:(int)index {
    if (![self existDbFile]) {
        return NO;
    }
    
    // 디비 파일 오픈 실패
    if ([self open] != SQLITE_OK) {
        return NO;
    }
    
    NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=%d", TABLE_NAME, INDEX, index];
    const char *query_stmt = [querySQL UTF8String];
    char *errMsg;
    
    if (sqlite3_exec(_sql, query_stmt, NULL, NULL, &errMsg) == SQLITE_OK) {
        [self close];
    } else {
        [self close];
        return NO;
    }
    return YES;
}

- (BOOL)deleteAll {
    if (![self existDbFile]) {
        return NO;
    }
    
    // 디비 파일 오픈 실패
    if ([self open] != SQLITE_OK) {
        return NO;
    }
    
    NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM %@",TABLE_NAME];
    const char *query_stmt = [querySQL UTF8String];
    char *errMsg;
    
    if (sqlite3_exec(_sql, query_stmt, NULL, NULL, &errMsg) == SQLITE_OK) {
        [self close];
    } else {
        [self close];
        return NO;
    }
    return YES;
}


/// 저장된 데이터 있는지 조회
-(BOOL)isExist:(NSString *)key index:(int)index {
    NSString *querySQL = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@=%d", key, TABLE_NAME, INDEX, index];
    return [self isExist:querySQL];
}

/// 저장된 데이터 있는지 조회
-(BOOL)isExist:(NSString*)querySQL {
    // 디비 파일 오픈 실패
    if ([self open] != SQLITE_OK) {
        return NO;
    }
    
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *stmt;
    
    if (sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            // 가져온 값이 있음
            sqlite3_finalize(stmt);
            [self close];
            return YES;
        } else {
            // 가져온 값이 없음
            sqlite3_finalize(stmt);
            [self close];
            return NO;
        }
    }
    return NO;
}


#pragma mark - Etc

/// 모든 데이터 출력
-(void)printAllDbData {
    if (![self existDbFile]) {
        return;
    }
    
    // 디비 파일 오픈 실패
    if ([self open] != SQLITE_OK) {
        return;
    }
    NSString *querySQL = [NSString stringWithFormat:@"SELECT %@, %@, %@ FROM %@ ORDER BY %@ ASC", INDEX, STRING_VALUE, INT_VALUE, TABLE_NAME, INDEX];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *stmt;
    
    if (sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            @try {
                int index = sqlite3_column_int(stmt, 0);
                const char *strVal = sqlite3_column_text(stmt, 1);
                int intVal = sqlite3_column_int(stmt, 2);
                NSLog(@"index : %d / strVal : %s / intVal : %d", index, strVal, intVal);
            } @catch (NSException *e) {
            }
        }
        sqlite3_finalize(stmt);
    }
    [self close];
}

@end
