//
//  FristPlugin.m
//  JSBridge
//
//  Created by 唐游-mac1 on 16/8/17.
//
//

#import "FirstPlugin.h"

@implementation FirstPlugin

-(void) test:(NSString*) pluginParams{
    [self.jsBridge.hybirdWebViewDelegte getWebView];
    
//    NSNotification * notice = [NSNotification notificationWithName:@"123" object:nil userInfo:@{@"1":@"123"}];
//    //发送消息
//    [[NSNotificationCenter defaultCenter]postNotification:notice];
    NSLog(@"test");
    [self onSuccess:@"123"];
};

@end
