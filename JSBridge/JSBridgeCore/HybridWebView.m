//
//  HybridWebView.m
//  JSBridge
//
//  Created by 唐游-mac1 on 16/8/16.
//
//

#import "HybridWebView.h"




@implementation HybridWebView




-(instancetype) initWithFrame:(CGRect) bouds{
    if (self=[self init]) {
        [self initWebView:bouds];
        _jsBridge = [[JSBridge alloc] init];
        _jsBridge.hybirdWebViewDelegte = self;
    }
    return self;
}

-(void) initWebView:(CGRect) bounds{
    
    Class wkWebView = NSClassFromString(@"WKWebView");
    if(wkWebView)
    {
        _isUIWebView = NO;
        [self initWKWebView:bounds];
        
    }
    else
    {
        _isUIWebView = YES;
        [self initUIWebView:bounds];
    }
    
   }


/**  UIWebView 部分  ***/
-(void) initUIWebView:(CGRect) bounds{
    UIWebView* webView = [[UIWebView alloc] initWithFrame:bounds];
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    for (UIView *subview in [webView.scrollView subviews])
    {
        if ([subview isKindOfClass:[UIImageView class]])
        {
            ((UIImageView *) subview).image = nil;
            subview.backgroundColor = [UIColor clearColor];
        }
    }
    
    webView.delegate = self;
    _webView = webView;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //定义好JS要调用的方法, share就是调用的share方法名
    context[@"TriggerNative"] = ^() {
    
        NSArray *args = [JSContext currentArguments];

        [_jsBridge triggerNative:[args[0] toString] pluginMethod:[args[1] toString] pluginParams:[args[2] toString ]callBackID:[args[3] toString]];
        
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal.toString);
        }
        
    
    };
}







/**  WKWebView 部分  ***/
-(void) initWKWebView:(CGRect) bounds{
    WKWebViewConfiguration* configuration = [[NSClassFromString(@"WKWebViewConfiguration") alloc] init];
    configuration.preferences = [[NSClassFromString(@"WKPreferences") alloc] init];
    configuration.userContentController = [[NSClassFromString(@"WKUserContentController") alloc] init];
//    configuration.processPool = [[NSClassFromString(@"WKProcessPool") alloc]init];
    //    configuretion.preferences.minimumFontSize = 10;
    
    configuration.preferences.javaScriptEnabled = true;
    // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //OC注册供JS调用的方法
   
    [configuration.userContentController addScriptMessageHandler:self name:@"JSBridge"];
    
    WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:bounds configuration:configuration];
    
    
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    webView.scrollView.delegate = self;

    _webView = webView;
    
    
    

}


//页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面开始加载");
};
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"当内容开始返回时调用");
};
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载完成之后调用");
    [webView evaluateJavaScript:@"javascript: TriggerNative = function(pluginName,method,data,callID){ window.webkit.messageHandlers.JSBridge.postMessage({pluginName:pluginName,method:method,data:data,callID:callID});};" completionHandler:nil];
    
    
};
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载失败时调用");
};





- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(message);
    completionHandler();
};




//收到界面的消息
- (void)userContentController:(WKUserContentController *)userContentController

      didReceiveScriptMessage:(WKScriptMessage *)message {

    if([@"JSBridge" isEqualToString:message.name]){

        [_jsBridge triggerNative:message.body[@"pluginName"] pluginMethod:message.body[@"method"] pluginParams:message.body[@"data"] callBackID:message.body[@"callID"]];
    }


}


-(void) notifyWKWebViewJS:(NSString*) message{
    [(WKWebView*)self.webView evaluateJavaScript:message completionHandler:^(id obj,NSError *err){
        NSLog(@"通知wk界面错误%@",err);
    }];
}






/**  禁止webview  缩放大小 **/
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}






/** 对外提供部分  **/

-(void) loadUrl:(NSString*)urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if(_isUIWebView){
        [(UIWebView*)self.webView loadRequest:request];
    }else{
        [(WKWebView*)self.webView loadRequest:request];
    }
    
}

-(void) notifyJS:(NSString*)message{
    
        if(_isUIWebView){
            [(UIWebView*)self.webView stringByEvaluatingJavaScriptFromString:message];
        }else{
            [self notifyWKWebViewJS:message];
        }
}

-(id) getWebView{
    return _webView;
}


-(UIView*) getParentView{
    return nil;
};


-(void) onDestroy{
    [self loadUrl:@""];
    _jsBridge.hybirdWebViewDelegte = nil;
    if(_isUIWebView){
        UIWebView* realView = _webView;
        realView.delegate = nil;

       
    }else{
        
        WKWebView* realView = _webView;
        [realView.configuration.userContentController removeScriptMessageHandlerForName:@"JSBridge"];
        realView.UIDelegate = nil;
        realView.navigationDelegate = nil;
    }
    [self.webView scrollView].delegate = nil;
    [self.webView stopLoading];
    [self.webView removeFromSuperview];
    self.webView = nil;
}

@end
