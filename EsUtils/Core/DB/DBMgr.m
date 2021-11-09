//
//  DBMgr.m
//  ViewCollect
//
//  Created by Authlabs on 2020/04/27.
//  Copyright © 2020 Authlabs. All rights reserved.
//

#import "DBMgr.h"

// 디비파일, 컬럼명 정의
const NSString *DB_NAME = @"DB_NAME.db";
const NSString *TABLE_NAME = @"TABLE_NAME";
const NSString *INDEX = @"_INDEX";
const NSString *STRING_VALUE = @"STRING_VALUE";
const NSString *INT_VALUE = @"INT_VALUE";

@implementation DBMgr


-(instancetype)init {
    
    if (self = [super init]) {
        
        NSLog(@"start#");
        
        NSString *docsDir;
        NSArray *dirPaths;
        
        // 디비 파일 경로 설정
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        
        // Build the path to the database file
        _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:DB_NAME]];
        
        [self makeDbFile];
        
        NSLog(@"end#");
    }
    return self;
}

/// 디비 오픈
/// 파일이 있다면, 파일을 연다.
/// 파일이 없다면, 파일 생성 후 파일을 연다.
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
    NSLog(@"start");
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: _databasePath ] == NO) {
        // 디비 파일 없음
        NSLog(@"return : NO");
        return NO;
    } else {
        NSLog(@"return : YES");
        return YES;
    }
}

/**
 * 디비 파일과 테이블 생성
 * @return  디비와 테이블 생성 결과
 */
-(BOOL) makeDbFile {
    NSLog(@"start#");
    @try {
        
        if ([self open] == SQLITE_OK) {
            NSLog(@"파일 생성 및 오픈 성공 (파일이 이미 있는 경우는 오픈 성공)");
            
            NSString *strCreate = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ VARCHAR(64),%@ INTEGER)",
                                   TABLE_NAME,
                                   INDEX,
                                   STRING_VALUE,
                                   INT_VALUE];
            //                NSString *strCreate = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY, %@ TEXT, %@ TEXT, %@ INTEGER, %@ TEXT, %@ TEXT, %@ TEXT)", TABLE_NAME, INDEX, ENC_AUTHKEY, ENC_AUTHDATA, INT_VALUE, RESERVED1, RESERVED2, RESERVED3];
            char *errMsg;
            const char *sql_stmt = [strCreate UTF8String];
            
            if (sqlite3_exec(_sql, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                // 디비 테이블 생성 실패
                NSLog(@"테이블 생성 실패");
                NSLog(@"return : NO");
                NSLog(@"errMsg : %s", errMsg);
                [self close];
                return NO;
            }
            [self close];
            
        } else {
            NSLog(@"파일 생성 또는 오픈 실패");
            return NO;
        }
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return NO;
    }
    
    return YES;
}


#pragma mark - 공통

#pragma mark  Insert

/// String 값 저장 (인덱스에 해당하는 값이 있으면 update, 없으면 insert)
/// @param value 값
/// @param key 키
/// @param index 인덱스
-(BOOL) insertString:(NSString *)value key:(NSString *)key index:(int)index {
    NSLog(@"[DEBUG] key : %@ / value : %@", key, value);
    
    sqlite3_stmt    *stmt;
    
    if ([self open] == SQLITE_OK) {
        // 디비 파일 오픈 성공
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@=%d", key, TABLE_NAME, INDEX, index];
        
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"[DEBUG] querySQL : %s", query_stmt);
        
        if (sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                // 가져온 값이 있으면 update 진행
                sqlite3_finalize(stmt);
                [self close];
                BOOL result = [self updateString:value key:key index:index];
                
                NSLog(@"[DEBUG] return %@ #", result ? @"Y" : @"N");
                return result;
            } else {
                // 가져온 값이 없으면 insert 진행
                @try {
                    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES (%d, '%@')", TABLE_NAME, INDEX, key, 0,  value];
                    NSLog(@"[DEBUG] insertSQL : %@", insertSQL);
                    const char *insert_stmt = [insertSQL UTF8String];
                    
                    sqlite3_prepare_v2(_sql, insert_stmt, -1, &stmt, NULL);
                    if (sqlite3_step(stmt) == SQLITE_DONE) {
                        // insert 성공
                        sqlite3_finalize(stmt);
                        [self close];
                        NSLog(@"return YES");
                        return YES;
                    } else {
                        // insert 실패
                        sqlite3_finalize(stmt);
                        [self close];
                        NSLog(@"return NO");
                        return NO;
                    }
                } @catch (NSException *e) {
                    NSLog(@"return NO");
                    return NO;
                }
            }
        }
    } else {
        // 디비 오픈 실패
        NSLog(@"return NO");
        return NO;
    }
    
    NSLog(@"return YES");
    return YES;
}

