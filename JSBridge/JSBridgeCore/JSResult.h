//
//  JSResult.h
//  JSBridge
//
//  Created by 唐游-mac1 on 16/8/17.
//
//

#import <Foundation/Foundation.h>

@interface JSResult : NSObject

@property (nonatomic) int code;

@property (strong,nonatomic) id data;

@end
