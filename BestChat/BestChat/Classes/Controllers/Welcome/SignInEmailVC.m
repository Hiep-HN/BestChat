//
//  SignInEmailVC.m
//  BestChat
//
//  Created by HiepHN-imac on 5/25/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import "SignInEmailVC.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface SignInEmailVC (){
    
    __weak IBOutlet UISegmentedControl *_segment;
    __weak IBOutlet UIView *_viewSignUp;
    __weak IBOutlet UIView *_viewSignIn;
    __weak IBOutlet UILabel *_lbTitleVC;
    __weak IBOutlet TPKeyboardAvoidingScrollView *_scrollView;
    
}

@end

@implementation SignInEmailVC

- (void)viewDidLoad {
    [_scrollView contentSizeToFit];
    [super viewDidLoad];
    [self _setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private methods.
- (void)_setupUI {
    [self _showViewSignUp];
}
- (void)_showViewSignUp {
    [UIView animateWithDuration:0.0 animations:^{
        _lbTitleVC.text = @"Sign Up";
        _viewSignIn.alpha = 0.0f;
        _viewSignUp.alpha = 1.0f;
    }];
}

- (void)_showViewSignIn {
    [UIView animateWithDuration:0.0 animations:^{
        _lbTitleVC.text = @"Sign In";
        _viewSignUp.alpha = 0.0f;
        _viewSignIn.alpha = 1.0f;
    }];
}

#pragma mark - Actions
- (IBAction)__backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)__doneAction:(id)sender {
}

- (IBAction)__changeSegment:(id)sender {
    if (_segment.selectedSegmentIndex == 0) {
        [self _showViewSignUp];
    }else if (_segment.selectedSegmentIndex == 1) {
        [self _showViewSignIn];
    }
}

@end
