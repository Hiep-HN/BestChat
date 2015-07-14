//
//  RecentCell.m
//  BestChat
//
//  Created by HiepHN-imac on 5/21/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import "RecentCell.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

#import "Define.h"
#import "Common.h"

@interface RecentCell (){
    PFObject *_recent;
}

@property (weak, nonatomic) IBOutlet PFImageView *imageUser;
@property (weak, nonatomic) IBOutlet UILabel *lbNameUser;
@property (weak, nonatomic) IBOutlet UILabel *lbLastMessage;
@property (weak, nonatomic) IBOutlet UILabel *lbElapsed;
@property (weak, nonatomic) IBOutlet UILabel *lbCounter;

@end
@implementation RecentCell
@synthesize imageUser;
@synthesize lbNameUser, lbLastMessage, lbElapsed, lbCounter;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindData:(PFObject *)recent {
    _recent = recent;
    
    imageUser.layer.cornerRadius = imageUser.frame.size.width/ 2;
    imageUser.layer.masksToBounds = YES;
    
    PFUser *lastUser = _recent[PF_RECENT_LASTUSER];
    [imageUser setFile:lastUser[PF_USER_PICTURE]];
    [imageUser loadInBackground];
    
    lbNameUser.text = _recent[PF_RECENT_DESCRIPTION];
    lbLastMessage.text = _recent[PF_RECENT_LASTMESSAGE];
    
    NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:_recent[PF_RECENT_UPDATEDACTION]];
    lbElapsed.text = [Common TimeElapsed:seconds];
    
    int counter = [_recent[PF_RECENT_COUNTER] intValue];
    lbCounter.text = (counter == 0) ? @"" : [NSString stringWithFormat:@"%d new", counter];
}

@end
