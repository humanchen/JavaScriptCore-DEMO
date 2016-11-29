//
//  ViewController.m
//  JavaScriptCore
//
//  Created by 陈思宇 on 16/11/28.
//  Copyright © 2016年 陈思宇. All rights reserved.
//
#import <JavaScriptCore/JavaScriptCore.h>
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) JSContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadHtml];
}

-(void)loadHtml{
    NSString *path = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:@"H5.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.webview loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
      self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 打印异常
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    
//    JS调用OC
    self.context[@"myOnclick"]=^()
    {
            NSLog(@"JS调用原生测试通过");
    };
 
//    OC调用JS
//    方法1
    [self.context evaluateScript:@"callH5('测试通过')"];
//    方法2
    JSValue * function = self.context[@"callH5"];
    JSValue * function2 =   [function callWithArguments:@[@"测试通过"]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
