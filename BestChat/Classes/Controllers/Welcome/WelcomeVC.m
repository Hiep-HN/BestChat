//
//  WelcomeVC.m
//  BestChat
//
//  Created by HiepHN-imac on 5/21/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import "WelcomeVC.h"
#import "SignInEmailVC.h"

@interface WelcomeVC (){
    
    __weak IBOutlet UIButton *_btFacebook;
    __weak IBOutlet UIButton *_btTwitter;
    __weak IBOutlet UIButton *_btSignIn;
    
}

@end

@implementation WelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions.
- (IBAction)__registerFacebook:(id)sender {
}
- (IBAction)__registerTwitter:(id)sender {
}
- (IBAction)__signInEmail:(id)sender {
    SignInEmailVC *signInEmail = [[SignInEmailVC alloc]init];
    [self.navigationController pushViewController:signInEmail animated:YES];
}

@end
