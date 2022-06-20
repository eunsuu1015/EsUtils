//
//  FileMgr.m
//  ViewCollect
//
//  Created by ParkEunSu on 2020/04/24.
//  Copyright © 2020 ParkEunSu. All rights reserved.
//

#import "KeyedArchiverMgr.h"

#define DEFAULT_FILE_NAME @"defaultFile.txt"    // 파일 이름을 지정하지 않았을 때 자동으로 사용함
#define DEFAULT_FILE_KEY @"defaultKey"          // 파일 키를 지정하지 않았을 때 자동으로 사용함

@implementation KeyedArchiverMgr {
    NSString *filePath;
}

/// 파일명과 함께 초기화
-(id)initWithFileName:(NSString*)name {
    filePath = [self setFilePath:name];
    return self;
}

/// 파일 패스를 파일명으로 설정
-(NSString*)setFilePath:(NSString*)fileName {
    @try {
        NSArray *array = [[NSArray alloc] initWithArray:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ];
        return [NSString stringWithFormat:@"%@/%@", [array objectAtIndex:0], fileName];
        
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}


#pragma mark - Save

/// DEFAULT_FILE_KEY에 값 저장
/// FILE은 초기화 시 설정한 파일 (없으면 default 파일)
-(BOOL)saveFile:(NSString*)value isAppend:(BOOL)isAppend {
    return [self saveFileKey:DEFAULT_FILE_KEY value:value isAppend:isAppend];
}

/// 파일에 데이터 저장
/// FILE은 초기화 시 설정한 파일 (없으면 default 파일)
-(BOOL)saveFileKey:(NSString*)key value:(NSString*)value isAppend:(BOOL)isAppend {
    @try {
        if (filePath == nil) {
            filePath = [self setFilePath:DEFAULT_FILE_NAME];
        }
        NSMutableData* mutableData = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
        
        if (isAppend) {
            NSString *beforeData = [self loadFileKey:key];
            if (beforeData != nil) {
                value = [NSString stringWithFormat:@"%@\n%@", beforeData, value];
            }
        }
        
        // 파일에 저장
        [archiver encodeObject:value forKey:key];
        [archiver finishEncoding];
        return [mutableData writeToURL:[NSURL fileURLWithPath:filePath] atomically:YES];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return NO;
    }
}


#pragma mark - Load

/// DEFAULT_FILE_KEY에서 값 가져옴
/// FILE은 초기화 시 설정한 파일 (없으면 default 파일)
-(NSString*)loadFile {
    return [self loadFileKey:DEFAULT_FILE_KEY];
}

/// key에서 값 가져옴
/// FILE은 초기화 시 설정한 파일 (없으면 default 파일)
/// @param key 조회할 키
-(NSString*)loadFileKey:(NSString*)key {
    @try {
        if (filePath == nil) {
            filePath = [self setFilePath:DEFAULT_FILE_NAME];
        }
        
        NSData * strData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        NSKeyedUnarchiver *archiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:strData];
        
        if (archiver == nil) {
            return nil;
        }
        
        NSString *data = [archiver decodeObjectForKey:key];
        [archiver finishDecoding];
        return data;
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}

// TODO: key 형식 말고 일반적으로 파일 crud 하는 방법 추가

@end
