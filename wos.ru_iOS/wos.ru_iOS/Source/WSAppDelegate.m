//
//  WSAppDelegate.m
//  wos.ru_iOS
//
//  Created by Denis Zamataev on 12/20/13.
//  Copyright (c) 2013 DZamataev. All rights reserved.
//

#import "WSAppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>
#import "WSRadioViewController.h"
#import "WSRootViewController.h"
#import "WSWindow.h"

// This file is not public so you cannot find it in github public repository. To recreate it define:
//#define WS_SECRETS_PARSE_APP_ID @"YOUR APP ID"
//#define WS_SECRETS_PARSE_CLIENT_KEY @"YOUR CLIENT KEY"
#import "WSSecrets.h"

@implementation WSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    [Parse setApplicationId:WS_SECRETS_PARSE_APP_ID
                  clientKey:WS_SECRETS_PARSE_CLIENT_KEY];
    
    // enable Parse analytics
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    
    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    BOOL currentInstallationUpdated = NO;
    
    // clear badge
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        currentInstallationUpdated = YES;
    }
    
    // save application_version to Parse
    NSString *versionString = [NSString stringWithFormat:@"%@ (%@)",
                               [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                               [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    NSString *oldVersionString = currentInstallation[@"application_version"];
    if (!oldVersionString || ![versionString isEqualToString:oldVersionString]) {
        [currentInstallation setObject:versionString forKey:@"application_version"];
        currentInstallationUpdated = YES;
    }
    
    if (currentInstallationUpdated) {
        [currentInstallation saveEventually];
    }

    
    // push notification analytics
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse in order to be able to send push notifications.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // push notifications analytics
    if (application.applicationState == UIApplicationStateInactive) {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    [PFPush handlePush:userInfo];
    [UIApplication sharedApplication].applicationIconBadgeNumber--;
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    [PFPush handlePush:userInfo];
    [UIApplication sharedApplication].applicationIconBadgeNumber--;
}

- (WSWindow *)window
{
    static WSWindow *customWindow = nil;
    if (!customWindow) {
        customWindow = [[WSWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        customWindow.tintColor = [WSRootViewController defaultAccentColor];
    }
    
    return customWindow;
}

- (void)logtick
{
    NSLog(@"log: window is f.r. %i", (int)[UIApplication sharedApplication].keyWindow.isFirstResponder);
    [self performSelector:@selector(logtick) withObject:nil afterDelay:1.0f];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [WSRadioViewController clearSleepTimerPickedIntervalKey];
}

@end
