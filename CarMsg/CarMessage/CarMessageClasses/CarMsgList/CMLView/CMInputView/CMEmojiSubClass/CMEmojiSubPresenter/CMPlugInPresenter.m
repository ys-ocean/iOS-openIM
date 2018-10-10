//
//  CMPlugInPresenter.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/13.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMPlugInPresenter.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@implementation CMPlugInPresenter

- (BOOL)getMediaIsAvailableFromSource:(UIImagePickerControllerSourceType)sourceType {
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied) {
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == AVAuthorizationStatusDenied) {
            return NO;
        }
        else {
            return YES;
        }
    }
}
- (BOOL)getMediaIsPermissionFromSource:(UIImagePickerControllerSourceType)sourceType {
    BOOL isAvailable = [UIImagePickerController isSourceTypeAvailable:sourceType];
    return isAvailable;
}
- (BOOL)getAudioIsPermission {
    AVAudioSession * session = [AVAudioSession sharedInstance];
    if(session.isInputAvailable) {
        return YES;
    }
    else {
         return NO;
    }
}
- (BOOL)getAudioIsAvailable {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    else {
        return YES;
    }
}

@end
