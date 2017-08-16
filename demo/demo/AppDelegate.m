//
//  AppDelegate.m
//  KSYPlayerDemo
//
//  Created by zengfanping on 12/7/15.
//  Copyright © 2015 kingsoft. All rights reserved.
//

#import "AppDelegate.h"
#import <KSYHTTPCache/KSYHTTPProxyService.h>

@interface AppDelegate ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[KSYHTTPProxyService sharedInstance] setCacheRoot:[NSTemporaryDirectory() stringByAppendingPathComponent:@"cachetest"]];
    [[KSYHTTPProxyService sharedInstance] startServer];
    
//    //设置请求头
//    [[KSYHTTPProxyService sharedInstance] setHttpHeaders:@{@"ksy-xxxxx":@"ksyhttpcache-ios version 1.0.11"}];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //[[KSYHTTPProxyService sharedInstance] stopServer];
    [self enterBackgroundHandlerWithApplication:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //[[KSYHTTPProxyService sharedInstance] startServer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.timer invalidate];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 开启后台运行（以便进入后台时，仍然可以缓存视频）

static UInt64 count = 0;
- (void)timerAction:(NSTimer *)timer {
    count++;
    if (count % 500 == 0) {
        UIApplication *application = [UIApplication sharedApplication];
        [application endBackgroundTask:taskId];
        taskId = [application beginBackgroundTaskWithExpirationHandler:NULL];
    }
}

UIBackgroundTaskIdentifier taskId;
- (void)enterBackgroundHandlerWithApplication:(UIApplication *)application {
    taskId = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:taskId];
    }];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

@end
