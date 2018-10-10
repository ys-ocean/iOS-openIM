//
//  CMPlugInPresenter.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/13.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMPlugInPresenter : NSObject

- (BOOL)getMediaIsAvailableFromSource:(UIImagePickerControllerSourceType)sourceType;
- (BOOL)getMediaIsPermissionFromSource:(UIImagePickerControllerSourceType)sourceType;
- (BOOL)getAudioIsPermission;
- (BOOL)getAudioIsAvailable;

@end
