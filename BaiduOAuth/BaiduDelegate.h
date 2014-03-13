//
//  BaiduDelegate.h
//  Baidu SDK
//
//  Created by xiawh on 12-9-25.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 授权的代理
 */
@protocol BaiduAuthorizeDelegate <NSObject>

/*
 * 授权成功
 */
- (void)loginDidSuccess;

/*
 * 取消授权
 */
- (void)loginDidCancel;

/*
 * 授权发生错误
 */
- (void)loginFailedWithError:(NSError*)error;

@end

/*
 * API请求的代理
 */
@protocol BaiduAPIRequestDelegate <NSObject>

/*
 * API请求成功并返回请求结果
 */
- (void)apiRequestDidFinishLoadWithResult:(id)result;

/*
 * API请求发生错误
 */
- (void)apiRequestDidFailLoadWithError:(NSError*)error;

@end