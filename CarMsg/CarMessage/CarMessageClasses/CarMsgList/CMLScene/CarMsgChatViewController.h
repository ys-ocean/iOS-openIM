//
//  CarMsgChatViewController.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/2.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMBaseViewController.h"

@interface CarMsgChatViewController : CMBaseViewController

/// 会话
@property (strong, nonatomic) YWConversation * conversation;

/// 昵称
@property (copy, nonatomic) NSString * nickName;

/// 聊天人的id
@property (copy, nonatomic) NSString * personId;

@end
