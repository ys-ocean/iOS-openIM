//
//  CMConst.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/2.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <Foundation/Foundation.h>

/// CarMsgListViewController 场景使用的
/// 消息动态
UIKIT_EXTERN NSString *const CarMsgListViewMessageDynamic;
UIKIT_EXTERN NSString *const CarMsgListViewMessageSystem;


/// 表情删除
UIKIT_EXTERN NSString *const CarMsgEmojiDeleteKey;

/// 发送消息通知
UIKIT_EXTERN NSString *const CMSendNotificationKey;
/// 类型
UIKIT_EXTERN NSString *const CMSendMsgNotificationTypeKey;
/// 经度
UIKIT_EXTERN NSString *const CMSendMsgSubNotifiLongitudeKey;
/// 纬度
UIKIT_EXTERN NSString *const CMSendMsgSubNotifiLatitudeKey;
/// 地理位置名称
UIKIT_EXTERN NSString *const CMSendMsgSubNotifiLocationNameKey;
/// 图片
UIKIT_EXTERN NSString *const CMSendMsgSubNotifiImageKey;

/// 表情
UIKIT_EXTERN NSString *const CMEmojiDidSelectNotification;
UIKIT_EXTERN NSString *const CMEmojiDidDeleteNotification;
UIKIT_EXTERN NSString *const CMEmojiDidSelectKey;

/// 保存登录id
UIKIT_EXTERN NSString *const CMPersonIdKey;

/// 聊天CellId
UIKIT_EXTERN NSString *const CMChatTextCellID;
UIKIT_EXTERN NSString *const CMChatImageCellID;
UIKIT_EXTERN NSString *const CMChatDynamicImageCellID;
UIKIT_EXTERN NSString *const CMChatAudioCellID;
UIKIT_EXTERN NSString *const CMChatLocationCellID;

/// 消息发送完成通知Key
UIKIT_EXTERN NSString *const CMMessageSendCompleteKey;
/// 键盘升起降落通知
UIKIT_EXTERN NSString *const CMKeyBoardWillShowWillHideKey;
/// 键盘升起降落值的Key
UIKIT_EXTERN NSString *const CMKeyBoardShowHideUserInfoValueKey;

/// 收到新的消息更新会话列表
UIKIT_EXTERN NSString *const CMFetchNewMessageKey;
UIKIT_EXTERN NSString *const CMFetchNewMessageValueKey;
