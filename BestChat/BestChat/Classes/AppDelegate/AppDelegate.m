//
//  AppDelegate.m
//  BestChat
//
//  Created by HiepHN-imac on 5/19/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#import "Define.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"0nw80O4fyYsiu9ZQ4QNR323FI7dvSw12obyVuPh7" clientKey:@"b8s0tU1JzD1BgA7GUniVv4CBGhHHnseNaFhTQjeZ"];
    [PFTwitterUtils initializeWithConsumerKey:@"" consumerSecret:@""];
    [PFFacebookUtils initializeFacebook];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotifiType = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotifiType categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    
    [PFImageView class];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.homeView = [[HomeVC alloc]init];
    self.recentView = [[RecentVC alloc]init];
    self.contactsView = [[ContactsVC alloc]init];
    self.chatsView = [[ChatsVC alloc]init];
    self.settingsView = [[SettingsVC alloc] init];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects: _homeView, _recentView, _contactsView, _chatsView, _settingsView, nil];
    self.tabBarController.tabBar.translucent = NO;
    self.tabBarController.selectedIndex = DEFAULT_TAB;
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self locationManagerStart];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  
}

#pragma mark - Location manager methods

- (void)locationManagerStart {
    if (self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}
@end
