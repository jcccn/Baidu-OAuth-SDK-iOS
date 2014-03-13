//
//  BDMacroDef.h
//  Baidu SDK
//
//  Created by xiawh on 12-9-25.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

//#define BDAUTHORIZE_HOSTURL                 @"http://dbl-chunlei-rd26.vm.baidu.com:8080/oauth/2.0/authorize"
//#define BDAUTHORIZE_REDIRECTURI             @"http://dbl-chunlei-rd26.vm.baidu.com:8080/oauth/2.0/login_redirect"

#define BDAUTHORIZE_HOSTURL                 @"https://openapi.baidu.com/oauth/2.0/authorize"
#define BDAUTHORIZE_REDIRECTURI             @"https://openapi.baidu.com/oauth/2.0/login_redirect"

//发版前必做:将log开关关掉
//#define BDLog_DEBUG

#ifndef BDLog_DEBUG
#define BDLog(message, ...)
#else
#define BDLog(message, ...) NSLog(@"[Baidu]:%@", [NSString stringWithFormat:message, ##__VA_ARGS__])
#endif