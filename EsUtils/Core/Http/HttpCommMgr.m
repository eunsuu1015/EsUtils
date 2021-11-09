//
//  HttpCommManager.m
//  AllTestProj
//
//  Created by Authlabs on 04/11/2019.
//  Copyright © 2019 Authlabs. All rights reserved.
//

#import "HttpCommMgr.h"
#import "AFHTTPSessionManager.h"


#import "Utils.h"
#import "JsonMgr.h"
#import "HttpOsMgr.h"
#import "HttpLibMgr.h"


@implementation HttpCommMgr


static int TIME_OUT = 10.0;

#pragma mark - AFNetworking Http

+ (void)getLib:(NSString *)url header:(nullable NSDictionary*)header success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    [HttpLibMgr performGet:url header:header success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+(void)postLib:(NSString*)url param:(NSString*)param header:(nullable NSDictionary*)header  success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    [HttpLibMgr performPost:url parameters:param isJson:NO header:header success:^(id  _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

#pragma mark - Os

//+(void)postOs:(NSString*)url paramters:(




@end
