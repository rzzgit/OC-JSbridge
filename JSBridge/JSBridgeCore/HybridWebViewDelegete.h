//
//  HybridWebViewDelegete.h
//  JSBridge
//
//  Created by 唐游-mac1 on 16/8/18.
//
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HybridWebViewDelegete <NSObject>

-(void) loadUrl:(NSString*)urlStr;

-(id) getWebView;

-(UIView*) getParentView;

-(void) notifyJS:(NSString*)message;

@end