/// String 값 저장. 다음 인덱스에 무조건 저장
/// @param value 값
/// @param key 키
-(BOOL) insertString:(NSString *)value key:(NSString *)key {
    NSLog(@"[DEBUG]  key : %@ / value : %@", key, value);
    
    sqlite3_stmt    *stmt;
    
    if ([self open] == SQLITE_OK) {
        // 디비 파일 오픈 성공
        @try {
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES ('%@')", TABLE_NAME, key, value];
            NSLog(@"[DEBUG]  insertSQL : %@", insertSQL);
            const char *insert_stmt = [insertSQL UTF8String];
            
            sqlite3_prepare_v2(_sql, insert_stmt, -1, &stmt, NULL);
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                // insert 성공
                sqlite3_finalize(stmt);
                [self close];
                NSLog(@"return YES");
                return YES;
            } else {
                // insert 실패
                sqlite3_finalize(stmt);
                [self close];
                NSLog(@"return NO");
                return NO;
            }
        } @catch (NSException *e) {
            NSLog(@"return NO");
            return NO;
        }
        
    } else {
        // 디비 오픈 실패
        NSLog(@"return NO");
        return NO;
    }
    
    NSLog(@"return YES");
    return YES;
}

/// Int 값 저장 (인덱스에 해당하는 값이 있으면 update, 없으면 insert)
/// @param value 값
/// @param key 키
/// @param index 인덱스
-(BOOL) insertInt:(int)value key:(NSString *)key index:(int)index {
    sqlite3_stmt    *stmt;
    
    if ([self open] == SQLITE_OK) {
        // 디비 파일 오픈 성공
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@=%d", key, TABLE_NAME, INDEX, index];
        
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"[DEBUG]  querySQL : %s", query_stmt);
        
        if (sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                // 가져온 값이 있으면 update 진행
                sqlite3_finalize(stmt);
                [self close];
                BOOL result = [self updateInt:value key:key index:index];
                
                NSLog(@"[DEBUG]  return %@ #", result ? @"Y" : @"N");
                return result;
            } else {
                // 가져온 값이 없으면 insert 진행
                @try {
                    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES (%d, %d)", TABLE_NAME, INDEX, key, 0,  value];
                    NSLog(@"[DEBUG]  insertSQL : %@", insertSQL);
                    const char *insert_stmt = [insertSQL UTF8String];
                    
                    sqlite3_prepare_v2(_sql, insert_stmt, -1, &stmt, NULL);
                    if (sqlite3_step(stmt) == SQLITE_DONE) {
                        // insert 성공
                        sqlite3_finalize(stmt);
                        [self close];
                        NSLog(@"return YES");
                        return YES;
                    } else {
                        // insert 실패
                        sqlite3_finalize(stmt);
                        [self close];
                        NSLog(@"return NO");
                        return NO;
                    }
                } @catch (NSException *e) {
                    NSLog(@"return NO");
                    return NO;
                }
            }
        }
    } else {
        // 디비 오픈 실패
        NSLog(@"return NO");
        return NO;
    }
    
    NSLog(@"return YES");
    return YES;
}

/// Int 값 저장. 다음 인덱스에 무조건 저장
/// @param value 값
/// @param key 키
-(BOOL) insertInt:(int)value key:(NSString *)key {
    sqlite3_stmt    *stmt;
    
    if ([self open] == SQLITE_OK) {
        // 디비 파일 오픈 성공
        
                @try {
                    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES ( %d)", TABLE_NAME, key, value];
                    NSLog(@"[DEBUG]  insertSQL : %@", insertSQL);
                    const char *insert_stmt = [insertSQL UTF8String];
                    
                    sqlite3_prepare_v2(_sql, insert_stmt, -1, &stmt, NULL);
                    if (sqlite3_step(stmt) == SQLITE_DONE) {
                        // insert 성공
                        sqlite3_finalize(stmt);
                        [self close];
                        NSLog(@"return YES");
                        return YES;
                    } else {
                        // insert 실패
                        sqlite3_finalize(stmt);
                        [self close];
                        NSLog(@"return NO");
                        return NO;
                    }
                } @catch (NSException *e) {
                    NSLog(@"return NO");
                    return NO;
                }
    } else {
        // 디비 오픈 실패
        NSLog(@"return NO");
        return NO;
    }
    
    NSLog(@"return YES");
    return YES;
}


#pragma mark Update

