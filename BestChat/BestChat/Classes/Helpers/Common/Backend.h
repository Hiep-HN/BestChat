//
//  Backend.h
//  BestChat
//
//  Created by HiepHN-imac on 5/26/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Backend : NSObject

+ (NSString *)startPrivateChat: (PFUser *)user1 user2:(PFUser *)user2;
+ (NSString *)StartMultipleChat: (NSMutableArray *)users;

+ (void)createRecentItem:(PFUser *)user
                 groupId:(NSString *)groupId
                  member:(NSArray *)members
             description:(NSString *)description;
+ (void)updateRecentCounter:(NSString *)groupId
                     amount:(NSInteger)amount
                lastMessage:(NSString *)lastMessage;
+ (void)clearRecentCounter:(NSString *)groupId;
+ (void)deleteRecentItems:(PFUser *)user1
                    user2:(PFUser *)user2;
@end
