//
//  Enumeration.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/16.
//  Copyright © 2018年 xiaohai. All rights reserved.
//


typedef NS_ENUM(NSUInteger, CMVoicePlayState) {
    CMVoicePlayStateNormal,     /// 正常状态
    CMVoicePlayStatePlaying,    /// 正在播放状态(继续)
    CMVoicePlayStateStop,       /// 结束播放状态(暂停)
};

typedef NS_ENUM(NSUInteger, CMSendMessageType) {
    CMSendMessageTypeText,               /// 文本
    CMSendMessageTypeImage,              /// 图片
    CMSendMessageTypeDynamicImage,       /// 动态图片
    CMSendMessageTypeLocation,           /// 地理位置
};
