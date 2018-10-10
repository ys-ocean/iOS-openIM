//
//  CarMsgApiManager.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/1.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CMNetworkCompletionHandler)(id result , NSError *error);

typedef enum : NSUInteger {
    CMNetworkErrorNoData,
    CMNetworkErrorNoMoreData
} CMNetworkError;


@interface CarMsgApiManager : NSObject

///更新座驾排行消息列表数据
- (void)refreshUserChatListData:(NSString *)userId completionHandler:(CMNetworkCompletionHandler)completionHandler;
///加载下一页座驾排行消息数据
- (void)loadMoreUserChatListData:(NSString *)userId completionHandler:(CMNetworkCompletionHandler)completionHandler;

@end