/// update는 insert에서 알아서 처리하기때문에, 외부에서 호출할 일 없음
/// @param value 값
/// @param key 키
/// @param index 인덱스
-(BOOL)updateString:(NSString*)value key:(NSString*)key index:(int)index {
    
    NSLog(@"[DEBUG]  key : %@ / value : %@", key, value);
    
    if([self open] == SQLITE_OK) {
        // 디비 오픈 성공
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@' WHERE %@=%d", TABLE_NAME, key, value, INDEX, 0];
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"[DEBUG]  querySQL : %s", query_stmt);
        sqlite3_stmt *stmt;
        
        @try {
            if( sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
                if(sqlite3_step(stmt) != SQLITE_DONE) {
                    // update 실패
                    sqlite3_finalize(stmt);
                    [self close];
                    NSLog(@"return NO");
                    return NO;
                }
                sqlite3_finalize(stmt);
            }
            [self close];
        } @catch(NSException *e) {
            NSLog(@"return NO");
            return NO;
        }
        
    } else {
        // 디비 오픈 실패
        NSLog(@"return NO");
        return NO;
    }
    
    NSLog(@"return YES");
    return YES;
}


-(BOOL)updateInt:(int)value key:(NSString*)key index:(int)index {
    if([self open] == SQLITE_OK) {
        // 디비 오픈 성공
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE %@ SET %@=%d WHERE %@=%d", TABLE_NAME, key, value, INDEX, 0];
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"[DEBUG]  querySQL : %s", query_stmt);
        sqlite3_stmt *stmt;
        
        @try {
            if( sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
                if(sqlite3_step(stmt) != SQLITE_DONE) {
                    // update 실패
                    sqlite3_finalize(stmt);
                    [self close];
                    NSLog(@"return NO");
                    return NO;
                }
                sqlite3_finalize(stmt);
            }
            [self close];
        } @catch(NSException *e) {
            NSLog(@"return NO");
            return NO;
        }
        
    } else {
        // 디비 오픈 실패
        NSLog(@"return NO");
        return NO;
    }
    
    NSLog(@"return YES");
    return YES;
}




#pragma mark Select

-(NSString*) loadString:(NSString*)key index:(int)index {
    sqlite3_stmt    *stmt;
    
    if ([self open] == SQLITE_OK) {
        // 디비 파일 오픈 성공
        NSString *querySQL = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@=%d", key,TABLE_NAME, INDEX, index];
        
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"[DEBUG]  querySQL : %s", query_stmt);
        
        if (sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
            NSString *getValue = @"";
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                @try {
                    const char *value = sqlite3_column_text(stmt, 0);
                    getValue = [NSString stringWithFormat:@"%s", value];
                } @catch (NSException *e) {
                }
            }
            sqlite3_finalize(stmt);
            [self close];
            if (getValue != nil) {
                NSLog(@"[DEBUG]  return : %@", getValue);
                return getValue;
            }
        }
        [self close];
    } else {
        // 디비 오픈 실패
    }
    
    NSLog(@"return nil");
    return nil;
}


-(int) loadInt:(NSString*)key index:(int)index {
    sqlite3_stmt    *stmt;
    
    if ([self open] == SQLITE_OK) {
        // 디비 파일 오픈 성공
        NSString *querySQL = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@=%d", key,TABLE_NAME, INDEX, index];
        const char *query_stmt = [querySQL UTF8String];
        NSLog(@"[DEBUG]  querySQL : %s", query_stmt);
        
        if (sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
            
            int value = -1;
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                @try {
                    value = sqlite3_column_int(stmt, 0);
                } @catch (NSException *e) {
                }
            }
            sqlite3_finalize(stmt);
            [self close];
            NSLog(@"[DEBUG]  getValue : %d", value);
            return value;
        }
        [self close];
    } else {
        // 디비 오픈 실패
    }
    
    NSLog(@"return -1");
    return -1;
}



#pragma mark - Insert


-(BOOL) insert:(NSString*)strVal intVal:(int)intVal {
    
    // string nil
    if (strVal == nil) {
        NSLog(@"파라미터값은 nil이거나 공백이 아니어야 합니다");
        NSLog(@"return N#");
        return NO;
    }
    
    // 200121 디비 파일 체크 함수 따로 뺌
    if (![self existDbFile]) {
        return NO;
    }
    
    sqlite3_stmt    *stmt;
    
    if ([self open] == SQLITE_OK) {
        // 디비 오픈 성공
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES (\"%@\", %d)",
                               TABLE_NAME, STRING_VALUE, INT_VALUE, strVal, intVal];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(_sql, insert_stmt, -1, &stmt, NULL);
        
        @try {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                // insert 성공
                sqlite3_finalize(stmt);
                [self close];
                
                NSLog(@"return : Y#");
                return YES;
            } else {
                // insert 실패
                sqlite3_finalize(stmt);
                [self close];
                NSLog(@"return : N#");
                return NO;
            }
        } @catch (NSException *e) {
            NSLog(@"return : N #");
            return NO;
        }
        
    } else {
        // 디비 오픈 실패
        NSLog(@"return : N#");
        return NO;
    }
    
    NSLog(@"end#");
    return YES;
}


