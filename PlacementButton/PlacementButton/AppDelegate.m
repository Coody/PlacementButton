//
//  AppDelegate.m
//  PlacementButton
//
//  Created by Coody on 2016/2/4.
//  Copyright © 2016年 Coody. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "PlacementItemTools.h"
#import "UIView+Badget.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyWindow];
    [self.window makeKeyAndVisible];
    
    [PlacementItemTools sharedInstance].isNeedFollow = YES;
    
    [[PlacementItemTools sharedInstance] createButtonWithNormalImage:nil 
                                                 withHightLightImage:nil 
                                                    withTag:123
                                                       withDoneBlock:^(UIButton *responseButton) {
                                                           [responseButton setBackgroundColor:[UIColor grayColor]];
                                                       }
                                                    WithPressedBlock:^(UIButton *responseButton) {
                                                        NSLog(@"按下 A ！");
                                                        static NSUInteger count = 0;
                                                        count++;
                                                        [responseButton createBadget];
                                                        [responseButton setBadgetNumber:count];
                                                    }];
    
    [[PlacementItemTools sharedInstance] createButtonWithNormalImage:nil 
                                                 withHightLightImage:nil
                                                             withTag:234
                                                       withDoneBlock:^(UIButton *responseButton) {
                                                     [responseButton setBackgroundColor:[UIColor grayColor]];
                                                 } WithPressedBlock:^(UIButton *responseButton) {
                                                     NSLog(@"按下 B ！");
                                                 }];
    
    [[PlacementItemTools sharedInstance] createButtonWithNormalImage:nil 
                                                 withHightLightImage:nil 
                                                             withTag:345
                                                       withDoneBlock:^(UIButton *responseButton) {
                                                           [responseButton setBackgroundColor:[UIColor grayColor]];
                                                       }
                                                    WithPressedBlock:^(UIButton *responseButton) {
                                                        NSLog(@"按下 C ！");
                                                        static NSUInteger count = 0;
                                                        count++;
                                                        [responseButton createBadget];
                                                        [responseButton setBadgetNumber:count];
                                                    }];
    
    [[PlacementItemTools sharedInstance] createButtonWithNormalImage:nil 
                                                 withHightLightImage:nil
                                                             withTag:456
                                                       withDoneBlock:^(UIButton *responseButton) {
                                                           [responseButton setBackgroundColor:[UIColor grayColor]];
                                                       }
                                                    WithPressedBlock:^(UIButton *responseButton) {
                                                        NSLog(@"按下 D ！");
                                                    }];
    
    [[PlacementItemTools sharedInstance] createButtonWithNormalImage:nil 
                                                 withHightLightImage:nil
                                                             withTag:567
                                                       withDoneBlock:^(UIButton *responseButton) {
                                                           [responseButton setBackgroundColor:[UIColor grayColor]];
                                                       }
                                                    WithPressedBlock:^(UIButton *responseButton) {
                                                        NSLog(@"按下 E ！");
                                                        static NSUInteger count = 0;
                                                        count++;
                                                        [responseButton createBadget];
                                                        [responseButton setBadgetNumber:count];
                                                    }];
    
    [[PlacementItemTools sharedInstance] createButtonWithNormalImage:nil 
                                                 withHightLightImage:nil
                                                             withTag:678
                                                       withDoneBlock:^(UIButton *responseButton) {
                                                           [responseButton setBackgroundColor:[UIColor grayColor]];
                                                       }
                                                    WithPressedBlock:^(UIButton *responseButton) {
                                                        NSLog(@"按下 B ！");
                                                    }];
    
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
