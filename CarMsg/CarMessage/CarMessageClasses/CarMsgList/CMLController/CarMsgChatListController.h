//
//  CarMsgChatListController.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/1.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <WXOpenIMSDKFMWK/YWIMCore.h>
#import <WXOpenIMSDKFMWK/YWContactServiceDef.h>

#import "CarMsgChatListPresenter.h"
@interface CarMsgChatListController : NSObject

+ (instancetype)instanceWithPresenter:(CarMsgChatListPresenter *)presenter;

- (CarMsgChatListPresenter *)presenter;

- (UITableView *)tableView;

- (void)setDidSelectedRowHandler:(void(^)(CMCListCellPresenter *))didSelectedRowHandler;

@end
