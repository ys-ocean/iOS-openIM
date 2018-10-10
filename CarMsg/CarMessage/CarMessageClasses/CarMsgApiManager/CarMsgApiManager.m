//
//  CarMsgApiManager.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/1.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CarMsgApiManager.h"

@interface CarMsgApiManager ()

@property (assign ,nonatomic) NSUInteger peopleMsgPage;
@end

#define PageSize 20

@implementation CarMsgApiManager

///更新座驾排行消息列表数据
- (void)refreshUserChatListData:(NSString *)userId completionHandler:(CMNetworkCompletionHandler)completionHandler {
    self.peopleMsgPage = 0;
    [self fetchUserChatListData:userId page:self.peopleMsgPage pageSize:PageSize completionHandler:completionHandler];
}
///加载下一页座驾排行消息数据
- (void)loadMoreUserChatListData:(NSString *)userId completionHandler:(CMNetworkCompletionHandler)completionHandler {
    self.peopleMsgPage += 1;
    [self fetchUserChatListData:userId page:self.peopleMsgPage pageSize:PageSize completionHandler:completionHandler];
}

- (void)fetchUserChatListData:(NSString *)userId page:(NSUInteger)page pageSize:(NSUInteger)pageSize completionHandler:(CMNetworkCompletionHandler)completionHandler {
    !completionHandler ?: completionHandler(@[@{@"key":@"value"},@{@"key":@"value"}], nil);
}
@end
