//
//  FileMgr.m
//  EsUtils
//
//  Created by ParkEunSu on 2022/06/20.
//  Copyright © 2022 ParkEunSu. All rights reserved.
//

#import "FileMgr.h"

@implementation FileMgr


#pragma mark - Image

/// 이미지 파일 저장
/// @param image 이미지
/// @param fileName 파일명 (확장자 미포함 시 jpg로 강제 설정)
- (BOOL)saveImage:(UIImage *)image fileName:(NSString *)fileName {
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData == nil) {
        NSLog(@"imageData == nil");
        return false;
    }
    
    fileName = [self addJpgExtension:fileName];
    return [self saveData:imageData fileName:fileName];
}

/// 저장된 이미지 파일 가져오기
/// @param fileName 이미지 파일명 (확장자 미포함 시 jpg로 강제 설정)
- (UIImage *)getImage:(NSString *)fileName {
    fileName = [self addJpgExtension:fileName];
    NSString *directory = [self getFileURLString:fileName];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:directory];
    if (image == nil) {
        NSLog(@"image == nil");
        return false;
    }
    return image;
}

/// 이미지 파일 삭제
/// @param fileName 이미지 파일명 (확장자 미포함 시 jpg로 강제 설정)
- (BOOL)removeImage:(NSString *)fileName {
    fileName = [self addJpgExtension:fileName];
    return [self removeData:fileName];
}

#pragma mark - Common

/// 파일 저장
/// @param data 저장할 데이터
/// @param fileName 파일명 (확장자 포함)
- (BOOL)saveData:(NSData *)data fileName:(NSString *)fileName {
    NSURL *fileURL = [self getFileURL:fileName];
    
    NSError *error;
    BOOL result = [data writeToURL:fileURL options:nil error:&error];
    if (result) {
        NSLog(@"파일 저장 성공");
    } else {
        NSLog(@"파일 저장 실패");
        return false;
    }
    
    return true;
}

/// 저장된 파일 가져오기
/// @param fileName 파일명 (확장자 포함)
- (NSData *)getData:(NSString *)fileName {
    NSURL *directory = [self getFileURL:fileName];
    NSData *data = [[NSData alloc] initWithContentsOfURL:directory];
    return data;
}

/// 파일 삭제
- (BOOL)removeData:(NSString *)fileName {
    NSError *error;
    NSString *fileURL = [self getFileURLString:fileName];
    if ([NSFileManager.defaultManager fileExistsAtPath:fileURL]) {
        [NSFileManager.defaultManager removeItemAtPath:fileURL error:&error];
        if (error) {
            NSLog(@"error : %@", error);
            return false;
        }
    }
    return true;
}

#pragma mark - get URL

/// Document URL 가져오기
- (NSURL *)getDocumentURL {
    NSError *error;
    NSURL *documentURL = [NSFileManager.defaultManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:false error:&error];
    if (error) {
        NSLog(@"error : %@", error);
        return nil;
    }
    return documentURL;
}

/// fileName으로 전체 document 경로 URL로 가져오기
/// @param fileName 파일 네임 (확장자명 포함)
- (NSURL *)getFileURL:(NSString *)fileName {
    NSURL *directory = [self getDocumentURL];
    return [[NSURL fileURLWithPath:directory.absoluteString] URLByAppendingPathComponent:fileName];
}

/// fileName으로 전체 document 경로 String으로 가져오기
/// @param fileName 파일 네임 (확장자명 포함)
- (NSString *)getFileURLString:(NSString *)fileName {
    NSURL *directory = [self getDocumentURL];
    return [[NSURL fileURLWithPath:directory.absoluteString] URLByAppendingPathComponent:fileName].path;
}


#pragma mark - Extension (확장자)

/// jpg 확장자 추가
- (NSString *)addJpgExtension:(NSString *)fileName {
    if (![self isExistExtension:fileName]) {
        fileName = [NSString stringWithFormat:@"%@.jpg", fileName];
    }
    return fileName;
}

/// txt 확장자 추가
- (NSString *)addTxtExtension:(NSString *)fileName {
    if (![self isExistExtension:fileName]) {
        fileName = [NSString stringWithFormat:@"%@.txt", fileName];
    }
    return fileName;
}

/// 확장자 삭제
- (NSString *)removeExtension:(NSString *)fileName {
    if ([self isExistExtension:fileName]) {
        NSArray *arr = [fileName componentsSeparatedByString:@"."];
        fileName = arr[0];
    }
    return fileName;
}

/// 확장자 있는지 유무
- (BOOL)isExistExtension:(NSString *)fileName {
    return [fileName containsString:@"."];
}

#pragma mark - 폴더 추가

- (BOOL)makeDirectory:(NSString *)directoryName {
    //document 경로
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // 파일 이름인데 경로로 지정해서 폴더를 생성
    NSString *destinationPath = [documentDirectory stringByAppendingFormat:@"/%@", directoryName];
    
    NSFileManager *fm = [[NSFileManager alloc]init];
    
    //파일이 있고, 기록 가능한지 확인
    if ([fm isWritableFileAtPath:destinationPath]) {
        NSLog(@"%@ 폴더는 존재합니다." , destinationPath);
        
    } else {
        //존재하지 않을경우 생성
        NSError *error = nil;
        
        if ([fm createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"폴더 생성 성공");
        } else {
            NSLog(@"폴더 생성 실패");
            return false;
        }
    }
    return true;
}

@end
