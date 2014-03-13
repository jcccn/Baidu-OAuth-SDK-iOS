//
//  BaiduAuthorizeViewController.h
//  Baidu SDK
//
//  Created by xiawh on 12-9-25.
//  Copyright (c) 2012年 Baidu. All rights reserved.
//
#import "Baidu.h"
#import "BaiduDelegate.h"

/*
 * 授权窗口的视图控制器
 */
@interface BaiduAuthorizeViewController : UIViewController<UIWebViewDelegate>{
    
}
/*
 * 授权窗口的代理
 */
@property(nonatomic, assign)id<BaiduAuthorizeDelegate> delegate;
/*
 * 权限列表
 */
@property(nonatomic, copy)NSString *scope;
/*
 * target视图控制器
 */
@property(nonatomic, assign)UIViewController *targetController;

@end