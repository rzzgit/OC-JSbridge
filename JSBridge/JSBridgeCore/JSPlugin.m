//
//  JSPlugin.m
//  JSBridge
//
//  Created by 唐游-mac1 on 16/8/17.
//
//

#import "JSPlugin.h"

@implementation JSPlugin


-(void) onSuccess:(id)obj{
    [_jsBridge onSuccess:_callBackID result:obj];
    [self onDestroy];
};

-(void) onError:(id)obj{
    [_jsBridge onError:_callBackID error:obj];
    [self onDestroy];
};

-(void) onDestroy{
    _callBackID = nil;
    _jsBridge = nil;

   
};




@end
