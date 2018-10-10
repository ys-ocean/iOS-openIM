//
//  CarMsgChatController.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/2.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarMsgChatPresenter.h"

@interface CarMsgChatController : NSObject

+ (instancetype)instanceWithPresenter:(CarMsgChatPresenter *)presenter;

- (UITableView *)tableView;

/// 滚动到最下方
- (void)tableViewScrollToBottom:(BOOL)animated;

/// 清楚定时器
- (void)cleanTimer;
@end
