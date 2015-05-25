//
//  SingleRecipient.m
//  BestChat
//
//  Created by HiepHN-imac on 5/21/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import "SingleRecipient.h"
#import "ProgressHUD.h"

@interface SingleRecipient ()<UISearchBarDelegate> {
    NSMutableArray *_users;
}
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SingleRecipient
@synthesize viewHeader, searchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Select Single";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(__actionCancel)];
    
    self.tableView.tableHeaderView = self.viewHeader;
    
    [self loadUsers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Backend methods

- (void)loadUsers {
    PFUser *user = [PFUser currentUser];
    
    if (user) {
        PFQuery *query1 = [PFQuery queryWithClassName:PF_BLOCKED_CLASS_NAME];
        [query1 whereKey:PF_BLOCKED_USER1 equalTo:user];
        
        PFQuery *query2 = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
        [query2 whereKey:PF_USER_OBJECTID notEqualTo:user.objectId];
        [query2 whereKey:PF_USER_OBJECTID doesNotMatchKey:PF_BLOCKED_USERID2 inQuery:query1];
        [query2 orderByAscending:PF_USER_FULLNAME];
        [query2 setLimit:1000];
        [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [_users removeAllObjects];
                [_users addObjectsFromArray:objects];
                [self.tableView reloadData];
            }else {
                [ProgressHUD showError:@"Network error."];
            }
        }];
    }
}

- (void)searchUsers:(NSString *)searchLower {
    PFUser *user = [PFUser currentUser];
    
    if (user) {
        PFQuery *query1 = [PFQuery queryWithClassName:PF_BLOCKED_CLASS_NAME];
        [query1 whereKey:PF_BLOCKED_USER1 equalTo:user];
        
        PFQuery *query2 = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
        [query2 whereKey:PF_USER_OBJECTID notEqualTo:user.objectId];
        [query2 whereKey:PF_USER_OBJECTID doesNotMatchKey:PF_BLOCKED_USERID2 inQuery:query1];
        [query2 whereKey:PF_USER_FULLNAME_LOWER containsString:searchLower];
        [query2 orderByAscending:PF_USER_FULLNAME];
        [query2 setLimit:1000];
        [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [_users removeAllObjects];
                [_users addObjectsFromArray:objects];
                [self.tableView reloadData];
            }else {
                [ProgressHUD showError:@"Network error."];
            }
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Blocks.

#pragma mark - Actions.
- (void)__actionCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    PFUser *user = _users[indexPath.row];
    cell.textLabel.text = user[PF_USER_FULLNAME];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.didSelectSingleUserBlock) {
            self.didSelectSingleUserBlock(_users[indexPath.row]);
        }
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] > 0) {
        [self searchUsers:[searchText lowercaseString]];
    }else {
        [self loadUsers];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar_ {
    [searchBar_ setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar_ {
    [searchBar_ setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar_ {
    [self searchBarCancelled];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar_ {
    [searchBar_ resignFirstResponder];
}

- (void)searchBarCancelled {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self loadUsers];
}
@end
