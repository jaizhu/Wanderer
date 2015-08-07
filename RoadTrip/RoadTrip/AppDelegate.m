//
//  AppDelegate.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/6/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "AppDelegate.h"
#import "TripResultsViewController.h"
#import "TripInfoViewController.h"
#import "MapViewController.h"
#import "LoginViewController.h"
#import "MyTripsViewController.h"
#import "NewsFeedController.h"
#import "DetailViewController.h"
#import "RedirectToCustomViewController.h"

@import GoogleMaps;

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [PFLogInView class];
    
    // Override point for customization after application launch
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // UI customizing tabBar
    CGRect frame = CGRectMake(0, 0, self.window.frame.size.width, 500);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIColor *baseBlackColor = [UIColor blackColor];
    //UIColor *baseBlackColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.85];
    [view setBackgroundColor:baseBlackColor];
    
    // Create UITabBarController
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    [tabBarController.tabBar insertSubview:view atIndex:0];
    
    // Main screen to create a trip
    RedirectToCustomViewController *rdc = [[RedirectToCustomViewController alloc] init];
    rdc.tabBarItem.title = @"Create a Trip";
    rdc.tabBarItem.image = [UIImage imageNamed:@"createTripIcon"];
    
    // User account page
    MyTripsViewController *mtvc = [[MyTripsViewController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyTrips" bundle:nil];
    mtvc = [storyboard instantiateInitialViewController];
    mtvc.tabBarItem.title = @"My Trips";
    mtvc.tabBarItem.image = [UIImage imageNamed:@"userIcon"];
    
    // Tells the application to launch with UITabBarController
    tabBarController.viewControllers = @[mtvc, rdc];
    tabBarController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    // Create a UINavigationController and set it as the rvc
    UINavigationController *navController =
    [[UINavigationController alloc] initWithRootViewController:tabBarController];
    
    // Customizing Navigation Controller
    navController.navigationBar.barTintColor = baseBlackColor;
    navController.navigationBar.tintColor = [UIColor whiteColor];
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    navController.navigationBar.translucent = YES;
    navController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    
    // Connect to Parse and enable local datastore
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"ZPmDJBUVftnCYNleWBk3WDR5q1uwHgpEtsSfekef"
                  clientKey:@"jEoJz4HmCJw8sFLE9KfqhHZ5Xwx3uzuykc4cj7Ld"];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Allowing use of Google Maps iOS SDK
    [GMSServices provideAPIKey:@"AIzaSyDdqDcj9uGip-yyrMKBzmU_kGsfJSNwhtY"];
    
    return YES;
}

// MARK: Facebook login
- (void)_loginWithFacebook {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"public_profile", @"email", @"user_friends"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
        }
    }];
}

// MARK: AppDelegate override methods
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
    [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//Lets Facebook SDK handle the login result and modify the login view accordingly. The authentication token received by Facebook will be persistently stored, and the session state will get changed
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

@end
