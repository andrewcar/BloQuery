//
//  AppDelegate.m
//  BloQuery
//
//  Created by Andrew Carvajal on 6/1/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "DataSource.h"
#import "LoginViewController.h"
#import "QuestionsTableViewController.h"
#import "AnswersTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UINavigationController *navVC = [[UINavigationController alloc] init];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
//    AnswersTableViewController *answersTVC = [[AnswersTableViewController alloc] init];
    [navVC setViewControllers:@[loginVC] animated:YES];
    
    navVC.navigationBarHidden = YES;
    self.window.rootViewController = navVC;
    self.window.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:46/255.0 alpha:1];
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"LWMkzC3J3Kseb0XbcynRV7APpj3b1AbwuuBtz2cE" clientKey:@"OkosInNwy0sSnDGOW9Z4I4g8No6FPxGFnUh8AC98"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
