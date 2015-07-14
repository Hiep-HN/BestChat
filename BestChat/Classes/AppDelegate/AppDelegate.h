//
//  AppDelegate.h
//  BestChat
//
//  Created by HiepHN-imac on 5/19/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D coordinate;


+ (id)sharedInstance;
@end

