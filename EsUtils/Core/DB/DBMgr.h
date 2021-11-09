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

@interface DBMgr : NSObject

// 데이터베이스 경로
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *sql;


-(instancetype)init;

#pragma mark - 공통
-(BOOL) insertString:(NSString *)value key:(NSString *)key index:(int)index;
-(BOOL) insertString:(NSString *)value key:(NSString *)key;
-(BOOL) insertInt:(int)value key:(NSString *)key index:(int)index;
-(BOOL) insertInt:(int)value key:(NSString *)key;
-(NSString*) loadString:(NSString*)key index:(int)index;
-(int) loadInt:(NSString*)key index:(int)index;

#pragma mark -
-(BOOL) insert:(NSString*)strVal intVal:(int)intVal;
-(NSMutableDictionary *) load:(int)index;

#pragma mark - Etc
-(void) printAllDbData;

@end

NS_ASSUME_NONNULL_END
