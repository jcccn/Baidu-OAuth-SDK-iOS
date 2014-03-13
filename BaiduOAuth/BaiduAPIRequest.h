//
//  BaiduAPIRequest.h
//  Baidu SDK
//
//  Created by xiawh on 12-9-25.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaiduAPIRequestDelegate;

/*
 * Open API请求类
 */
@interface BaiduAPIRequest : NSObject <NSURLConnectionDelegate>

/*
 * 发起Open API请求
 */
-(void)apiRequestWithUrl:(NSString *)requestUrl httpMethod:(NSString *)httpMethod params:(NSDictionary *)params andDelegate:(id<BaiduAPIRequestDelegate>)delegate;

@end


