//
//  CMMsgInputViewPresenter.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/5.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMMsgInputViewPresenter.h"

@interface CMMsgInputViewPresenter ()
@property (weak, nonatomic) YWConversation * conversation;

@end

@implementation CMMsgInputViewPresenter

+ (instancetype)presenterWithConversation:(YWConversation *)conversation {
    CMMsgInputViewPresenter * p = [[CMMsgInputViewPresenter alloc]init];
    p.conversation = conversation;
    return p;
}

- (void)asyncSendTextMessage:(NSString *)text progress:(YWMessageSendingProgressBlock)aProgress
                  completion:(YWMessageSendingCompletionBlock)aCompletion {
    
    YWMessageBodyText * textMessageBody = [[YWMessageBodyText alloc] initWithMessageText:text];

    [self.conversation asyncSendMessageBody:textMessageBody progress:aProgress completion:aCompletion];
}

/// 发送动态表情
- (void)asyncSendGifMessage:(NSString *)imagePath progress:(YWMessageSendingProgressBlock)aProgress
                 completion:(YWMessageSendingCompletionBlock)aCompletion {
    YWMessageBodyCustomize * gifImageMessageBody = [[YWMessageBodyCustomize alloc] initWithMessageCustomizeContent:imagePath summary:@"动图"];
    [self.conversation asyncSendMessageBody:gifImageMessageBody progress:nil completion:aCompletion];
}

/// 发送语音
- (void)asyncSendVoiceMessage:(NSData *)wavData nRecordingTime:(double)nRecordingTime progress:(YWMessageSendingProgressBlock)aProgress
                   completion:(YWMessageSendingCompletionBlock)aCompletion {
    YWMessageBodyVoice * bodyVoice = [[YWMessageBodyVoice alloc] initWithMessageVoiceData:wavData duration:nRecordingTime];
    [self.conversation asyncSendMessageBody:bodyVoice progress:aProgress completion:aCompletion];
}

/// 发送图片
- (void)asyncSendImageMessage:(UIImage *)image progress:(YWMessageSendingProgressBlock)aProgress completion:(YWMessageSendingCompletionBlock)aCompletion {
    YWMessageBodyImage * imageMessageBody = [[YWMessageBodyImage alloc] initWithMessageImage:image];

    [self.conversation asyncSendMessageBody:imageMessageBody progress:aProgress completion:aCompletion];
}

/// 发送地理位置
- (void)asyncSendLocationMessage:(CLLocationCoordinate2D)location name:(NSString *)name progress:(YWMessageSendingProgressBlock)aProgress
                      completion:(YWMessageSendingCompletionBlock)aCompletion {
    YWMessageBodyLocation * messageBody = [[YWMessageBodyLocation alloc] initWithMessageLocation:location locationName:name];

    [self.conversation asyncSendMessageBody:messageBody progress:nil completion:aCompletion];
}

@end
