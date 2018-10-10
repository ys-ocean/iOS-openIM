//
//  CarMsgChatListPresenter.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/1.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCListCellPresenter.h"
#import "CarMsgApiManager.h"

@class CarMsgChatListPresenter;
@protocol CarMsgChatListPresenterCallBack <NSObject>

- (void)carMsgChatListPresenter:(CarMsgChatListPresenter *)presenter didRefreshDataWithResult:(id)result error:(NSError *)error;
- (void)carMsgChatListPresenter:(CarMsgChatListPresenter *)presenter didLoadMoreDataWithResult:(id)result error:(NSError *)error;

@end


@interface CarMsgChatListPresenter : NSObject

@property (weak, nonatomic) id<CarMsgChatListPresenterCallBack> delegate;


+ (instancetype)presenterWithUserId:(NSString *)userId;

- (NSArray *)allDatas;
- (NSMutableArray<CMCListCellPresenter *> *)defaultDatas;
- (NSMutableArray<CMCListCellPresenter *> *)msgDatas;

/// 刷新数据
- (void)refreshData;
/// 加载更多数据
- (void)loadMoreData;
/// 接收数据
- (void)fetchDataWithCompletionHandler:(CMNetworkCompletionHandler)completionHandler;
/// 删除一条会话
- (void)deleteConversationId:(NSString *)conversationId completionHandler:(CMNetworkCompletionHandler)completionHandler;
@end
