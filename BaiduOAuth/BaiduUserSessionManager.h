//
//  BaiduUserSessionManager.h
//  Baidu SDK
//
//  Created by xiawh on 12-9-25.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduUserSession.h"

/*
 * 用户授权信息管理类
 */
@interface BaiduUserSessionManager : NSObject

/*
 * 取得用户授权信息管理类的共享对象
 */
+(BaiduUserSessionManager*)shareUserSessionManager;

/*
 * 销毁用户授权信息管理类的共享对象
 */
+(void)destroyUserSessionManager;

/*
 * 当前用户的授权信息
 */
@property(nonatomic,retain)BaiduUserSession *currentUserSession;

@end
