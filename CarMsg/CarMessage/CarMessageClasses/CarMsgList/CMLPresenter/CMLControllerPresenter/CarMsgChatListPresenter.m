//
//  CarMsgChatListPresenter.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/1.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CarMsgChatListPresenter.h"

@interface CarMsgChatListPresenter ()
@property (copy, nonatomic) NSString * userId;
///
@property (strong, nonatomic) NSArray * arrayData;
@property (weak, nonatomic) NSMutableArray<CMCListCellPresenter *> * defaArray;
@property (weak, nonatomic) NSMutableArray<CMCListCellPresenter *> * dataArray;
@property (strong, nonatomic) CarMsgApiManager * apiManager;
@end

@implementation CarMsgChatListPresenter

+ (instancetype)presenterWithUserId:(NSString *)userId {
    return [[CarMsgChatListPresenter alloc]initWithUserId:userId];
}

- (instancetype)initWithUserId:(NSString *)userId {
    if (self = [super init]) {
        self.userId = userId;
        self.apiManager = [CarMsgApiManager new];

        NSMutableArray * array = [NSMutableArray new];
        NSMutableArray * def = [NSMutableArray new];
        self.arrayData = @[def,array];
        
        self.defaArray = def;
        self.dataArray = array;
        
        [self configuration];
    }
    return self;
}

- (void)configuration {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fetchNewMessageNotification:) name:CMFetchNewMessageKey object:nil];
}

- (NSArray *)allDatas {
    return self.arrayData;
}
- (NSMutableArray<CMCListCellPresenter *> *)defaultDatas {
    return self.defaArray;
}
- (NSMutableArray<CMCListCellPresenter *> *)msgDatas {
    return self.dataArray;
}

- (void)fetchNewMessageNotification:(NSNotification *)notification {
    [self refreshData];
}

- (void)fetchDataWithCompletionHandler:(CMNetworkCompletionHandler)completionHandler {
    @weakify(self);
//    [self.apiManager refreshUserChatListData:self.userId completionHandler:^(id result, NSError *error) {
//        if (!error) {
//            [weak_self.dataArray removeAllObjects];
//            [weak_self formatResultData:result];
//        }
//        !completionHandler ?: completionHandler(result, error);
//    }];
    /// 获取会话列表
    [[[SPKitExample sharedInstance].ywIMKit.IMCore getConversationService] asyncFetchAllConversationsWithCompletionBlock:^(NSArray *aConversationsArray) {
        [weak_self formatResultData:aConversationsArray];
        !completionHandler ?: completionHandler(weak_self.dataArray, nil);
    }];
    
}

- (void)refreshData {
    @weakify(self);
    [self fetchDataWithCompletionHandler:^(id result, NSError *error) {
        if ([weak_self.delegate respondsToSelector:@selector(carMsgChatListPresenter:didRefreshDataWithResult:error:)]) {
            [weak_self.delegate carMsgChatListPresenter:self didRefreshDataWithResult:result error:error];
        }
    }];
}

- (void)loadMoreData {
    @weakify(self);
    [self.apiManager loadMoreUserChatListData:self.userId completionHandler:^(id result, NSError *error) {
        if (!error) {
            [weak_self formatResultData:result];
        }
        if ([weak_self.delegate respondsToSelector:@selector(carMsgChatListPresenter:didLoadMoreDataWithResult:error:)]) {
            [weak_self.delegate carMsgChatListPresenter:self didLoadMoreDataWithResult:result error:error];
        }
    }];
}

- (void)deleteConversationId:(NSString *)conversationId completionHandler:(CMNetworkCompletionHandler)completionHandler {
    NSError * error ;
    [[[SPKitExample sharedInstance].ywIMKit.IMCore getConversationService] removeConversationByConversationId:conversationId error:&error];
    completionHandler ? completionHandler(@"",error) : nil;
}

- (void)formatResultData:(NSArray *)datas {
    [self.dataArray removeAllObjects];
    @weakify(self);
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        YWConversation * conversation = (YWConversation *)obj;
        if ([conversation.conversationId isEqualToString:CarMsgListViewMessageDynamic]||[conversation.conversationId isEqualToString:CarMsgListViewMessageSystem]) {
            [weak_self.defaArray addObject:[CMCListCellPresenter presenterWithPeopleMsg:obj]];
        }
        else {
            /// 暂时只对单聊做处理
            if ([conversation isKindOfClass:[YWP2PConversation class]]) {
                [weak_self.dataArray addObject:[CMCListCellPresenter presenterWithPeopleMsg:obj]];
            }
        }
    }];

    if ([self.defaArray count]) {
        YWConversation * conv = (YWConversation *)weak_self.defaArray.firstObject;
        if ([conv.conversationId isEqualToString:CarMsgListViewMessageSystem]) {
            [weak_self.defaArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
