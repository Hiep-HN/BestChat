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
#import "HHTabbarController.h"

#import "Define.h"
#import "RecentVC.h"

@interface AppDelegate ()

@property (strong, nonatomic) RecentVC *recentVC;

@end

@implementation AppDelegate
static __weak AppDelegate *__appdelegate = nil;

+ (id)sharedInstance {
    return __appdelegate;
}

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
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.window setBackgroundColor:[UIColor whiteColor]];
    __appdelegate = self;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    HHTabbarController *tabbar = [[HHTabbarController alloc] initWithRegistration:NO];
    
    [UIView transitionWithView:[[AppDelegate sharedInstance]window] duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [[AppDelegate sharedInstance]window].rootViewController = tabbar;
        [UIView setAnimationsEnabled:oldState];
    } completion:nil];
    
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
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  
}

#pragma mark - Facebook responses

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([PFUser currentUser] != nil) {
        [self performSelector:@selector(refreshRecentView) withObject:nil afterDelay:4.0];
    }
}

- (void)refreshRecentView {
    [self.recentVC loadRecents];
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

- (void)locationManagerStop {
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.coordinate = newLocation.coordinate;
}

@end
