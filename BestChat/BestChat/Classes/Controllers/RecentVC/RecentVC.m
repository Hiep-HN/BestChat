//
//  RecentVC.m
//  BestChat
//
//  Created by HiepHN-imac on 5/20/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import <Parse/Parse.h>
#import "ProgressHUD.h"

#import "Define.h"
#import "RecentVC.h"
#import "RecentCell.h"
#import "ChatView.h"
#import "Common.h"

#import "SingleRecipient.h"
#import "HHNavigationController.h"

@interface RecentVC ()<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray *_recents;
}

@end

@implementation RecentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionCleanup) name:NOTIFICATION_USER_LOGGED_OUT object:nil];
    
    [_tableView registerNib:[UINib nibWithNibName:[RecentCell identifier] bundle:nil] forCellReuseIdentifier:[RecentCell identifier]];
    
    _recents = [[NSMutableArray alloc]init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([PFUser currentUser] != nil) {
        [self loadRecents];
    }
    else {
        //[Common LoginUser:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Backend methods

- (void)loadRecents {
    PFQuery *query = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
    [query whereKey:PF_RECENT_USER equalTo:[PFUser currentUser]];
    [query includeKey:PF_RECENT_LASTUSER];
    [query orderByDescending:PF_RECENT_UPDATEDACTION];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            [_recents removeAllObjects];
            [_recents addObjectsFromArray:objects];
            [_tableView reloadData];
            [self updateTabCounter];
        }else {
            [ProgressHUD showError:@"Network error."];
        }
    }];
}

#pragma mark - Helper methods.

- (void)updateTabCounter {
    int total = 0;
    for (PFObject *recent in _recents) {
        total += [recent[PF_RECENT_COUNTER] intValue];
    }
    UITabBarItem *item = self.tabBarController.tabBar.items[1];
    item.badgeValue = (total == 0) ? nil : [NSString stringWithFormat:@"%d", total];
}

#pragma mark - User actions
- (IBAction)__compose:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Single recipient", @"Multiple recipients", @"Address Book", @"Facebook Friends" , nil];
    [action showFromTabBar:[[self tabBarController] tabBar]];
}

- (void)actionChat:(NSString *)groupId {
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}

- (void)actionCleanup {
    [_recents removeAllObjects];
    [_tableView reloadData];
    [self updateTabCounter];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex == 0) {
            SingleRecipient *selectSingle = [[SingleRecipient alloc] init];
            HHNavigationController *navi = [[HHNavigationController alloc] initWithRootViewController:selectSingle];
            
            [selectSingle setDidSelectSingleUserBlock:^(PFUser *user) {
                PFUser *user1 = [PFUser currentUser];
                //NSString *groupId =
                [self actionChat:@""];
            }];
            
            [self presentViewController:navi animated:YES completion:nil];
        }
    }
}

#pragma mark - SingleRecipient.


#pragma mark - TableView.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_recents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecentCell *cell = [tableView dequeueReusableCellWithIdentifier:[RecentCell identifier] forIndexPath:indexPath];
    [cell bindData:_recents[indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *recent = _recents[indexPath.row];
    [_recents removeObject:recent];
    [self updateTabCounter];
    
    [recent deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error != nil) {
            [ProgressHUD showError:@"Network error."];
        }
    }];
    
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *recent = _recents[indexPath.row];
    [self actionChat:recent[PF_RECENT_GROUPID]];
}
@end
