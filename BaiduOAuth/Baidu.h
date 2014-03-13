//
//  Baidu.h
//  Baidu SDK
//
//  Created by xiawh on 12-9-25.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol BaiduAuthorizeDelegate;
@protocol BaiduAPIRequestDelegate;

/*
 * Baidu SDK的接口类
 */
@interface Baidu : NSObject

/*
 * 初始化Baidu SDK
 */
- (id)initWithAPIKey:(NSString *)apiKey appId:(NSString *)appId;

/*
 * 判断用户的授权状态
 */
- (BOOL)isUserSessionValid;

/*
 * 用户登录，进行授权
 */
- (void)authorizeWithTargetViewController:(UIViewController *)targetViewController scope:(NSString*)scope andDelegate:(id<BaiduAuthorizeDelegate>)delegate;

/*
 * 用户登出
 */
- (void)currentUserLogout;

/*
 * 调用Open API方法
 */
- (void)apiRequestWithUrl:(NSString *)requestUrl
               httpMethod:(NSString *)httpMethod
                   params:(NSDictionary *)params
              andDelegate:(id<BaiduAPIRequestDelegate>)delegate;
@end
