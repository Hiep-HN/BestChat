//
//  PhotoMediaItem.h
//  BestChat
//
//  Created by HiepHN-imac on 5/26/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import "JSQMediaItem.h"

@interface PhotoMediaItem : JSQMediaItem


@property (copy, nonatomic) UIImage *image;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *height;

- (instancetype)initWithImage:(UIImage *)image Width:(NSNumber *)width Height:(NSNumber *)height;
@end
