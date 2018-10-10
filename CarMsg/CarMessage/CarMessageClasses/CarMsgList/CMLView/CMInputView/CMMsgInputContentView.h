//
//  CMMsgInputContentView.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/5.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXOUIModule/YWRecordKit.h>
#import "CMMsgAllEmojiView.h"
@interface CMMsgInputContentView : UIView

@property (weak, nonatomic) IBOutlet UITextView * textView;

@property (strong, nonatomic) YWRecordKit * recordKit;
/// 表情视图
@property (strong, nonatomic) CMMsgAllEmojiView * emojiView;

/// 发送文本
- (void)setPostTextMessageBlock:(void (^)(NSString *))didPostTextMessageBlock;
/// 发送语言
- (void)setPostAudioMessageBlock:(void (^)(NSData *, NSTimeInterval))postAudioMessageBlock;
/// 发送地理位置
- (void)setPostLocationMessageBlock:(void (^)(CLLocationCoordinate2D, NSString *))postLocationMessageBlock;
/// 发送图片
- (void)setPostImageMessageBlock:(void (^)(UIImage *))postImageMessageBlock;
/// 发送动图
- (void)setPostDynamicImageMessageBlock:(void (^)(NSString *))postDynamicImageMessageBlock;
@end
