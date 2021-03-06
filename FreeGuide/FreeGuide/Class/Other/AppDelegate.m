//
//  AppDelegate.m
//  FreeGuide
//
//  Created by LeeJunHui on 15/5/25.
//  Copyright (c) 2015年 © 2015 JH Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "FGHomeViewController.h"
#import <iflyMSC/IFlySpeechUtility.h>
#import "FGJingDianViewController.h"
#import "FGNotifyNolyTextViewController.h"
#import "FGNotifyImageAndTextViewController.h"
#import "FGLoginViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge |UIUserNotificationTypeSound categories:nil]];
        
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //向服务器发请求，获取定位到的景点的ibeacons列表数据
    //[uuid major minor]数组
    [self setupBeacons];
    
    [self setupMap];
    [self setupIFlyMSC];
    [self setupRootVC];

    
    UILocalNotification *note = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (note) {
        int keyCode = [[note.userInfo valueForKey:@"key"] intValue];
        if (keyCode == 1)
        {
            FGNotifyImageAndTextViewController *vc = [[FGNotifyImageAndTextViewController alloc] initWithNibName:@"FGNotifyImageAndTextViewController" bundle:nil];
//            vc.userInfo = note.userInfo;
            [[self.window.rootViewController.childViewControllers firstObject] pushViewController:vc
                                                                                         animated:YES];
        }
    } else {
        
    }
    return YES;
}

- (void)setupBeacons
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager managerForDomain:@"www.apple.com.cn"];
    [manager startMonitoring];
    if (manager.reachable == NO)
    {
        //无网络情况下从本地加载beacons
        
    }
    else
    {
    
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (application.applicationState == UIApplicationStateActive) return;
    
    int keyCode = [[notification.userInfo valueForKey:@"key"] intValue];
    if (keyCode == 1)
    {
        FGNotifyImageAndTextViewController *vc = [[FGNotifyImageAndTextViewController alloc] initWithNibName:@"FGNotifyImageAndTextViewController" bundle:nil];
//        vc.userInfo = notification.userInfo;
        [[self.window.rootViewController.childViewControllers firstObject] presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
        [UIApplication sharedApplication].applicationIconBadgeNumber --;
    }
    
}

- (void)setupRootVC
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    BOOL isLogin = [[NSUserDefaults standardUserDefaults]valueForKey:kLoginKey];
    if (isLogin == YES)
    {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[FGHomeViewController alloc] init]];
    }
    else
    {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[FGLoginViewController alloc]initWithNibName:@"FGLoginViewController" bundle:nil]];
    }
}

- (void)setupMap
{
    [MAMapServices sharedServices].apiKey = MAMapKey;
}

- (void)setupIFlyMSC
{
    [IFlySpeechUtility createUtility:IFlyMSCKey];
}

@end
