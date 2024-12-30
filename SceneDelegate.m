#import "SceneDelegate.h"
#import "WebViewController.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if ([scene isKindOfClass:[UIWindowScene class]]) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        WebViewController *webVC = [[WebViewController alloc] init];
        self.window.rootViewController = webVC;
        [self.window makeKeyAndVisible];
    }
}

@end 