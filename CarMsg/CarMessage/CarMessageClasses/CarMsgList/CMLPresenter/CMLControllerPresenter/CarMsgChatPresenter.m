//
//  CarMsgChatPresenter.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/10.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CarMsgChatPresenter.h"
#import <AVFoundation/AVFoundation.h>
@interface CarMsgChatPresenter () <AVAudioPlayerDelegate>
@property (weak, nonatomic) YWConversation * conversation;
@property (strong, nonatomic) AVAudioPlayer * player;
@property (copy, nonatomic) NSString * voiceMessageId;
@property (copy, nonatomic) void(^playVoiceStateBlock)(NSString *,CMVoicePlayState);
@property (copy, nonatomic) void(^deleteMessageBlock)(NSIndexPath *);
@property (copy, nonatomic) void(^insetContentMessageBlock)(id<IYWMessage>);
@property (copy, nonatomic) void(^updateContentMessageBlock)(void);
@end

@implementation CarMsgChatPresenter

+ (instancetype)presenterWithConversation:(YWConversation *)conversation {
    CarMsgChatPresenter * p = [[CarMsgChatPresenter alloc]init];
    p.conversation = conversation;
    [p configuration];
    return p;
}

- (void)configuration {
    /// 监听事件中断通知
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:nil];
    /// fetchedObjects重新fetch的时候，回调该block(fetchedObjects里面的对象有可能重新构造了)
    [self.conversation setDidResetContentBlock:^{
        NSLog(@"fetchedObjects重新fetch的时候，回调该block(fetchedObjects里面的对象有可能重新构造了) block");
//        if (weak_self.updateContentMessageBlock) {
//            weak_self.updateContentMessageBlock();
//        }
    }];
    /// 内容即将发生变更时的回调 block
    [self.conversation setWillChangeContentBlock:^{
        NSLog(@"内容即将发生变更时的回调 block");
    }];
    /// 体消息变更的回调 block
    [self.conversation setDidChangeContentBlock:^{
        NSLog(@"体消息变更的回调 block");
    }];
    ///  内容已经完成变更的回调 block
    [self.conversation setObjectDidChangeBlock:^(id object, NSIndexPath *indexPath, YWObjectChangeType type, NSIndexPath *newIndexPath) {
        NSLog(@"内容已经完成变更的回调 block\n Obj:%@ \n indexPath:%@ \n type:%lu \n newIndexPath:%@ \n",object,indexPath,(unsigned long)type,newIndexPath);
        if (type == YWObjectChangeTypeDelete) {
            weak_self.deleteMessageBlock ? weak_self.deleteMessageBlock(indexPath) : nil;
        }
        else if (type == YWObjectChangeTypeInsert) {
            if (weak_self.insetContentMessageBlock) {
                weak_self.insetContentMessageBlock(object);
            }
        }
        else {
            if (weak_self.updateContentMessageBlock) {
                weak_self.updateContentMessageBlock();
            }
        }
    }];
}

- (void)startConversationWithMessageCount:(NSUInteger)count completion:(YWConversationLoadMessagesCompletion)completion {
    [self.conversation startConversationWithMessageCount:count completion:completion];
}

- (void)loadMoreMessages:(NSUInteger)count completion:(YWConversationLoadMessagesCompletion)completion {
    [self.conversation loadMoreMessages:count completion:completion];
}

- (void)deleteMessageId:(NSString *)messageId complete:(void (^)(NSIndexPath *))deleteMessageBlock {
    self.deleteMessageBlock = deleteMessageBlock;
    [self.conversation removeMessageWithMessageId:messageId];
}
- (void)rePostMessageId:(NSString *)messageId progress:(YWMessageSendingProgressBlock)aProgress
             completion:(YWMessageSendingCompletionBlock)aCompletion {
    id<IYWMessage> model = [self.conversation fetchMessageWithMessageId:messageId];
    [self.conversation asyncResendMessage:model progress:aProgress completion:aCompletion];
}
- (void)readMessageId:(NSArray *)messageIds {
    [self.conversation markMessageAsReadWithMessageIds:messageIds];
}

- (void)startPlayVoice:(NSData *)aData voiceId:(NSString *)voiceMessageId complete:(void (^)(NSString *, CMVoicePlayState))playVoiceStateBlock {
    self.playVoiceStateBlock = playVoiceStateBlock;
    
    if ([self.player isPlaying]) {
        /// 停止当前音频
        [self.player stop];
        if (self.playVoiceStateBlock) {
            self.playVoiceStateBlock(self.voiceMessageId, CMVoicePlayStateStop);
        }
        /// 开始下一段音频
        if (![self.voiceMessageId isEqualToString:voiceMessageId]) {
            [self initVoicePlayer:aData voiceId:voiceMessageId];
        }
    }
    else {
        /// 开始一段音频播放
        [self initVoicePlayer:aData voiceId:voiceMessageId];
    }
}

- (void)initVoicePlayer:(NSData *)aData voiceId:(NSString *)voiceMessageId {
    self.voiceMessageId = voiceMessageId;
    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    NSError * err = nil;
    /// 只支持播放
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:&err];
    [audioSession setActive:YES error:nil];
    
    NSError * error = nil;
    self.player = [[AVAudioPlayer alloc] initWithData:aData error:&error];
    if (self.player) {
        self.player.delegate = self;
        [self.player play];
        if (self.playVoiceStateBlock) {
            self.playVoiceStateBlock(self.voiceMessageId, CMVoicePlayStatePlaying);
        }
    }
}

// 监听中断通知调用的方法
- (void)audioSessionInterruptionNotification:(NSNotification *)notification{
    
    /*
     监听到的中断事件通知,AVAudioSessionInterruptionOptionKey
     
     typedef NS_ENUM(NSUInteger, AVAudioSessionInterruptionType)
     {
     AVAudioSessionInterruptionTypeBegan = 1, 中断开始
     AVAudioSessionInterruptionTypeEnded = 0,  中断结束
     }
     
     */
    
    int type = [notification.userInfo[AVAudioSessionInterruptionOptionKey] intValue];
    
    switch (type) {
        case AVAudioSessionInterruptionTypeBegan: // 被打断
            [self.player pause];
            if (self.voiceMessageId) {
                
                if (self.playVoiceStateBlock) {
                    self.playVoiceStateBlock(self.voiceMessageId, CMVoicePlayStateStop);
                }
            }
            break;
        case AVAudioSessionInterruptionTypeEnded: // 中断结束
            [self.player play];
            if (self.voiceMessageId) {
                
                if (self.playVoiceStateBlock) {
                    self.playVoiceStateBlock(self.voiceMessageId, CMVoicePlayStatePlaying);
                }
            }
            break;
        default:
            break;
    }
}

/// 播放完成
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.voiceMessageId) {
        
        if (self.playVoiceStateBlock) {
            self.playVoiceStateBlock(self.voiceMessageId, CMVoicePlayStateStop);
        }
        /// 播放完成 置空
        self.voiceMessageId = @"";
    }
}

/// 解码错误的时候会调用这个方法
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"音频解析出错!");
    if (self.voiceMessageId) {

        if (self.playVoiceStateBlock) {
            self.playVoiceStateBlock(self.voiceMessageId, CMVoicePlayStateStop);
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.player stop];
    self.player = nil;
}

@end
