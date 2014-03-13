//
//  BaiduError.h
//  Baidu SDK
//
//  Created by Xiawh on 12-9-25.
//  Copyright 2012年 Baidu. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 * 返回错误信息构建的错误对象.
 */
@interface BaiduError : NSError{
    
}
/**
 * 返回由OAuth接口返回错误信息构建的错误对象.
 */
+ (BaiduError*)errorWithOAuthResult:(NSDictionary*)result;

/**
 * 返回由OPenAPI接口错误信息构建的错误对象.
 */
+ (BaiduError*)errorWithOpenAPIInfo:(NSDictionary*)restInfo;

- (NSString *)localizedDescription;

@end
