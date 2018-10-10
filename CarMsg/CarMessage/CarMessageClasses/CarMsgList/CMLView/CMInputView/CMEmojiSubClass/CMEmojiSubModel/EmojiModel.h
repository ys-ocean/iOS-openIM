//
//  EmojiModel.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/8.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CMTextAttachment;
@interface EmojiModel : NSObject
/// eg: 001  
@property (copy, nonatomic) NSString * imageId;
/// eg: [微笑]
@property (copy, nonatomic) NSString * descName;
/// 表情图片
@property (strong, nonatomic) UIImage * image;

/// 根据desc 生成图片
+ (instancetype)initModelWithImageId:(NSString *)imageId desc:(NSString *)descName;

/// 根据ImageId生成图片
+ (instancetype)initEmoticonInfoModelWithImageId:(NSString *)imageId desc:(NSString *)descName;


/** 新表情 */
@property (copy, nonatomic) NSString * code;
@property (copy, nonatomic) NSString * type;
+ (instancetype)initModelWithNewCode:(NSString *)code type:(NSString *)type;


@end

@interface CMTextAttachment : NSTextAttachment
@property (copy, nonatomic) NSString * imageName;
@end
