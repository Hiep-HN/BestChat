//
//  SignInEmailVC.m
//  BestChat
//
//  Created by HiepHN-imac on 5/25/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import "SignInEmailVC.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ProgressHUD.h"

@interface SignInEmailVC ()<UITextFieldDelegate> {
    
    __weak IBOutlet UISegmentedControl *_segment;
    __weak IBOutlet UIView *_viewSignUp;
    __weak IBOutlet UIView *_viewSignIn;
    __weak IBOutlet UILabel *_lbTitleVC;
    __weak IBOutlet TPKeyboardAvoidingScrollView *_scrollView;
    
    __weak IBOutlet UITextField *_txtFirstName;
    __weak IBOutlet UITextField *_txtLastName;
    __weak IBOutlet UITextField *_txtEmailSignUp;
    __weak IBOutlet UITextField *_txtPassSignUp;
    
    __weak IBOutlet UITextField *_txtEmailSignIn;
    __weak IBOutlet UITextField *_txtPassSignIn;
    BOOL _isSignIn;
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
        _isSignIn = false;
    }];
}

- (void)_showViewSignIn {
    [UIView animateWithDuration:0.0 animations:^{
        _lbTitleVC.text = @"Sign In";
        _viewSignUp.alpha = 0.0f;
        _viewSignIn.alpha = 1.0f;
        _isSignIn = true;
    }];
}

#pragma mark - UITextField.
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _txtFirstName) {
        _txtFirstName.placeholder = nil;
    }else if (textField == _txtLastName) {
        _txtLastName.placeholder = nil;
    }else if (textField == _txtEmailSignUp) {
        _txtEmailSignUp.placeholder = nil;
    }else if (textField == _txtPassSignUp) {
        _txtPassSignUp.placeholder = nil;
    }else if (textField == _txtEmailSignIn) {
        _txtEmailSignIn.placeholder = nil;
    }else if (textField == _txtPassSignIn) {
        _txtPassSignIn.placeholder = nil;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _txtFirstName) {
        if ([_txtFirstName.text isEqualToString:@""]) {
            _txtFirstName.text = @"";
            _txtFirstName.placeholder = @"  your first name";
        }
        
    }else if (textField == _txtLastName) {
        if ([_txtLastName.text isEqualToString:@""]) {
            _txtLastName.text = @"";
            _txtLastName.placeholder = @"  your last name";
        }
    }else if (textField == _txtEmailSignUp) {
        if ([_txtEmailSignUp.text isEqualToString:@""]) {
            _txtEmailSignUp.text = @"";
            _txtEmailSignUp.placeholder = @" email@example.com";
        }
    }else if (textField == _txtPassSignUp) {
        if ([_txtPassSignUp.text isEqualToString:@""]) {
            _txtPassSignUp.text = @"";
            _txtPassSignUp.placeholder = @" at least 6 charaters";
        }
    }else if (textField == _txtEmailSignIn) {
        if ([_txtEmailSignIn.text isEqualToString:@""]) {
            _txtEmailSignIn.text = @"";
            _txtEmailSignIn.placeholder = @"  email@example.com";
        }
    }else if (textField == _txtPassSignIn) {
        if ([_txtPassSignIn.text isEqualToString:@""]) {
            _txtPassSignIn.text = @"";
            _txtPassSignIn.placeholder = @"  at least 6 charaters";
        }
    }
}
#pragma mark - Actions
- (IBAction)__backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)__doneAction:(id)sender {
    if (_isSignIn) {
        //
    }else {
        NSString *name = [NSString stringWithFormat:@"%@ %@",_txtFirstName.text, _txtLastName];
        NSString *password = _txtPassSignUp.text;
        NSString *email = [_txtEmailSignUp.text lowercaseString];
        if ([name length] < 8) {
            [ProgressHUD showError:@"Name is too short."];
            return;
        }
        if ([password length] == 0) {
            [ProgressHUD showError:@"Password must be set."];
            return;
        }
        if ([email length] == 0) {
            [ProgressHUD showError:@"Email must be set."];
            return;
        }
        
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        
        PFUser *user = [PFUser user];
        user.username = email;
        user.password = password;
        user.email = email;
        user[PF_USER_EMAILCOPY] = email;
        user[PF_USER_FULLNAME] = name;
        user[PF_USER_FULLNAME_LOWER] = [name lowercaseString];
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error == nil) {
                [ProgressHUD showSuccess:@"Success."];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else {
                [ProgressHUD showError:error.userInfo[@"error"]];
            }
        }];
    }
}

- (IBAction)__changeSegment:(id)sender {
    if (_segment.selectedSegmentIndex == 0) {
        [self _showViewSignUp];
    }else if (_segment.selectedSegmentIndex == 1) {
        [self _showViewSignIn];
    }
}
- (IBAction)__changeAvatar:(id)sender {
}

@end
