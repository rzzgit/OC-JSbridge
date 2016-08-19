//
//  TestController.m
//  JSBridge
//
//  Created by 唐游-mac1 on 16/8/18.
//
//

#import "TestController.h"

@implementation TestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _webView = [[HybridWebView alloc] initWithFrame:CGRectMake(0, 100, 320, 560)];
//    [_webView loadUrl:@"http://192.168.1.120:3000/demo.html"];
    [_webView loadUrl:@"https://www.tmall.com"];
    
    [self.view addSubview:[_webView getWebView]];
    
    _button  =  [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    [_button setTitle:@"sfsad" forState:UIControlStateNormal];
    
    [_button addTarget:self action:@selector(aa) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_button];
    
}

-(void)aa{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)viewDidDisappear:(BOOL)animated{


}

-(void) dealloc{
    [_webView onDestroy ];

}

@end
