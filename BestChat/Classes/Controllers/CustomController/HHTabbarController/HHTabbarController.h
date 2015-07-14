//
//  HHTabbarController.h
//  CookingSocialApp
//
//  Created by Hiep Huynh Ngoc on 4/21/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHTabbarController : UITabBarController

+ (id)sharedInstance;

- (id)initWithRegistration:(BOOL)isRegistered;

@end
