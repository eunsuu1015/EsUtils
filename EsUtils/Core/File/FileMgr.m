//
//  FileMgr.m
//  ViewCollect
//
//  Created by Authlabs on 2020/04/24.
//  Copyright © 2020 Authlabs. All rights reserved.
//

#import "FileMgr.h"

#define DEFAULT_FILE_NAME @"defaultFile.txt"    // 파일 이름을 지정하지 않았을 때 자동으로 사용함
#define DEFAULT_FILE_KEY @"defaultKey"      // 파일 키를 지정하지 않았을 때 자동으로 사용함

@implementation FileMgr
{
    NSString *filePath;
}



/// 파일명과 함께 초기화
/// @param name 파일 이름
-(id)initWithFileName:(NSString*)name {
    filePath = [self setFilePath:name];
    return self;
}


/// 파일 패스를 설정 으로 설정
-(NSString*)setFilePath:(NSString*)fileName {
    NSArray *array = [[NSArray alloc] initWithArray:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ];
    return [NSString stringWithFormat:@"%@/%@", [array objectAtIndex:0], fileName];
}

/// 파일에 데이터 저장
/// FILE은 초기화 시 설정한 파일 (없으면 default 파일)
/// @param key 저장 키
/// @param value 저장할 값
/// @param isAppend YES : 이전 데이터에 내용 추가, NO : 새로운 데이터로 덮기
-(BOOL)saveFileKey:(NSString*)key value:(NSString*)value isAppend:(BOOL)isAppend {
    
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
    BOOL result = [mutableData writeToURL:[NSURL fileURLWithPath:filePath] atomically:YES];
    NSLog(@"result : %d", result);
    
    return result;
}


/// DEFAULT_FILE_KEY에 값 저장
/// FILE은 초기화 시 설정한 파일 (없으면 default 파일)
/// @param value 저장할 값
/// @param isAppend YES : 이전 데이터에 내용 추가, NO : 새로운 데이터로 덮기
-(BOOL)saveFile:(NSString*)value isAppend:(BOOL)isAppend {
    
    if (filePath == nil) {
        filePath = [self setFilePath:DEFAULT_FILE_NAME];
    }
    
    NSMutableData* mutableData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
    
    if (isAppend) {
        NSString *beforeData = [self loadFileKey:DEFAULT_FILE_KEY];
        if (beforeData != nil) {
            value = [NSString stringWithFormat:@"%@\n%@", beforeData, value];
        }
    }
    
    // 파일에 저장
    [archiver encodeObject:value forKey:DEFAULT_FILE_KEY];
    [archiver finishEncoding];
    BOOL result = [mutableData writeToURL:[NSURL fileURLWithPath:filePath] atomically:YES];
    NSLog(@"result : %d", result);
    
    return result;
}


/// DEFAULT_FILE_KEY에서 값 가져옴
/// FILE은 초기화 시 설정한 파일 (없으면 default 파일)
-(NSString*)loadFile {
    if (filePath == nil) {
        filePath = [self setFilePath:DEFAULT_FILE_NAME];
    }
    
    NSData * strData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    NSKeyedUnarchiver *archiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:strData];
    
    if (archiver == nil) {
        NSLog(@"archiver == nil");
        return nil;
    }
    
    // 핸드폰번호가 등록되어있지 않으면 DEFAULT_PHONE_NUM(01000000001)으로 초기 정보 세팅한다.
    NSString *data = [archiver decodeObjectForKey:DEFAULT_FILE_KEY];
    [archiver finishDecoding];
    
    NSLog(@"return : %@", data);
    return data;
}


/// key에서 값 가져옴
/// FILE은 초기화 시 설정한 파일 (없으면 default 파일)
/// @param key 조회할 키
-(NSString*)loadFileKey:(NSString*)key {
    if (filePath == nil) {
        filePath = [self setFilePath:DEFAULT_FILE_NAME];
    }
    
    NSData * strData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    NSKeyedUnarchiver *archiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:strData];
    
    if (archiver == nil) {
        NSLog(@"archiver == nil");
        return nil;
    }
    
    // 핸드폰번호가 등록되어있지 않으면 DEFAULT_PHONE_NUM(01000000001)으로 초기 정보 세팅한다.
    NSString *data = [archiver decodeObjectForKey:key];
    [archiver finishDecoding];
    
    NSLog(@"return : %@", data);
    return data;
}



