//
//  BaiduAPIRequest.m
//  Baidu SDK
//
//  Created by xiawh on 12-9-25.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import "BaiduAPIRequest.h"
#import "BaiduUtility.h"
#import "JSONKit.h"
#import "BaiduError.h"
#import "BaiduDelegate.h"
#import "BaiduMacroDef.h"
#import "BaiduConfig.h"
#import "BaiduError.h"

static const NSString* kStringBoundary = @"3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3";
static const NSTimeInterval kTimeoutInterval = 60.0;
static const NSString* kUserAgent = @"Baidu iOS SDK";

@interface BaiduAPIRequest()

@property (nonatomic,retain)NSURLConnection *connection;
@property (nonatomic,retain)NSMutableData *responseData;
@property (nonatomic,assign)id<BaiduAPIRequestDelegate> delegate;

- (BOOL)isKindOfUploadFile:(NSDictionary *)params;
- (NSMutableData *)generateFilePostBody:(NSDictionary *)params;
- (NSMutableData *)generateNoFilePostBody:(NSDictionary *)params;
- (NSString*)serializeURL:(NSString *)baseUrl params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;

@end


@implementation BaiduAPIRequest
@synthesize connection = _connection;
@synthesize responseData = _responseData;
@synthesize delegate = _delegate;

-(void)apiRequestWithUrl:(NSString *)requestUrl httpMethod:(NSString *)httpMethod params:(NSDictionary *)params andDelegate:(id<BaiduAPIRequestDelegate>)delegate
{
    self.delegate = delegate;
    
    if ( requestUrl == nil || [requestUrl isEqualToString:@""] || ![requestUrl hasPrefix:@"https://"]) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(apiRequestDidFailLoadWithError:)]) {
            NSDictionary *errorDic = [NSDictionary dictionaryWithObjectsAndKeys:@"request url is invalid!",@"error_msg",
                                      @"99999999",@"error_code", nil];
            BaiduError *error = [BaiduError errorWithOpenAPIInfo:errorDic];
            [self.delegate apiRequestDidFailLoadWithError:error];
            return;
        }
    }
    NSString *url = [self serializeURL:requestUrl params:params httpMethod:httpMethod];
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kTimeoutInterval];
    
	[urlRequest setHTTPMethod:httpMethod];
    UIDevice *device = [UIDevice currentDevice];
    NSString *ua = [NSString stringWithFormat:@"%@ %@(%@; %@ %@)",kUserAgent,[BaiduConfig shareConfig].sdkVersion,device.model,device.systemName,device.systemVersion];
    [urlRequest setValue:ua forHTTPHeaderField:@"User-Agent"];
	
    if ([httpMethod isEqualToString:@"POST"]) {
        if ([self isKindOfUploadFile:params]) {
            NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
            [urlRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
            NSData *body = [self generateFilePostBody:params];
            [urlRequest setHTTPBody:body];
        } else {
            NSData *body = [self generateNoFilePostBody:params];
            [urlRequest setHTTPBody:body];
        }
    }
    
    self.connection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
    return;
}

-(BOOL)isKindOfUploadFile:(NSDictionary *)params
{
    BOOL isKind = NO;
    for (NSString *key in [params keyEnumerator]) {
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[UIImage class]] || [value isKindOfClass:[NSData class]]) {
            isKind = YES;
            break;
        }
	}
	return isKind;
}

- (NSMutableData *)generateFilePostBody:(NSDictionary *)params
{
	NSMutableData *body = [NSMutableData data];
	NSString *endLine = [NSString stringWithFormat:@"\r\n--%@\r\n", kStringBoundary];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    for(NSString *key in [params keyEnumerator]){
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[UIImage class]] || [value isKindOfClass:[NSData class]]) {
            [dataDictionary setObject:value forKey:key];
            continue;
        }
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[params valueForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([dataDictionary count] > 0)
    {
        for (NSString *key in [dataDictionary keyEnumerator]) {
            id value = [params objectForKey:key];
            if ([value isKindOfClass:[UIImage class]])
            {
                UIImage *imageParam=(UIImage *)value;
                NSData *imageData = UIImagePNGRepresentation(imageParam);
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"file.png\"\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Type: image/png\r\nContent-Transfer-Encoding: binary\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
                
            } else {
                NSData *data = (NSData *)value;
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Type: content/unknown\r\nContent-Transfer-Encoding: binary\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:data];
            }
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--", kStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }

    return body;
}

- (NSMutableData *)generateNoFilePostBody:(NSDictionary *)params
{
	NSMutableData *body = [NSMutableData data];
    NSMutableArray *pairs = [NSMutableArray array];
   
    for (NSString* key  in [params keyEnumerator]) {
        NSString* value = [params objectForKey:key];
        NSString* value_str = [BaiduUtility encodeString:value urlEncode:NSUTF8StringEncoding];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value_str]];
    }
    NSString* postParams = [pairs componentsJoinedByString:@"&"];
    [body appendData:[postParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}

- (NSString*)serializeURL:(NSString *)baseUrl params:(NSDictionary *)params httpMethod:(NSString *)httpMethod{
    NSURL* parsedURL = [NSURL URLWithString:baseUrl];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator]) {
        if (([[params valueForKey:key] isKindOfClass:[UIImage class]])
            ||([[params valueForKey:key] isKindOfClass:[NSData class]])) {
            if ([httpMethod isEqualToString:@"GET"]) {
                BDLog(@"can not use GET to upload a file");
            }
            continue;
        }
        
        NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,/* allocator */ (CFStringRef)[params objectForKey:key], NULL, /* charactersToLeaveUnescaped */ (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        [escaped_value release];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[[NSMutableData alloc] init] autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    JSONDecoder *jsonParser = [JSONDecoder decoder];
    id result = [jsonParser objectWithData:self.responseData];
    
    self.responseData = nil;
    self.connection = nil;
    if (![result isKindOfClass:[NSArray class]]) {
        NSString *errorCode = [result objectForKey:@"error_code"];
        if ( errorCode != nil) {
            BaiduError *error = [BaiduError errorWithOpenAPIInfo:result];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(apiRequestDidFailLoadWithError:)]) {
                [self.delegate apiRequestDidFailLoadWithError:error];
            }
        } else {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(apiRequestDidFinishLoadWithResult:)]) {
                [self.delegate apiRequestDidFinishLoadWithResult:result];
            }
        }
    } else {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(apiRequestDidFinishLoadWithResult:)]) {
            [self.delegate apiRequestDidFinishLoadWithResult:result];
        }
    }
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.responseData = nil;
    self.connection = nil;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(apiRequestDidFailLoadWithError:)]) {
        [self.delegate apiRequestDidFailLoadWithError:error];
    }
}


-(void)dealloc
{
    [self.connection cancel];
    self.connection = nil;
    self.responseData = nil;
    [super dealloc];
}

@end
