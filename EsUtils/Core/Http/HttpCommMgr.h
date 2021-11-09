//
//  HttpCommManager.h
//  AllTestProj
//
//  Created by Authlabs on 04/11/2019.
//  Copyright © 2019 Authlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpCommMgr : NSObject

+(void)getLib:(NSString *)url header:(nullable NSDictionary*)header success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

//+(void)postLib

@end

NS_ASSUME_NONNULL_END
