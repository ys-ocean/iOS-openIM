//
//  AppDelegate.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/1.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "AppDelegate.h"
#import "SPKitExample.h"
#import <AMapFoundationKit/AMapServices.h>
@interface AppDelegate ()

@end

@implementation AppDelegate
/// 替换成自己的Key
const static NSString *GDAPIKey = @"8c0c54e2b73374c676e4279ab6bc09e5";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //加载高德key
    [AMapServices sharedServices].apiKey = (NSString *)GDAPIKey;
    /// 检测Demo过期时间
    [self checkTimeOutMethod];
    /// YWSDK快速接入接口，程序启动后调用这个接口 三方提供的胶水代码
    [[SPKitExample sharedInstance] callThisInDidFinishLaunching];
    /// 注册消息通知
    [self registerAPNS];

    return YES;
}


- (void)checkTimeOutMethod {
    dispatch_async(dispatch_queue_create("APP_EXPIRE_KILL", 0), ^{
        // 检查程序是否过期
        //MUPP_ALREADY_MODIFIED_TAG
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d yyyy"];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        NSDate *expiresDate = [formatter dateFromString:[NSString stringWithFormat:@"%s", __DATE__]];
        
        // 一周过期
        if (now - [expiresDate timeIntervalSince1970] >=15*24*3600) {
            SEL expiredSelector = NSSelectorFromString(@"mupp_enterpriseBundleHasExpired");
            
            if ([self respondsToSelector:expiredSelector])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:expiredSelector];
#pragma clang diagnostic pop
                
                return;
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您使用的程序是测试版本，目前已经过期，请更新到最新版本"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                
                sleep(10);
                kill(getpid(), 9);
            }
        }
    });
}

- (void)registerAPNS {
    /// 向APNS注册PUSH服务，需要区分iOS SDK版本和iOS版本。
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else
#endif
    {
        /// 去除warning
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#pragma clang diagnostic pop
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
