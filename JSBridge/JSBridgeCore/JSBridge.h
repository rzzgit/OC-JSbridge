//
//  JSBridge.h
//  JSBridge
//
//  Created by 唐游-mac1 on 16/8/17.
//
//

#import <Foundation/Foundation.h>
#import "HybridWebViewDelegete.h"
@interface JSBridge : NSObject


@property (weak,nonatomic) id<HybridWebViewDelegete> hybirdWebViewDelegte;


-(void) triggerNative:(NSString *)pluginName pluginMethod:(NSString *) pluginMethod pluginParams:(NSString *)pluginParams callBackID:(NSString*)callBackID;

-(void) onSuccess:(NSString*) callBackID result:(id)obj;

-(void) onError:(NSString*) callBackID error:(id)obj;



@end
