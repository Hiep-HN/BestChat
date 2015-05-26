//
//  VideoMediaItem.h
//  BestChat
//
//  Created by HiepHN-imac on 5/26/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import "JSQMediaItem.h"

@interface VideoMediaItem : JSQMediaItem

@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, assign) BOOL  isReadyToPlay;

@property (copy, nonatomic) UIImage *image;

- (instancetype)initWithFileURL: (NSURL *)fileURL isReadyToPlay:(BOOL)isReadyToPlay;

@end
