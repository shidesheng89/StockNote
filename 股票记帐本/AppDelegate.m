//
//  AppDelegate.m
//  股票记帐本
//
//  Created by 施德胜 on 15/9/1.
//  Copyright (c) 2015年 施德胜. All rights reserved.
//

#import "AppDelegate.h"
#import "stockTradeViewController.h"
#import "DataModel.h"
#import "historyTradeViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
//-(void)save{
//    _dataModel=[[DataModel alloc]init];
//    [_dataModel saveData];
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置NavigationBar背景颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:127/255.0 blue:236/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
//    _dataModel=[[DataModel alloc]init];
//    // Override point for customization after application launch.
//    UINavigationController *navigationController=(UINavigationController*)self.window.rootViewController;
//    stockTradeViewController *controller=navigationController.viewControllers[3];
//    controller.dataModel=_dataModel;
    
//    _dataModel=[[DataModel alloc]init];
    // Override point for customization after application launch.
   
//    controller.dataModel=_dataModel;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [self save];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    [self save];
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    if (viewController.tabBarItem.tag==1) {
//        UINavigationController *navigationctr = (UINavigationController *)viewController;
//        historyTradeViewController *controller = (historyTradeViewController *)navigationctr.topViewController;
//        [controller setDataSource];
//    }
//    
//}

@end
