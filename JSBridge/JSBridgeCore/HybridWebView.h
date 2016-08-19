//
//  HybridWebView.h
//  JSBridge
//
//  Created by 唐游-mac1 on 16/8/16.
//
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSBridge.h"
#import "HybridWebViewDelegete.h"
@interface HybridWebView : NSObject<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate,UIWebViewDelegate,HybridWebViewDelegete>

@property (strong,nonatomic) id webView;

@property (readonly,nonatomic) BOOL isUIWebView;

@property (strong,nonatomic) JSBridge *jsBridge ;

-(instancetype) initWithFrame:(CGRect) bouds;

-(void) onDestroy;

@end
