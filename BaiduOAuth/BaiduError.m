//
//  BaiduError.m
//  Baidu SDK
//
//  Created by Xiawh on 12-9-25.
//  Copyright 2012年 Baidu. All rights reserved.
//

#import "BaiduError.h"
#import "BaiduMacroDef.h"

#define BDAUTHORIZE_ERRORDOMAIN             @"Baidu Open-platform OAuth 2.0"
#define BDOPENAPI_ERRORDOMAIN               @"Baidu Open-platform Open API 2.0"
#define BDAUTHORIZE_ERRORCODE               99999999

@interface BaiduError()

@property(nonatomic,copy)NSString* developerDescription;

@end

@implementation BaiduError

+ (BaiduError*)errorWithOAuthResult:(NSDictionary*)result
{
    NSString* errorReason = [result objectForKey:@"error"];
    NSString* errorMessage = [result objectForKey:@"error_description"];
    NSMutableDictionary* errorInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
    if (errorReason) {
        [errorInfo setObject:errorReason forKey:@"error"];
    }
    if (errorMessage) {
        [errorInfo setObject:errorMessage forKey:@"error_msg"];
    }
    BaiduError* error = [BaiduError errorWithDomain:BDAUTHORIZE_ERRORDOMAIN code:BDAUTHORIZE_ERRORCODE userInfo:errorInfo];
    error.developerDescription = errorMessage;
    [errorInfo release];
    return error;
}

+ (BaiduError*)errorWithOpenAPIInfo:(NSDictionary*)restInfo {
    
    NSString* errorCode = [restInfo objectForKey:@"error_code"];
    NSString* errorMessage = [restInfo objectForKey:@"error_msg"];
    NSMutableDictionary* errorInfo = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    if (errorMessage) {
        [errorInfo setObject:errorMessage forKey:@"error_msg"];
    }
    
    BaiduError* error = [BaiduError errorWithDomain:BDOPENAPI_ERRORDOMAIN code:[errorCode intValue] userInfo:errorInfo];
    error.developerDescription = errorMessage;
    [errorInfo release];
	return error;
}

- (NSString *)localizedDescription
{
    NSString *description = [super localizedDescription];
    
    if (self.developerDescription != nil) {
        return self.developerDescription;
    }
    return description;
}

-(void)dealloc
{
    self.developerDescription = nil;
    [super dealloc];
}

@end
