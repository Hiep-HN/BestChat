//
//  ChatView.m
//  BestChat
//
//  Created by HiepHN-imac on 5/21/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import "ChatView.h"
#import "ProgressHUD.h"
#import "JSQMessages.h"
#import "PhotoMediaItem.h"
#import "VideoMediaItem.h"
#import "IDMPhotoBrowser.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Common.h"
#import "Backend.h"

@interface ChatView (){
    NSTimer *_timer;
    BOOL _isLoading;
    BOOL _initialized;
    
    NSString *_groupId;
    NSMutableArray *_users;
    NSMutableArray *_messages;
    NSMutableDictionary *_avatars;
    
    JSQMessagesBubbleImage *_bubbleImageOutgoing;
    JSQMessagesBubbleImage *_bubbleImageIncoming;
    JSQMessagesAvatarImage *_avatarImageBlank;
}
@end

@implementation ChatView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Chat";
    
    
    _users = [[NSMutableArray alloc] init];
    _messages = [[NSMutableArray alloc] init];
    _avatars = [[NSMutableDictionary alloc] init];
    
    PFUser *user = [PFUser currentUser];
    if (user) {
        self.senderId = user.objectId;
        self.senderDisplayName = user[PF_USER_FULLNAME];
    }
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    _bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:COLOR_OUTGOING];
    _bubbleImageIncoming = [bubbleFactory incomingMessagesBubbleImageWithColor:COLOR_INCOMING];
    
    _avatarImageBlank = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"chat_blank"] diameter:30.0];
    
    _isLoading = NO;
    _initialized = NO;
    [self _loadMessages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(_loadMessages) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self _clearRecentCounter:_groupId];
    [_timer invalidate];
}

#pragma mark - Public methods.
- (id)initWith:(NSString *)groupId {
    self = [super init];
    _groupId = groupId;
    return self;
}

#pragma mark - Private methods.
- (void)_loadMessages {
    if (!_isLoading) {
        _isLoading = YES;
        JSQMessage *message_last = [_messages lastObject];
        PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGE_CLASS_NAME];
        [query whereKey:PF_MESSAGE_GROUPID equalTo:_groupId];
        if (message_last) {
            [query whereKey:PF_MESSAGE_CREATEDAT greaterThan:message_last.date];
        }
        [query includeKey:PF_MESSAGE_USER];
        [query orderByDescending:PF_MESSAGE_CREATEDAT];
        [query setLimit:50];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                BOOL inComing = NO;
                self.automaticallyScrollsToMostRecentMessage = NO;
                for (PFObject *object in [objects reverseObjectEnumerator]) {
                    JSQMessage *message = [self _addMessage:object];
                    if ([self _inComing:message]) {
                        inComing = YES;
                    }
                }
                if ([objects count] != 0) {
                    if (_initialized && inComing) {
                        [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
                    }
                    [self finishReceivingMessage];
                    [self scrollToBottomAnimated:NO];
                }
                self.automaticallyScrollsToMostRecentMessage = YES;
                _initialized = YES;
            }else {
                [ProgressHUD showError:@"Network error."];
            }
            _isLoading = NO;
        }];
    }
}
- (void)_clearRecentCounter:(NSString *)groupId_ {
    PFUser *user = [PFUser currentUser];
    if (user) {
        PFQuery *query = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
        [query whereKey:PF_RECENT_GROUPID equalTo:groupId_];
        [query whereKey:PF_RECENT_USER equalTo:user];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *recent in objects) {
                    recent[PF_RECENT_COUNTER] = @0;
                    [recent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error != nil) {
                            NSLog(@"ClearRecentCounter save error.");
                        }
                    }];
                }
            }else {
                NSLog(@"ClearRecentCounter query error.");
            }
        }];
    }
   
}

