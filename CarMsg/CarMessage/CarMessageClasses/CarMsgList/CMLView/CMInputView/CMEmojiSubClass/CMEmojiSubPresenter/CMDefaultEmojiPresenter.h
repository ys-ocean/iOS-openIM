//
//  CMDefaultEmojiPresenter.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/8.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMEmojiPageCellPresenter.h"
@interface CMDefaultEmojiPresenter : NSObject

@property (strong, nonatomic) NSMutableArray <CMEmojiPageCellPresenter *> * dataArray;

/// 项目表情包中的表情
+ (instancetype)instanceWithEmojiPlistName:(NSString *)name;

/// 新系统自带表情
+ (instancetype)instanceWithSystemNewEmojiPlistName:(NSString *)name;


/**
 接收到的字符串转成NSMutableAttributedString 用于YYLabel显示

 @param text 文本
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)processCommentContentWithEmoticonInfo:(NSString *)text;
@end
