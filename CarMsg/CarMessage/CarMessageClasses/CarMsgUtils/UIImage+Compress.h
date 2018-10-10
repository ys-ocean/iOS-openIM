//
//  UIImage+Compress.h
//  DirectSelling
//
//  Created by 胡海峰 on 2017/6/28.
//  Copyright © 2017年 app. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)
- (UIImage *)fixOrientation:(UIImage *)aImage;

- (UIImage *)scaleImagetoSize:(CGSize)size toByte:(NSInteger)kb;

@end
