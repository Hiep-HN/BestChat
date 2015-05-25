//
//  PFUser+Util.m
//  BestChat
//
//  Created by HiepHN-imac on 5/25/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import "PFUser+Util.h"

@implementation PFUser (Util)

- (NSString *)fullName {
    return self[PF_USER_FULLNAME];
}

- (BOOL)isEqualTo:(PFUser *)user {
    return [self.objectId isEqualToString:user.objectId];
}
@end
