//
//  Common.m
//  BestChat
//
//  Created by HiepHN-imac on 5/21/15.
//  Copyright (c) 2015 Hiep Huynh Ngoc. All rights reserved.
//

#import "Common.h"
#import "WelcomeVC.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation Common

+ (void)LoginUser:(id)target {
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[WelcomeVC alloc] init]];
    navi.navigationBarHidden = YES;
    [target presentViewController:navi animated:YES completion:nil];
}

+ (void)PostNotification:(NSString *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil];
}

+ (NSString *)Date2String:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'zzz'"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [formatter stringFromDate:date];
}

+ (NSDate *)String2Date:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'zzz'"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [formatter dateFromString:dateStr];
}

+ (NSString *)TimeElapsed:(NSTimeInterval )seconds
{
    NSString *elapsed;
    if (seconds < 60)
    {
        elapsed = @"Just now";
    }
    else if (seconds < 60 * 60)
    {
        int minutes = (int) (seconds / 60);
        elapsed = [NSString stringWithFormat:@"%d %@", minutes, (minutes > 1) ? @"mins" : @"min"];
    }
    else if (seconds < 24 * 60 * 60)
    {
        int hours = (int) (seconds / (60 * 60));
        elapsed = [NSString stringWithFormat:@"%d %@", hours, (hours > 1) ? @"hours" : @"hour"];
    }
    else
    {
        int days = (int) (seconds / (24 * 60 * 60));
        elapsed = [NSString stringWithFormat:@"%d %@", days, (days > 1) ? @"days" : @"day"];
    }
    return elapsed;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if([cleanString length] == 3) {
        
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
        
    }
    
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
}

+ (BOOL)presentPhotoCamera:(id)target canEdit:(BOOL)canEdit {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    NSString *type = (NSString *)kUTTypeImage;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] containsObject:type]) {
        imagePicker.mediaTypes = @[type];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
    }
    else return NO;
    
    imagePicker.allowsEditing = canEdit;
    imagePicker.showsCameraControls = YES;
    imagePicker.delegate = target;
    [target presentViewController:imagePicker animated:YES completion:nil];
    return YES;
}

+ (BOOL)presentVideoCamera:(id)target canEdit:(BOOL)canEdit {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    NSString *type = (NSString *)kUTTypeMovie;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] containsObject:type]) {
        imagePicker.mediaTypes = @[type];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoMaximumDuration = VIDEO_LENGTH;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }else if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
    }
    else return NO;
    
    imagePicker.allowsEditing = canEdit;
    imagePicker.showsCameraControls = YES;
    imagePicker.delegate = target;
    [target presentViewController:imagePicker animated:YES completion:nil];
    return YES;
}

+ (BOOL)presentMultiCamera:(id)target canEdit:(BOOL)canEdit {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    NSString *type1 = (NSString *)kUTTypeImage;
    NSString *type2 = (NSString *)kUTTypeMovie;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] containsObject:type1]) {
        imagePicker.mediaTypes = @[type1, type2];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoMaximumDuration = VIDEO_LENGTH;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    }else return NO;
    
    imagePicker.allowsEditing = canEdit;
    imagePicker.showsCameraControls = YES;
    imagePicker.delegate = target;
    [target presentViewController:imagePicker animated:YES completion:nil];
    return YES;
}

+ (BOOL)presentPhotoLibrary:(id)target canEdit:(BOOL)canEdit {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) {
        return NO;
    }
    
    NSString *type = (NSString *)kUTTypeImage;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:type]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObject:type];
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
             && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:type])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.mediaTypes = [NSArray arrayWithObject:type];
    }
    else return NO;
    imagePicker.allowsEditing = canEdit;
    imagePicker.delegate = target;
    [target presentViewController:imagePicker animated:YES completion:nil];
    return YES;
}

+ (BOOL)presentVideoLibrary:(id)target canEdit:(BOOL)canEdit {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) return NO;
    NSString *type = (NSString *)kUTTypeMovie;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.videoMaximumDuration = VIDEO_LENGTH;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:type])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObject:type];
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
             && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:type])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.mediaTypes = [NSArray arrayWithObject:type];
    }
    else return NO;
    imagePicker.allowsEditing = canEdit;
    imagePicker.delegate = target;
    [target presentViewController:imagePicker animated:YES completion:nil];
    return YES;

}
@end