- (JSQMessage *)_addMessage:(PFObject *)object {
    JSQMessage *message;
    
    PFUser *user = object[PF_MESSAGE_USER];
    NSString *name = user[PF_USER_FULLNAME];
    
    PFFile *fileVideo = object[PF_MESSAGE_VIDEO];
    PFFile *filePicture = object[PF_MESSAGE_PICTURE];
    
    if ((!filePicture) && (!fileVideo)) {
        message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:name date:object.createdAt text:object[PF_MESSAGE_TEXT]];
    }
    
    if (fileVideo != nil) {
        JSQVideoMediaItem *mediaItem = [[JSQVideoMediaItem alloc] initWithFileURL:[NSURL URLWithString:fileVideo.url] isReadyToPlay:YES];
        mediaItem.appliesMediaViewMaskAsOutgoing = [user.objectId isEqualToString:self.senderId];
        message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:name date:object.createdAt media:mediaItem];
    }
    
    if (filePicture != nil) {
        JSQPhotoMediaItem *mediaItem = [[JSQPhotoMediaItem alloc] initWithImage:nil];
        mediaItem.appliesMediaViewMaskAsOutgoing = [user.objectId isEqualToString:self.senderId];
        message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:name date:object.createdAt media:mediaItem];
        [filePicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error == nil) {
                mediaItem.image = [UIImage imageWithData:data];
                [self.collectionView reloadData];
            }
        }];
    }
    
    [_users addObject:user];
    [_messages addObject:message];
    
    return message;
}

- (void)_sendMessage:(NSString *)text video:(NSURL *)video picture:(UIImage *)picture {
    PFFile *fileVideo = nil;
    PFFile *filePicture = nil;
    
    if (video != nil) {
        text = @"[Video message]";
        fileVideo = [PFFile fileWithName:@"video.mp4" data:[[NSFileManager defaultManager] contentsAtPath:video.path]];
        [fileVideo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error != nil) {
                [ProgressHUD showError:@"Network error."];
            }
        }];
    }
    if (picture != nil) {
        text = @"[Picture message]";
        filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(picture, 0.6)];
        [filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error != nil) {
                [ProgressHUD showError:@"Picture save error."];
            }
        }];
    }
    
    PFObject *object = [PFObject objectWithClassName:PF_MESSAGE_CLASS_NAME];
    object[PF_MESSAGE_USER] = [PFUser currentUser];
    object[PF_MESSAGE_GROUPID] = _groupId;
    object[PF_MESSAGE_TEXT] = text;
    if (fileVideo != nil) {
        object[PF_MESSAGE_VIDEO] = fileVideo;
    }
    if (filePicture != nil) {
        object[PF_MESSAGE_PICTURE] = filePicture;
    }
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error == nil) {
            [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
            [self _loadMessages];
        }else {
            [ProgressHUD showError:@"Network error."];
        }
    }];
    
    [self _sendPushNotification:_groupId text:text];
    [self _updateRecentCounter:_groupId Amount:1 lastMessage:text];
    
    [self finishSendingMessage];
}

- (void)_sendPushNotification:(NSString *)groupId text:(NSString *)text {
    PFUser *user = [PFUser currentUser];
    NSString *message = [NSString stringWithFormat:@"%@: %@", user[PF_USER_FULLNAME], text];
    
    PFQuery *query = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
    [query whereKey:PF_RECENT_GROUPID equalTo:groupId];
    [query whereKey:PF_RECENT_USER notEqualTo:user];
    [query includeKey:PF_RECENT_USER];
    [query setLimit:1000];
    
    PFQuery *queryInstallation = [PFInstallation query];
    [queryInstallation whereKey:PF_INSTALLATION_USER matchesKey:PF_RECENT_USER inQuery:query];
    
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:queryInstallation];
    [push setMessage:message];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error != nil) {
            NSLog(@"SendPushNotification send error.");
        }
    }];
}

- (void)_updateRecentCounter:(NSString *)groupId Amount:(NSInteger )amount lastMessage:(NSString *)lastMessage {
    PFQuery *query = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
    [query whereKey:PF_RECENT_GROUPID equalTo:groupId];
    [query includeKey:PF_RECENT_USER];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             for (PFObject *recent in objects)
             {
                 if ([recent[PF_RECENT_USER] isEqualTo:[PFUser currentUser]] == NO)
                     [recent incrementKey:PF_RECENT_COUNTER byAmount:[NSNumber numberWithInteger:amount]];
                 
                 recent[PF_RECENT_LASTUSER] = [PFUser currentUser];
                 recent[PF_RECENT_LASTMESSAGE] = lastMessage;
                 recent[PF_RECENT_UPDATEDACTION] = [NSDate date];
                 [recent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                  {
                      if (error != nil) NSLog(@"UpdateRecentCounter save error.");
                  }];
             }
         }
         else NSLog(@"UpdateRecentCounter query error.");
     }];

}
- (BOOL)_inComing:(JSQMessage *)message {
    return ([message.senderId isEqualToString:self.senderId] == NO);
}

