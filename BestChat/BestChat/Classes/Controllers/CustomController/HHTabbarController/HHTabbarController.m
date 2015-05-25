//
//  HHTabbarController.m
//  CookingSocialApp
//
//  Created by Hiep Huynh Ngoc on 4/21/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import "HHTabbarController.h"

#import "HomeVC.h"
#import "RecentVC.h"
#import "ContactsVC.h"
#import "ChatsVC.h"
#import "SettingsVC.h"
#import "HHNavigationController.h"

#import "Common.h"

@interface HHTabbarController () <UITabBarControllerDelegate> {
    
    HHNavigationController *_naviHome, *_naviRecent, *_naviContact, *_naviChat, *_naviSetting;
    
    HomeVC *_homeView;
    RecentVC *_recentView;
    ContactsVC *_contactsView;
    ChatsVC *_chatsView;
    SettingsVC *_settingsView;

    UIImageView *_userAva;
    
    
}

@end

@implementation HHTabbarController
static HHTabbarController *__hTabbarController = nil;

+ (id)sharedInstance {
    if (!__hTabbarController) {
        __hTabbarController = [[HHTabbarController alloc]init];
    }
    return __hTabbarController;
}

- (id)init {
    self = [super init];
    
    if (self) {
        //custom init
        [self createTabbarWithRegistration:YES];
        [self setDelegate:self];
    }
    return self;
}

- (id)initWithRegistration:(BOOL)isRegistered {
    self = [super init];
    
    if (self) {
        [self createTabbarWithRegistration:isRegistered];
        [self setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    if ([self.tabBar respondsToSelector:@selector(setTintColor:)]) {
        [self.tabBar setTintColor:[Common colorFromHexString:@"#54A860"]];
    }
    self.tabBar.backgroundColor = [Common colorFromHexString:@"#292b28"];
    
    _userAva = [[UIImageView alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setItemTitleAndIcon) name:@"reload_userprofile_image" object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTabbarWithRegistration:(BOOL)isRegistered {
    NSMutableArray *viewControllers = [NSMutableArray array];
    // if (isRegistered) {
    _homeView = [[HomeVC alloc]init];
    _homeView.title = @"Home";
    _naviHome = [[HHNavigationController alloc] initWithRootViewController:_homeView];
    [viewControllers addObject:_naviHome];
    
    _recentView = [[RecentVC alloc]init];
    _recentView.title = @"Recent";
    _naviRecent = [[HHNavigationController alloc] initWithRootViewController:_recentView];
    [viewControllers addObject:_naviRecent];
    
    _contactsView = [[ContactsVC alloc]init];
    _contactsView.title = @"Contact";
    _naviContact = [[HHNavigationController alloc] initWithRootViewController:_contactsView];
    [viewControllers addObject:_naviContact];
    
    _chatsView = [[ChatsVC alloc]init];
    _chatsView.title = @"Chat";
    _naviChat = [[HHNavigationController alloc] initWithRootViewController:_contactsView];
    [viewControllers addObject:_naviChat];
    
    _settingsView = [[SettingsVC alloc] init];
    _settingsView.title = @"Setting";
    _naviSetting = [[HHNavigationController alloc] initWithRootViewController:_settingsView];
    [viewControllers addObject:_naviSetting];
    // set to tabbar
    self.viewControllers = viewControllers;
    
    // set Icon tabbar
    [self setItemTitleAndIcon];
    
    //}
}

- (void)setItemTitleAndIcon {
    UITabBarItem *topTabbarItem = self.tabBar.items[0];
    [topTabbarItem setTitle:@"Home"];
    [topTabbarItem setImage:[UIImage imageNamed:@""]];
    
    UITabBarItem *topTabbarItem1 = self.tabBar.items[1];
    [topTabbarItem1 setTitle:@"Recents"];
    [topTabbarItem1 setImage:[UIImage imageNamed:@"tab_recent.png"]];
    
    UITabBarItem *topTabbarItem2 = self.tabBar.items[2];
    [topTabbarItem2 setTitle:@"Contacts"];
    [topTabbarItem2 setImage:[UIImage imageNamed:@"tab_people.png"]];
    
    UITabBarItem *topTabbarItem3 = self.tabBar.items[3];
    [topTabbarItem3 setTitle:@"Chats"];
    [topTabbarItem3 setImage:[UIImage imageNamed:@"tab_groups.png"]];
    
    UITabBarItem *topTabbarItem4 = self.tabBar.items[4];
    [topTabbarItem4 setTitle:@"Setting"];
    [topTabbarItem4 setImage:[UIImage imageNamed:@"tab_settings.png"]];
    
    topTabbarItem.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
    topTabbarItem1.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
    topTabbarItem2.imageInsets = UIEdgeInsetsMake( 1, 0, -1, 0);
    topTabbarItem3.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
    topTabbarItem4.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
    
    //adjust offset tabbar item
    topTabbarItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    topTabbarItem1.titlePositionAdjustment = UIOffsetMake( 0, -4);
    topTabbarItem2.titlePositionAdjustment = UIOffsetMake( 0, -4);
    topTabbarItem3.titlePositionAdjustment = UIOffsetMake( 0, -4);
    topTabbarItem4.titlePositionAdjustment = UIOffsetMake( -6, -4);
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName : [UIFont systemFontOfSize:10.0f],
                                                        }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName : [UIFont systemFontOfSize:10.0f],
                                                        }
                                             forState:UIControlStateHighlighted];
    
    self.tabBar.barTintColor = [UIColor blackColor];
}


#pragma mark - Delegate.

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}
@end