#pragma mark - Update

/**
 * 디비에 데이터 갱신
 * @param   index       디비 index
 * @param   intVal    intVal
 * @return  update 결과
 */

-(BOOL) update:(NSString*)strVal intVal:(int)intVal index:(int)index {
    
    if (strVal == nil) {
        NSLog(@"uid 값은 nil이거나 공백이 아니어야 합니다");
        NSLog(@"return N#");
        return NO;
    }
    
    // 200121 디비 파일 체크 함수 따로 뺌
    if (![self existDbFile]) {
        return NO;
    }
    NSLog(@"디비에 가져온 Method, Uid == 파라미터로 받은 Method, Uid");
    if([self open] == SQLITE_OK) {
        // 디비 오픈 성공
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE %@ SET %@=\"%@\", %@=%d WHERE %@=%d", TABLE_NAME, STRING_VALUE, strVal, INT_VALUE, intVal, INDEX, index];
        
        const char *sql = [querySQL UTF8String];
        sqlite3_stmt *stmt;
        
        @try {
            if( sqlite3_prepare_v2(_sql, sql, -1, &stmt, NULL) == SQLITE_OK) {
                
                if (sqlite3_step(stmt) != SQLITE_DONE) {
                    sqlite3_finalize(stmt);
                    [self close];
                    
                    // 업데이트 실패
                    NSLog(@"return : N#");
                    return NO;
                }
                sqlite3_finalize(stmt);
            }
            [self close];
            
        } @catch(NSException *e) {
            NSLog(@"return : N #");
            return NO;
        }
    } else {
        // 디비 오픈 실패
        NSLog(@"return : N#");
        return NO;
    }
    
    NSLog(@"return : Y#");
    return YES;
}



#pragma mark - Select


/**
 * 디비에서 데이터 가져오기
 * @param   index       디비 index
 * @return  가져온 데이터 dictionary
 */
-(NSMutableDictionary *) load:(int)index {
    NSLog(@"start#");
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *stmt;
    
    // 200121 디비 파일 체크 함수 따로 뺌
    if (![self existDbFile]) {
        return nil;
    }
    
    if ([self open] == SQLITE_OK) {
        // 디비 오픈 성공
        NSString *querySQL = [NSString stringWithFormat:@"SELECT %@, %@, %@ FROM %@ WHERE %@=%d", INDEX, STRING_VALUE, INT_VALUE, TABLE_NAME, INDEX, index];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                @try {
                    int index = sqlite3_column_int(stmt, 0);
                    const char *strVal = sqlite3_column_text(stmt, 1);
                    int intVal = sqlite3_column_int(stmt, 2);
                    
                    dic[STRING_VALUE] = [NSString stringWithFormat:@"%s", strVal];
                    dic[INT_VALUE] = [NSString stringWithFormat:@"%d", intVal];
                    
                } @catch (NSException *e) {
                    NSLog(@"return nil#");
                    return nil;
                }
            }
            sqlite3_finalize(stmt);
        }
        [self close];
        
    } else {
        // 디비 오픈 실패
    }
    
    if (dic.count == 0 || dic == nil) {
        NSLog(@"return nil#");
        return nil;
    }
    
    NSLog(@"return : %@#", dic);
    NSLog(@"end#");
    return dic;
}



#pragma mark - Etc

-(void) printAllDbData {
    NSLog(@"start#");
    sqlite3_stmt    *stmt;
    
    // 200121 디비 파일 체크 함수 따로 뺌
    if (![self existDbFile]) {
        return;
    }
    
    if ([self open] == SQLITE_OK) {
        // 디비 파일 오픈 성공
        NSString *querySQL = [NSString stringWithFormat:@"SELECT %@, %@, %@ FROM %@ ORDER BY %@ ASC", INDEX, STRING_VALUE, INT_VALUE, TABLE_NAME, INDEX];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_sql, query_stmt, -1, &stmt, NULL) == SQLITE_OK) {
            NSLog(@"========== query 조회 시작");
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                @try {
                    int index = sqlite3_column_int(stmt, 0);
                    const char *strVal = sqlite3_column_text(stmt, 1);
                    int intVal = sqlite3_column_int(stmt, 2);
                    NSLog(@"\nindex : %d / strVal : %s / intVal : %d", index, strVal, intVal);
                } @catch (NSException *e) {
                    NSLog(@"return : nil#");
                }
            }
            NSLog(@"========== query 조회 끝");
            sqlite3_finalize(stmt);
        }
        [self close];
    } else {
        // 디비 오픈 실패
    }
    
    NSLog(@"end#");
}


@end
