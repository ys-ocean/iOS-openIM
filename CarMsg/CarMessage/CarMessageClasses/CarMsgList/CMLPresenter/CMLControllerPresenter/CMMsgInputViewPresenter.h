//
//  CMMsgInputViewPresenter.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/5.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMMsgInputViewPresenter : NSObject

+ (instancetype)presenterWithConversation:(YWConversation *)conversation;

/// 发送文本
- (void)asyncSendTextMessage:(NSString *)text progress:(YWMessageSendingProgressBlock)aProgress
                  completion:(YWMessageSendingCompletionBlock)aCompletion;
/// 发送动态表情
- (void)asyncSendGifMessage:(NSString *)imagePath progress:(YWMessageSendingProgressBlock)aProgress
                 completion:(YWMessageSendingCompletionBlock)aCompletion;
/// 发送语音
- (void)asyncSendVoiceMessage:(NSData *)wavData nRecordingTime:(double)nRecordingTime progress:(YWMessageSendingProgressBlock)aProgress
                      completion:(YWMessageSendingCompletionBlock)aCompletion;
/// 发送图片
- (void)asyncSendImageMessage:(UIImage *)image progress:(YWMessageSendingProgressBlock)aProgress completion:(YWMessageSendingCompletionBlock)aCompletion;

/// 发送地理位置
- (void)asyncSendLocationMessage:(CLLocationCoordinate2D)location name:(NSString *)name progress:(YWMessageSendingProgressBlock)aProgress
                      completion:(YWMessageSendingCompletionBlock)aCompletion;

@end
