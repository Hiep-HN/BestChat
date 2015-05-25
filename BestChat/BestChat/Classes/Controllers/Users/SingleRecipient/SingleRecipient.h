//
//  SingleRecipient.h
//  BestChat
//
//  Created by HiepHN-imac on 5/21/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SingleRecipient : UITableViewController

@property (nonatomic, strong) void (^didSelectSingleUserBlock)(PFUser *);

@end
