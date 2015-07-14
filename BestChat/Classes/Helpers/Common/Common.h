//
//  Common.h
//  BestChat
//
//  Created by HiepHN-imac on 5/20/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#ifndef BestChat_Common_h
#define BestChat_Common_h

@interface Common : NSObject

+ (void)LoginUser:(id)target;
+ (void)PostNotification:(NSString *)notification;
+ (NSString *)Date2String:(NSDate *)date;
+ (NSDate *)String2Date:(NSString *)dateStr;
+ (NSString *)TimeElapsed:(NSTimeInterval )seconds;

+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (BOOL)presentPhotoCamera:(id)target canEdit:(BOOL)canEdit;
+ (BOOL)presentVideoCamera:(id)target canEdit:(BOOL)canEdit;
+ (BOOL)presentMultiCamera:(id)target canEdit:(BOOL)canEdit;
+ (BOOL)presentPhotoLibrary:(id)target canEdit:(BOOL)canEdit;
+ (BOOL)presentVideoLibrary:(id)target canEdit:(BOOL)canEdit;
@end

#endif
