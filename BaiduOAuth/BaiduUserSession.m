//
//  BaiduUserSession.m
//  Baidu SDK
//
//  Created by xiawh on 12-9-25.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import "BaiduUserSession.h"
#import "BaiduUtility.h"
#import "BaiduMacroDef.h"

#define BDAUTHORIZE_USERSESSION_STOREKEY    @"BaiduUserSession"

@interface BaiduUserSession()

-(void)stroeUserSessionInfo;

@end

@implementation BaiduUserSession
@synthesize accessToken = _accessToken;
@synthesize scope = _scope;
@synthesize sessionKey = _sessionKey;
@synthesize sessionSecret = _sessionSecret;
@synthesize expiresIn = _expiresIn;

-(id)init
{
    if (self = [super init]) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sessionInfo = [defaults objectForKey:BDAUTHORIZE_USERSESSION_STOREKEY];
        _accessToken = [[sessionInfo objectForKey:@"access_token"] copy];
        _scope = [[sessionInfo objectForKey:@"scope"] copy];
        _sessionKey = [[sessionInfo objectForKey:@"session_key"] copy];
        _sessionSecret = [[sessionInfo objectForKey:@"session_secret"] copy];
        _expiresIn = [[sessionInfo objectForKey:@"expires_in"] copy];
    }
    return self;
}

-(void)saveUserSessionInfo:(NSDictionary *)sessionInfo
{
    if (_accessToken) {
        [_accessToken release];
        _accessToken = nil;
    }
    _accessToken = [[sessionInfo objectForKey:@"access_token"] copy];
    
    if (_scope) {
        [_scope release];
        _scope = nil;
    }
    _scope = [[sessionInfo objectForKey:@"scope"] copy];
    
    if (_sessionKey) {
        [_sessionKey release];
        _sessionKey = nil;
    }
    _sessionKey = [[sessionInfo objectForKey:@"session_key"] copy];
    
    if (_sessionSecret) {
        [_sessionSecret release];
        _sessionSecret = nil;
    }
    _sessionSecret = [[sessionInfo objectForKey:@"session_secret"] copy];
    
    if (_expiresIn) {
        [_expiresIn release];
        _expiresIn = nil;
    }
    _expiresIn = [[BaiduUtility getDateFromString:[sessionInfo objectForKey:@"expires_in"]] copy];
    
    [self stroeUserSessionInfo];
}

-(void)stroeUserSessionInfo
{
    NSMutableDictionary* sessionInfo = [NSMutableDictionary dictionaryWithCapacity:5];
    [sessionInfo setObject:self.accessToken forKey:@"access_token"];
    [sessionInfo setObject:self.scope forKey:@"scope"];
    [sessionInfo setObject:self.sessionKey forKey:@"session_key"];
    [sessionInfo setObject:self.sessionSecret forKey:@"session_secret"];
    [sessionInfo setObject:self.expiresIn forKey:@"expires_in"];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sessionInfo forKey:BDAUTHORIZE_USERSESSION_STOREKEY];
    [defaults synchronize];
}

-(BOOL)isUserSessionValid
{
    return (_accessToken != nil) && (_expiresIn != nil) && (NSOrderedDescending == [_expiresIn compare:[NSDate date]]);
}

-(void)logout
{
    [_accessToken release];
    _accessToken = nil;
    [_scope release];
    _scope = nil;
    [_sessionKey release];
    _sessionKey = nil;
    [_sessionSecret release];
    _sessionSecret = nil;
    [_expiresIn release];
    _expiresIn = nil;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:BDAUTHORIZE_USERSESSION_STOREKEY];
    [defaults synchronize];
    
    NSMutableArray *hosts = [[[NSMutableArray alloc] init] autorelease];
    [hosts addObject:BDAUTHORIZE_HOSTURL];
    [BaiduUtility deleteCookies:hosts];
}

-(void)dealloc
{
    [_accessToken release];
    [_scope release];
    [_sessionKey release];
    [_sessionSecret release];
    [_expiresIn release];
    [super dealloc];
}

@end
