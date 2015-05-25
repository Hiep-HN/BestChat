//
//  PFUser+Util.h
//  BestChat
//
//  Created by HiepHN-imac on 5/25/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFUser (Util)

- (NSString *)fullName;

- (BOOL)isEqualTo:(PFUser *)user;
@end
