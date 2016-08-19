//
//  JSBridge.m
//  JSBridge
//
//  Created by 唐游-mac1 on 16/8/17.
//
//

#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import "JSBridge.h"
#import "JSResult.h"
#import "JSPlugin.h"
#import "HybridWebView.h"
@implementation JSBridge



-(void) triggerNative:(NSString *)pluginName pluginMethod:(NSString *) pluginMethod pluginParams:(NSString *)pluginParams callBackID:(NSString*)callBackID{
  
    
   
    
   Class cls = NSClassFromString(pluginName);
   if(cls){
       id  subPlugin =  [[cls alloc] init];
       JSPlugin *plugin = subPlugin;
       
        SEL selMethod = NSSelectorFromString(@"test:");
       
       if([plugin  respondsToSelector:selMethod] == YES){
           plugin.jsBridge = self;
           plugin.callBackID = callBackID;
           
           [subPlugin performSelector:selMethod withObject:pluginParams];
           
       }else{
           [self onError:callBackID error:@"plugin not found!"];
       }
   }else{
       [self onError:callBackID error:@"plugin not found!"];
   }
    
}

-(void) onSuccess:(NSString*) callBackID result:(id)obj{
    JSResult *result = [[JSResult alloc] init];
    result.code = 200;
    result.data = obj;
    [self triggerJS:callBackID JSResult:result];
}

-(void) onError:(NSString*) callBackID error:(id)obj{
    JSResult *result = [[JSResult alloc] init];
    result.code = 500;
    result.data = obj;
    [self triggerJS:callBackID JSResult:result];

}

-(void) triggerJS:(NSString*) callBackID  JSResult:(JSResult*) result{
    NSData *data = [NSJSONSerialization dataWithJSONObject:[JSBridge getObjectData:result] options:kNilOptions error:nil];// OC对象 -> JSON数据 [数据传输只能
    NSString *jsStr = [NSString stringWithFormat:@"javascript:JSBridgeCallBacks['%@'](%@)",callBackID,    [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    [_hybirdWebViewDelegte notifyJS:jsStr];
}



+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [JSBridge getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}


+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}

@end
