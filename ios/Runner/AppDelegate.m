#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  [GMSServices provideAPIKey: @"AIzaSyBRru5k-8LcUsZv-zvGbW4T4Xbpr4WfYKo"];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
