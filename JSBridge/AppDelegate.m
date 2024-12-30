#import "AppDelegate.h"
#import "WebViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    WebViewController *webVC = [[WebViewController alloc] init];
    self.window.rootViewController = webVC;
    [self.window makeKeyAndVisible];
    return YES;
}

@end