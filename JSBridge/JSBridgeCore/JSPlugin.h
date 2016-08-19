//
//  JSPlugin.h
//  JSBridge
//
//  Created by 唐游-mac1 on 16/8/17.
//
//

#import <Foundation/Foundation.h>
#import "JSBridge.h"
@interface JSPlugin : NSObject

@property (weak,nonatomic) JSBridge *jsBridge;

@property (strong,nonatomic) NSString *callBackID;


-(void) onSuccess:(id)obj;

-(void) onError:(id)obj;


-(void) onDestroy;

@end
