#import "WebViewController.h"

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置 WKWebView
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContent = [[WKUserContentController alloc] init];
    
    // 注册 JS 调用原生的方法名
    [userContent addScriptMessageHandler:self name:@"nativeMethod"];
    config.userContentController = userContent;
    
    // 创建 WKWebView
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    // 加载本地 HTML 文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self.webView loadFileURL:url allowingReadAccessToURL:url];
    
    // 添加一个按钮用于演示原生调用 JS
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"原生调用JS" forState:UIControlStateNormal];
    button.frame = CGRectMake(20, 50, 100, 40);
    [button addTarget:self action:@selector(callJavaScript) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark - WKScriptMessageHandler

// 处理来自 JavaScript 的消息
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"nativeMethod"]) {
        NSDictionary *body = message.body;
        NSString *action = body[@"action"];
        
        if ([action isEqualToString:@"Hello"]) {
            // 处理普通消息
            NSString *response = @"Native received your hello message!";
            [self callJSFunction:@"nativeCallJs" withParameter:response];
            
        } else if ([action isEqualToString:@"GetDeviceInfo"]) {
            // 获取设备信息
            UIDevice *device = [UIDevice currentDevice];
            NSDictionary *deviceInfo = @{
                @"name": device.name,
                @"model": device.model,
                @"systemName": device.systemName,
                @"systemVersion": device.systemVersion
            };
            
            // 将字典转换为JSON字符串
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:deviceInfo 
                                                             options:0 
                                                               error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData 
                                                       encoding:NSUTF8StringEncoding];
            
            [self callJSFunction:@"nativeCallJs" withParameter:jsonString];
        }
    }
}

#pragma mark - Native 调用 JavaScript

- (void)callJavaScript {
    NSString *message = @"Hello from Native!";
    [self callJSFunction:@"nativeCallJs" withParameter:message];
}

- (void)callJSFunction:(NSString *)functionName withParameter:(NSString *)parameter {
    NSString *jsCode = [NSString stringWithFormat:@"%@('%@')", functionName, parameter];
    [self.webView evaluateJavaScript:jsCode completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"调用JS方法出错：%@", error);
        }
    }];
}

#pragma mark - Memory Management

- (void)dealloc {
    // 移除消息处理器
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"nativeMethod"];
}

@end
