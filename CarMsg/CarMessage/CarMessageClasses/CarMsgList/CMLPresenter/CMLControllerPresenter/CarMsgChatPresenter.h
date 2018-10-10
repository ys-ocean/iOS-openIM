//
//  CarMsgChatPresenter.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/10.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarMsgChatPresenter : NSObject

- (YWConversation *)conversation;

+ (instancetype)presenterWithConversation:(YWConversation *)conversation;

/// 开始加载数据
- (void)startConversationWithMessageCount:(NSUInteger)count completion:(YWConversationLoadMessagesCompletion)completion;
/// 加载更多数据
- (void)loadMoreMessages:(NSUInteger)count completion:(YWConversationLoadMessagesCompletion)completion;

/// 删除一条消息 回调
- (void)deleteMessageId:(NSString *)messageId complete:(void (^)(NSIndexPath *))deleteMessageBlock;

/// 重发一条消息
- (void)rePostMessageId:(NSString *)messageId progress:(YWMessageSendingProgressBlock)aProgress
             completion:(YWMessageSendingCompletionBlock)aCompletion;

/// 设置N条消息已读
- (void)readMessageId:(NSArray *)messageIds;

/// 播放一条语音 回调
- (void)startPlayVoice:(NSData *)aData voiceId:(NSString *)voiceMessageId complete:(void (^)(NSString *, CMVoicePlayState))playVoiceStateBlock;
/// 更新Table
- (void)setUpdateContentMessageBlock:(void (^)(void))updateContentMessageBlock;
/// 插入一条新消息
- (void)setInsetContentMessageBlock:(void (^)(id<IYWMessage>))resetContentMessageBlock;

@end
