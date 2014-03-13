//
//  BaiduConfig.h
//  Baidu SDK
//
//  Created by xiawh on 12-9-25.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//


#import <Foundation/Foundation.h>

/*
 * 共通的配置类
 */
@interface BaiduConfig : NSObject

/*
 * 应用的API Key
 */
@property (nonatomic,copy)NSString *apiKey;

/*
 * 应用的APP ID
 */
@property (nonatomic,copy)NSString *appId;

/*
 * SDK的版本
 */
@property (nonatomic,readonly)NSString *sdkVersion;

/*
 * 取得配置类的共享对象
 */
+(BaiduConfig*)shareConfig;

/*
 * 销毁配置类的共享对象
 */
+(void)destroyConfig;

@end
