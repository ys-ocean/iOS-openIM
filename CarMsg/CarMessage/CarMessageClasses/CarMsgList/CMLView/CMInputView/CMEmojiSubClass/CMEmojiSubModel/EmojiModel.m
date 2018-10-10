//
//  EmojiModel.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/8.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "EmojiModel.h"

@interface EmojiModel ()

@end

@implementation EmojiModel

+ (instancetype)initModelWithImageId:(NSString *)imageId desc:(NSString *)descName {
    EmojiModel * model = [[EmojiModel alloc]init];
    model.imageId = imageId;
    model.descName = descName;
    model.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@@2x",descName] ofType:@"png"]];
    return model;
}

+ (instancetype)initEmoticonInfoModelWithImageId:(NSString *)imageId desc:(NSString *)descName {
    EmojiModel * model = [[EmojiModel alloc]init];
    model.imageId = imageId;
    model.descName = descName;
    model.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@@2x",imageId] ofType:@"png"]];
    return model;
}


+ (CGFloat)height {
    CGSize size = [@"/" boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:CHAT_FONT} context:nil].size;
    return size.height;
}

+ (instancetype)initModelWithNewCode:(NSString *)code type:(NSString *)type {
    EmojiModel * model = [[EmojiModel alloc]init];
    model.code = code;
    model.type = type;
    return model;
}
@end

@implementation CMTextAttachment
@end
