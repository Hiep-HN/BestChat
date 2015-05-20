//
//  AppDelegate.h
//  BestChat
//
//  Created by HiepHN-imac on 5/19/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeVC.h"
#import "RecentVC.h"
#import "ContactsVC.h"
#import "ChatsVC.h"
#import "SettingsVC.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) HomeVC *homeView;
@property (strong, nonatomic) RecentVC *recentView;
@property (strong, nonatomic) ContactsVC *contactsView;
@property (strong, nonatomic) ChatsVC *chatsView;
@property (strong, nonatomic) SettingsVC *settingsView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D coordinate;


@end

