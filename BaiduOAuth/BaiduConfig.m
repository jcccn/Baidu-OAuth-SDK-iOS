//
//  BaiduConfig.h
//  Baidu SDK
//
//  Created by xiawh on 12-9-25.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//

#import "BaiduConfig.h"

static BaiduConfig *config = nil;
@implementation BaiduConfig

@synthesize apiKey = _apiKey;
@synthesize appId = _appId;
@synthesize sdkVersion = _sdkVersion;

-(id)init
{
    if (self = [super init]) {
        _sdkVersion = [[NSString alloc] initWithString:@"1.1.0"];
    }
    return self;
}

+(BaiduConfig*)shareConfig
{
    if (!config) {
        config = [[BaiduConfig alloc] init];
    }
    
    return config;
}

+(void)destroyConfig
{
    if (config) {
        [config release];
        config = nil;
    }
}

-(void)dealloc
{
    self.apiKey = nil;
    self.appId = nil;
    [_sdkVersion release];
    _sdkVersion = nil;
    [super dealloc];
}

@end