- (BOOL)_outGoing:(JSQMessage *)message {
    return [message.senderId isEqualToString:self.senderId] == YES;
}

- (void)_loadAvatar:(PFUser *)user {
    PFFile *file = user[PF_USER_THUMBNAIL];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (error == nil) {
            _avatars[user.objectId] = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageWithData:data] diameter:30.0];
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - JSQMessagesViewController.

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    [self _sendMessage:text video:nil picture:nil];
}

- (void)didPressAccessoryButton:(UIButton *)sender {
    [self.view endEditing:YES];
    NSArray *menuItems = @[[[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_camera"] title:@"Camera"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_audio"] title:@"Audio"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_pictures"] title:@"Pictures"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_videos"] title:@"Videos"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_location"] title:@"Location"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"chat_stickers"] title:@"Stickers"]];
    RNGridMenu *gridMenu = [[RNGridMenu alloc] initWithItems:menuItems];
    gridMenu.delegate = self;
    [gridMenu showInViewController:self center:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/ 2.0f)];
}

#pragma mark - JSQMessage CollectionView.
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _messages[indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self _outGoing:_messages[indexPath.item]]) {
        return _bubbleImageOutgoing;
    }else {
        return _bubbleImageIncoming;
    }
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    PFUser *user = _users[indexPath.item];
    if (_avatars[user.objectId] == nil) {
        [self _loadAvatar: user];
        return _avatarImageBlank;
    }else
        return _avatars[user.objectId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = _messages[indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }else return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = _messages[indexPath.item];
    if ([self _inComing:message]) {
        if (indexPath.item > 0) {
            JSQMessage *previous = _messages[indexPath.item - 1];
            if ([previous.senderId isEqualToString:message.senderId]) {
                return nil;
            }
        }
        return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
    }
    else return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_messages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    if ([self _outGoing:_messages[indexPath.item]]) {
        cell.textView.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.textView.textColor = [UIColor blackColor];
    }
    return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    else return 0;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = _messages[indexPath.item];
    if ([self _inComing:message]) {
        if (indexPath.item > 0) {
            JSQMessage *previous = _messages[indexPath.item - 1];
            if ([previous.senderId isEqualToString:message.senderId]) {
                return 0;
            }
        }
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    else return 0;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

#pragma mark - Responding to collection view tap events
- (void)collectionView:(JSQMessagesCollectionView *)collectionView header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender {
    NSLog(@"didTapLoadEarlierMessagesButton");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = _messages[indexPath.item];
    if ([self _inComing:message]) {
        //
    }
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = _messages[indexPath.item];
    if (message.isMediaMessage) {
        if ([message.media isKindOfClass:[PhotoMediaItem class]]) {
            PhotoMediaItem *mediaItem = (PhotoMediaItem *)message.media;
            NSArray *photos = [IDMPhoto photosWithImages:@[mediaItem.image]];
            IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
            [self presentViewController:browser animated:YES completion:nil];
        }
        if ([message.media isKindOfClass:[VideoMediaItem class]]) {
            VideoMediaItem *mediaItem = (VideoMediaItem *)message.media;
            MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:mediaItem.fileURL];
            [self presentMoviePlayerViewControllerAnimated:moviePlayer];
            [moviePlayer.moviePlayer play];
        }
    }
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation {
    NSLog(@"didTapCellAtIndexPath %@", NSStringFromCGPoint(touchLocation));
}

#pragma mark - RNGridMenuDelegate

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    [gridMenu dismissAnimated:NO];
    if ([item.title isEqualToString:@"Camera"]) {
        [Common presentMultiCamera:self canEdit:YES];
    }
    if ([item.title isEqualToString:@"Pictures"]) {
        [Common presentPhotoLibrary:self canEdit:YES];
    }
    if ([item.title isEqualToString:@"Videos"]) {
        [Common presentVideoLibrary:self canEdit:YES];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL *video = info[UIImagePickerControllerMediaURL];
    UIImage *picture = info[UIImagePickerControllerEditedImage];
    
    [self _sendMessage:nil video:video picture:picture];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
