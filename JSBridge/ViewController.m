//
//  ViewController.m
//  JSBridge
//
//  Created by 唐游-mac1 on 16/8/16.
//
//

#import "ViewController.h"
#import "TestController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _webView = [[HybridWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 560)];
    [_webView loadUrl:@"http://192.168.1.120:3000/demo.html"];
    
    [self.view addSubview:[_webView getWebView]];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"123" object:nil];
    
    
}

-(void)notice:(id)sender{
    NSLog(@"%@",sender);
    [self performSelectorOnMainThread:@selector(test:) withObject:nil waitUntilDone:NO];
   }

-(void) test:(NSString*) a{
    
    TestController *testController = [[TestController alloc] init];
    [self presentViewController:testController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
