//
//  ChatView.h
//  BestChat
//
//  Created by HiepHN-imac on 5/21/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import "RNGridMenu.h"
#import "JSQMessage.h"

@interface ChatView : JSQMessagesViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, RNGridMenuDelegate>

- (id)initWith:(NSString *)groupId;

@end
