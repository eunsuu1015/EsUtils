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

-(id)initWithFileName:(NSString*)name;

-(NSString*)setFilePath:(NSString*)fileName;

-(BOOL)saveFile:(NSString*)value isAppend:(BOOL)isAppend;
-(BOOL)saveFileKey:(NSString*)key value:(NSString*)value isAppend:(BOOL)isAppend;

-(NSString*)loadFile;
-(NSString*)loadFileKey:(NSString*)key;


//-(void)existFile;
//-(NSString *)read;
//-(void)write:(NSString*)data;

@end

NS_ASSUME_NONNULL_END
