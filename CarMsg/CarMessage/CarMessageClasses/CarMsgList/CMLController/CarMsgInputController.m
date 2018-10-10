//
//  CarMsgInputController.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/10.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CarMsgInputController.h"

@interface CarMsgInputController ()
@property (strong, nonatomic) CMMsgInputViewPresenter * presenter;

@property (strong, nonatomic) CMMsgInputContentView * contentView;

@end

@implementation CarMsgInputController
+ (instancetype)instanceWithPresenter:(CMMsgInputViewPresenter *)presenter {
    CarMsgInputController * vc = [[CarMsgInputController alloc]init];
    vc.presenter = presenter;
    [vc configuration];
    return vc;
}

- (void)configuration {
    
    @weakify(self);
    [self.contentView setPostTextMessageBlock:^(NSString * text) {
        [weak_self sendMsg:text];
    }];
    [self.contentView setPostAudioMessageBlock:^(NSData * aData, NSTimeInterval aDuration) {
        [weak_self sendAudio:aData duration:aDuration];
    }];
    [self.contentView setPostImageMessageBlock:^(UIImage * aImage) {
        [weak_self sendImage:aImage];
    }];
    [self.contentView setPostLocationMessageBlock:^(CLLocationCoordinate2D aCoordinate, NSString * title) {
        [weak_self sendLocation:aCoordinate title:title];
    }];
    [self.contentView setPostDynamicImageMessageBlock:^(NSString * gifImageName) {
        [weak_self sendGifImage:gifImageName];
    }];

}

/// 发送地理位置
- (void)sendLocation:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle {
    @weakify(self);
    [self.presenter asyncSendLocationMessage:aCoordinate name:aTitle progress:^(CGFloat progress, NSString *messageID) {

    } completion:^(NSError *error, NSString *messageID) {
        [[NSNotificationCenter defaultCenter]postNotificationName:CMMessageSendCompleteKey object:nil userInfo:nil];
        if (!error) {
            NSLog(@"发送位置成功");
        }
        else {
            [weak_self showStatusToastForString:@"地理信息发送失败"];
        }
    }];
}

- (void)sendGifImage:(NSString *)gifImageName {
    
    @weakify(self);
    [self.presenter asyncSendGifMessage:gifImageName progress:^(CGFloat progress, NSString *messageID) {
        
    } completion:^(NSError *error, NSString *messageID) {
        [[NSNotificationCenter defaultCenter]postNotificationName:CMMessageSendCompleteKey object:nil userInfo:nil];
        if (!error) {
            NSLog(@"动图发送成功");
        }
        else {
            [weak_self showStatusToastForString:@"动图发送失败"];
        }
    }];
}

/// 发送图片
- (void)sendImage:(UIImage *)aImage {
    @weakify(self);
    __block BOOL isSendImage = NO;
    [self.presenter asyncSendImageMessage:aImage progress:^(CGFloat progress, NSString *messageID) {
        if (!isSendImage) {
            isSendImage = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:CMMessageSendCompleteKey object:nil userInfo:nil];
        }
    } completion:^(NSError *error, NSString *messageID) {
        [[NSNotificationCenter defaultCenter]postNotificationName:CMMessageSendCompleteKey object:nil userInfo:nil];
        if (!error) {
            NSLog(@"发送图片成功");
        }
        else {
            [weak_self showStatusToastForString:@"图片发送失败"];
        }
    }];
    
}

/// 发送语音
- (void)sendAudio:(NSData *)aData duration:(NSTimeInterval)aDuration {
    @weakify(self);
    [self.presenter asyncSendVoiceMessage:aData nRecordingTime:aDuration progress:^(CGFloat progress, NSString *messageID) {

    } completion:^(NSError *error, NSString *messageID) {
        [[NSNotificationCenter defaultCenter]postNotificationName:CMMessageSendCompleteKey object:nil userInfo:nil];
        if (!error) {
            NSLog(@"发送语音成功");
        }
        else {
            [weak_self showStatusToastForString:@"语音发送失败"];
        }
    }];
}

/// 发送文本
- (void)sendMsg:(NSString *)text {
    @weakify(self);
    [self.presenter asyncSendTextMessage:text progress:^(CGFloat progress, NSString *messageID) {

    } completion:^(NSError *error, NSString *messageID) {
        [[NSNotificationCenter defaultCenter]postNotificationName:CMMessageSendCompleteKey object:nil userInfo:nil];
        if (!error) {
            NSLog(@"发送文本成功");
        }
        else {
           [weak_self showStatusToastForString:@"文本发送失败"];
        }
    }];
}

- (void)showStatusToastForString:(NSString *)msg {
    [self.contentView showToastWithText:msg position:CSToastPositionCenter];
}

- (CMMsgInputContentView *)contentView {
    if (!_contentView) {
        _contentView = FETCHVIEW_XIB(@"CMMsgInputContentView", nil, nil, 0);
    }
    return _contentView;
}

@end
