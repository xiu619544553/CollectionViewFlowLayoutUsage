//
//  AppDelegate.m
//  WaterFallFlowLayout
//
//  Created by hanxiuhui on 2020/6/21.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "FPSLabel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    
    
    
    [FPSLabel installOnWindow:self.window];
    
    return YES;
}


@end
