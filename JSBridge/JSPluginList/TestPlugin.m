//
//  TestPlugin.m
//  JSBridge
//
//  Created by 唐游-mac1 on 16/8/18.
//
//

#import "TestPlugin.h"

@implementation TestPlugin

static int i;

-(void) test:(NSString*) pluginParams{
    [self.jsBridge.hybirdWebViewDelegte getWebView];
    NSLog(@"test");
    i++;
    if(i==2){
       [NSThread sleepForTimeInterval:5];
    }else{
       NSNotification * notice = [NSNotification notificationWithName:@"123" object:nil userInfo:@{@"1":@"123"}];
                //发送消息
       [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    }
    [self onSuccess:@"123"];
};

@end
