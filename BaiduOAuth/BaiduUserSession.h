//
//  BaiduUserSession.h
//  Baidu SDK
//
//  Created by xiawh on 12-9-25.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 销毁用户授权信息管理类的共享对象
 */
@interface BaiduUserSession : NSObject

/*
 * 令牌
 */
@property (nonatomic,readonly)NSString *accessToken;

/*
 * 授予的权限列表
 */
@property (nonatomic,readonly)NSString *scope;

/*
 * 授予用户的sessionKey和Secret
 */
@property (nonatomic,readonly)NSString *sessionKey;
@property (nonatomic,readonly)NSString *sessionSecret;

/*
 * 过期日期
 */
@property (nonatomic,readonly)NSDate *expiresIn;

/*
 * 保存用户授权信息
 */
-(void)saveUserSessionInfo:(NSDictionary *)sessionInfo;

/*
 * 用户登出，删除用户授权信息
 */
-(void)logout;

/*
 * 判断用户授权信息是否有效
 */
-(BOOL)isUserSessionValid;

@end