// 읽고 쓰기가 정상 작동 안함
/*
-(void)existFile {
    NSFileManager * filemgr;
    filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath :DEFAULT_FILE_NAME] == YES)
        NSLog (@"파일이 있습니다");
    else
        NSLog (@"파일을 찾을 수 없습니다");
}

-(void)fileDelete {
    NSFileManager * filemgr;
    
    filemgr = [NSFileManager defaultManager];
    
    if ([filemgr removeItemAtPath:DEFAULT_FILE_NAME error:nil] == YES)
        NSLog (@"제거 성공");
    else
        NSLog (@"제거 실패");
}

-(NSString *)read {
    NSFileManager *filemgr;
    NSData *databuffer;
    
    filemgr = [NSFileManager defaultManager];
    
    databuffer = [filemgr contentsAtPath:DEFAULT_FILE_NAME];
    NSString *str= [[NSString alloc] initWithData:databuffer encoding:NSUTF8StringEncoding];
    NSLog(@"result : %@", str);
    return str;

}

-(void)write:(NSString*)text {
    NSFileManager * filemgr;
    
    NSData *databuffer;
    
    filemgr = [NSFileManager defaultManager];
    databuffer = [filemgr contentsAtPath:DEFAULT_FILE_NAME];
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];

    
    
    BOOL result = [filemgr createFileAtPath:DEFAULT_FILE_NAME contents:data attributes: nil];
    NSLog(@"result : %d", result);
}
*/
//
//// 일반 파일 초기화
//// 파일이 없다면 생성까지가 초기화
//- (id)initWithFile:(NSString *)fileName
//{
//    self = [super init];
//    if(self != nil)
//    {
//
//    }
//
//    // FileManager를 생성
//    fileManager = [NSFileManager defaultManager];
//
//    //도큐먼트 디렉토리 위치를  얻는다.
//    documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    filePathAndName = [documentsDirectory stringByAppendingPathComponent:fileName];
//
//
//    if ([fileManager fileExistsAtPath: filePathAndName ] == YES)
//    {
//        NSLog (@"File exists");
//    }
//    else
//    {
//        NSLog (@"File not found");
//
//        // 파일 생성하기
//        NSData * dataBuffer = [Keychain stringToData:@""];
//        [fileManager createFileAtPath:filePathAndName contents:dataBuffer attributes:nil];
////        [fileManager writeto
//
//    }
//
//    return self;
//
//}
//
//
//
//
//#pragma mark - FileManager event
//
//
//- (void)createFile
//{
//    documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    // 경로를 읽어온다 / SQLite 함수는 동적으로 데이터베이스 여는 방법을 구분하지 않는다.
//    // 경로를 지정했을때 있으면 열고, 없으면 생성한다음에 연다.
////    filePathAndName = [documentsDirectory stringByAppendingPathComponent:fileName];
//
//    if ([fileManager fileExistsAtPath:filePathAndName ] == YES)
//    {
//        NSLog (@"File exists");
//    }
//    else
//    {
//        NSLog (@"File not found");
//
//        // 파일 생성하기
//        NSData * dataBuffer = [Keychain stringToData:@""];
//        [fileManager createFileAtPath:filePathAndName contents:dataBuffer attributes:nil];
//
//    }
//
//}
//
//
//- (void)deleteFile
//{
//
//    // FileManager에 있는 파일 삭제
//    if ([fileManager removeItemAtPath:filePathAndName error:NULL] == YES)
//    {
//        NSLog(@" Remove Success");
//    }
//    else
//    {
//        NSLog(@" Remove Fail");
//    }
//
//}
//
//
//- (void)textAddFile:(NSString *)text
//{
//    // 파일에 저장하기(쓰기)
//    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePathAndName];
//    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//    NSError *error;
//    if (error)
//    {
//        [fileHandle closeFile];
//        //          [delegate fileManagerFailWithError:error];
//    }
//    else
//    {
//        if (YES) // 이어서 저장하기
//        {
//            [fileHandle seekToEndOfFile];
//        }
//        else // 덮어쓰기
//        {
//            [fileHandle truncateFileAtOffset:0];
//        }
//        [fileHandle writeData:data];
//        [fileHandle closeFile];
//
//        //          [delegate fileManagerDidSaveText:text];
//
//    }
//
//
//}
//- (NSString *)readTextFile
//{
//
//    NSError *error;
//
//    // 파일 읽어오기
//    NSString *fileContents = [NSString stringWithContentsOfFile:filePathAndName encoding:NSUTF8StringEncoding error:&error];
//
//    if (error)
//        NSLog(@"Error reading file: %@", error.localizedDescription);
//
//    NSLog(@"contents: %@", fileContents);
//
//    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
//    NSLog(@"items = %lu", (unsigned long)[listArray count]);
//
//    return fileContents;
//
//
//}
//
//- (void)textUpdateFile:(NSString *)text
//{
//
//    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePathAndName];
//    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//
//    NSError *error;
//
//    if (error) {
//        [fileHandle closeFile];
//    } else {
//        if (NO) // 이어서 저장하기
//{
//            [fileHandle seekToEndOfFile];
//                    } else // 덮어쓰기
//        {
//            [fileHandle truncateFileAtOffset:0];
//        }
//        [fileHandle writeData:data];
//        [fileHandle closeFile];
//        //          [delegate fileManagerDidSaveText:text];
//    }
//}
//
//
//

@end
