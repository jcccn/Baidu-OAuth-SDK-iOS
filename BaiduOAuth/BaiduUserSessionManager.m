//
//  BaiduUserSessionManager.m
//  Baidu SDK
//
//  Created by xiawh on 12-9-25.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import "BaiduUserSessionManager.h"

static BaiduUserSessionManager* userSessionManager = nil;

@implementation BaiduUserSessionManager
@synthesize currentUserSession = _currentUserSession;

+(BaiduUserSessionManager*)shareUserSessionManager
{
    if (userSessionManager == nil) {
        userSessionManager = [[BaiduUserSessionManager alloc] init];
    }
    
    return userSessionManager;
}

+(void)destroyUserSessionManager
{
    if (userSessionManager != nil) {
        [userSessionManager release];
        userSessionManager = nil;
    }
}

-(id)init
{
    if (self = [super init]) {
        self.currentUserSession = [[[BaiduUserSession alloc] init] autorelease];
    }
    return self;
}

-(void)dealloc
{
    self.currentUserSession = nil;
    [super dealloc];
}

@end
