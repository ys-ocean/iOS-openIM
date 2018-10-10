//
//  CarMsgChatController.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/2.
//  Copyright © 2018年 xiaohai. All rights reserved.
//
#import "CarMsgCheckMapViewController.h"
#import "CarMsgChatController.h"
#import "CMChatBaseTableCell.h"
#define Number 10
#define TIMEVIEW_HEIGHT 30
/// 超过2分钟  显示时间View
#define MaxMinutes 2
@interface CarMsgChatController ()<UITableViewDelegate,UITableViewDataSource>

/// 发送未读消息的定时器
@property (strong, nonatomic) NSTimer * readTimer;
/// 是否是下拉加载更多
@property (assign, nonatomic) BOOL isLoadMoreData;
/// 文本cell 的高度计算缓存区
@property (strong, nonatomic) NSMutableDictionary * textLayoutDic;
/// 收集未读的消息Id
@property (strong, nonatomic) NSMutableArray * unReadMsgIds;
/// 收集要显示时间的消息Id
@property (strong, nonatomic) NSMutableArray * showTimeMsgIds;
/// P层业务
@property (strong, nonatomic) CarMsgChatPresenter * presenter;
/// 当前或最近播放音频的消息Id
@property (copy, nonatomic)   NSString * playVoiceMsgId;
/// 当前或最近播放音频的消息状态
@property (assign, nonatomic) CMVoicePlayState playVoiceMsgState;
/// 聊天内容视图
@property (strong, nonatomic) UITableView * tableView;
/// 记录下拉前可滑动区域
@property (assign, nonatomic) CGFloat lastContentSizeHH;

@end

@implementation CarMsgChatController

+ (instancetype)instanceWithPresenter:(CarMsgChatPresenter *)presenter {
    CarMsgChatController * c = [[CarMsgChatController alloc]init];
    c.presenter = presenter;
    [c configuration];
    return c;
}

- (void)configuration {
    self.textLayoutDic = [NSMutableDictionary new];
    self.unReadMsgIds = [NSMutableArray new];
    self.showTimeMsgIds = [NSMutableArray new];
    
    @weakify(self);
    [self.presenter startConversationWithMessageCount:Number completion:^(BOOL existMore) {
        if (!existMore) {
            NSLog(@"没有聊天记录");
        }
        [weak_self tableViewScrollToBottom:NO];
    }];
    /// 加载更多
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weak_self.isLoadMoreData = YES;
        weak_self.lastContentSizeHH = weak_self.tableView.contentSize.height;
        [weak_self.presenter loadMoreMessages:Number completion:^(BOOL existMore) {
            [weak_self.tableView.mj_header endRefreshing];
            if (!existMore) {
                [weak_self.tableView showToastWithText:@"全部消息加载完成!" position:CSToastPositionCenter];
            }
            else {
                
//                [weak_self scrollViewDidScroll:weak_self.tableView];
            }
            [weak_self.tableView reloadData];
            [weak_self.tableView layoutIfNeeded];
            CGFloat nowContentSizeH = weak_self.tableView.contentSize.height;
            [weak_self.tableView setContentOffset:CGPointMake(0, nowContentSizeH - weak_self.lastContentSizeHH) animated:NO];
            
            /// 延迟设置加载更多已完成 防止动效还在的时候 插入一条新消息 Table滚动底部产生视图错乱效果
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weak_self.isLoadMoreData = NO;
            });
        }];
    }];
    
    /// 收到好友一条新消息Block
    [self.presenter setInsetContentMessageBlock:^(id<IYWMessage> messgae) {
        /// 接收到新消息 如果下拉加载没完成  就不自动滚到底部
        if (!weak_self.isLoadMoreData) {
            /// 自己发的消息 就不用滚动到最底部了 发送成功的地方 会调用
            if (!messgae || ![messgae.messageFromPerson.personId isEqualToString:CMUserDefadultGet(CMPersonIdKey)]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weak_self tableViewScrollToBottom:YES];
                });
            }
        }
        [weak_self.tableView reloadData];
    }];
    
    /// 设置更新Block
    [self.presenter setUpdateContentMessageBlock:^{
        [weak_self.tableView reloadData];
    }];
    
    /// 定时器设置未读消息为已读
    self.readTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(readMessageMethod) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.readTimer forMode:NSDefaultRunLoopMode];
    
    /// 发送完成一条消息的通知方法
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationMethod:) name:CMMessageSendCompleteKey object:nil];
    /// 键盘弹起回调
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationMethod2:) name:CMKeyBoardWillShowWillHideKey object:nil];
    
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)_tableView.mj_header;
    [header setTitle:@"下拉加载历史聊天纪录" forState:MJRefreshStateIdle];
}
/// 处理消息发送通知
- (void)notificationMethod:(NSNotification *)notification {
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weak_self tableViewScrollToBottom:NO];
    });
}
/// 处理键盘弹起通知
- (void)notificationMethod2:(NSNotification *)notification {
    NSDictionary * userInfo = notification.userInfo;
    NSNumber * number = userInfo[CMKeyBoardShowHideUserInfoValueKey];
    if ([number integerValue]>0) {
        /// 键盘弹起
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weak_self tableViewScrollToBottom:NO];
        });
    }
}
#pragma mark - UITableViewDataSource && Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.presenter.conversation.countOfFetchedObjects;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id <IYWMessage> nowModel = [self.presenter.conversation.fetchedObjects objectAtIndex:section];
    
    /// 如果是第0条消息 必须显示  优先级最高
    if (section  == 0) {
        /// 第0个必显示时间
        if (![self.showTimeMsgIds containsObject:nowModel.messageId]) {
            [self.showTimeMsgIds addObject:nowModel.messageId];
        }
        return TIMEVIEW_HEIGHT;
    }
    
    /// 如果已经显示过 时间的消息 就必须要显示时间 优先级第二
    if ([self.showTimeMsgIds containsObject:nowModel.messageId]) {
        return TIMEVIEW_HEIGHT;
    }
    
    /// 如果还有下一条消息 优先级第三
    if (self.presenter.conversation.countOfFetchedObjects > section + 1) {
        id <IYWMessage> nextModel = [self.presenter.conversation.fetchedObjects objectAtIndex:section + 1];
        /// 如果下一个model是必须要显示时间的消息
        if ([self.showTimeMsgIds containsObject:nextModel.messageId]) {
            /// 且 下一个model的时间 和本model时间不相等
            if ([nextModel.time minute] != [nowModel.time minute]) {
                id <IYWMessage> preModel = [self.presenter.conversation.fetchedObjects objectAtIndex:section - 1];
                /// 加上本model大于上一个model 2分钟 本消息时间可以显示 否则不显示(因为一下个model显示了时间)
                if ([nowModel.time minute] - [preModel.time minute] > MaxMinutes) {
                    return TIMEVIEW_HEIGHT;
                }
            }
            ///  否则不显示(因为一下个model显示了时间)
            return 0.0f;
        }
    }
    
    /// 当前消息 距离上一条消息 时间相差两分钟以上  当前消息显示发送时间
    id <IYWMessage> preModel = [self.presenter.conversation.fetchedObjects objectAtIndex:section - 1];
    if ([nowModel.time minute] - [preModel.time minute] > MaxMinutes) {
        if (![self.showTimeMsgIds containsObject:nowModel.messageId]) {
            [self.showTimeMsgIds addObject:nowModel.messageId];
        }
        return TIMEVIEW_HEIGHT;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * timeView = FETCHVIEW_XIB(@"CMChatTableTimeView", self, nil, 0);
    timeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, TIMEVIEW_HEIGHT);
    /// 获取要显示的时间字符串
    NSString * time = [self timeStringForSection:section];
    [timeView setValue:time forKey:@"time"];
    return timeView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <IYWMessage> model = [self.presenter.conversation.fetchedObjects objectAtIndex:indexPath.section];
    if ([model.messageBody isKindOfClass:[YWMessageBodyText class]]) {
        
        CGFloat height = [CMChatBaseTableCell cellTextHeight:model textLayoutDic:self.textLayoutDic];
        return height;
    }
    else if ([model.messageBody isKindOfClass:[YWMessageBodyImage class]]) {
        CGFloat height = [CMChatBaseTableCell cellImageHeight:model];
        return height;
    }
    else if ([model.messageBody isKindOfClass:[YWMessageBodyLocation class]]) {
        CGFloat height = [CMChatBaseTableCell cellLocationHeight];
        return height;
    }
    else if ([model.messageBody isKindOfClass:[YWMessageBodyVoice class]]) {
        CGFloat height = [CMChatBaseTableCell cellAudioHeight];
        return height;
    }
    else if ([model.messageBody isKindOfClass:[YWMessageBodyCustomize class]]) {
        CGFloat height = [CMChatBaseTableCell cellDynamicHeight];
        return height;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id <IYWMessage> model = [self.presenter.conversation.fetchedObjects objectAtIndex:indexPath.section];
    NSString * key = [self cellForKey:model];
    CMChatBaseTableCell * cell = [tableView dequeueReusableCellWithIdentifier:key];
    if (!cell) {
        cell = [[CMChatBaseTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
    }
    if (key == CMChatTextCellID) {
        cell.textLayoutDic = self.textLayoutDic;
    }
    if ([model.messageId isEqualToString:self.playVoiceMsgId]) {
        cell.voiceState = self.playVoiceMsgState;
    }
    else {
        cell.voiceState = CMVoicePlayStateNormal;
    }
    cell.model = model;
    /// 配置cell回调
    [self configurationCellBlock:cell];
    
    return cell;
}

- (void)configurationCellBlock:(CMChatBaseTableCell *)cell {
    @weakify(self);
    [cell setAvatarClickBlock:^(YWPerson * aPerson) {
        [weak_self.tableView showToastWithText:@"我点击了头像" position:CSToastPositionCenter];
    }];
    [cell setContainerClickBlock:^(NSString * messageId) { /// 点击容器
        [weak_self didSelectedContainView:messageId];
    }];
    [cell setDeleteMessageBlock:^(NSString * messageId) { ///删除消息
        [weak_self deleteMessageId:messageId];
    }];
    [cell setRePostMessageBlock:^(NSString * messageId) { ///重发消息
        [weak_self rePostMessageId:messageId];
    }];
    [cell setReadMessageBlock:^(NSString * messageId) { /// 设置消息已读
        [weak_self readMessageId:messageId];
    }];
}

/// 发送收集的未读消息Id
- (void)readMessageMethod {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.unReadMsgIds count]) {
            NSLog(@"self.unReadMsgIds:%@ \n",self.unReadMsgIds);
            [self.presenter readMessageId:self.unReadMsgIds];
            [self.unReadMsgIds removeAllObjects];
        }
    });
}
/// 收集未读消息Id
- (void)readMessageId:(NSString *)messageId {
    if (![self.unReadMsgIds containsObject:messageId]) {
        [self.unReadMsgIds addObject:messageId];
    }
}
/// 重发一条消息
- (void)rePostMessageId:(NSString *)messageId {
    @weakify(self);
    [self.presenter rePostMessageId:messageId progress:^(CGFloat progress, NSString *messageID) {
        [weak_self.tableView showToastWithText:@"正在发送" afterDelay:0.5];
    } completion:^(NSError *error, NSString *messageID) {
        if (error) {
            [self.tableView showToastWithText:@"发送失败,确保网络畅通" position:CSToastPositionCenter];
        }
    }];
}
/// 删除一条消息
- (void)deleteMessageId:(NSString *)messageId {
    @weakify(self);
    [self.presenter deleteMessageId:messageId complete:^(NSIndexPath * indexPath) {
        
        NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];

        [weak_self.tableView deleteSections:indexSet withRowAnimation:NO];
        [weak_self.tableView reloadData];
        
        //[weak_self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }];
}

/// 选中聊天Cell容器
- (void)didSelectedContainView:(NSString *)messageId {
    id<IYWMessage> model = [self.presenter.conversation fetchMessageWithMessageId:messageId];
    
    if ([model.messageBody isKindOfClass:[YWMessageBodyLocation class]]) {
        YWMessageBodyLocation * body = (YWMessageBodyLocation *)model.messageBody;
        /// 产看地理位置
        CarMsgCheckMapViewController * vc = [[CarMsgCheckMapViewController alloc]init];
        vc.coordinate = body.location;
        vc.name = body.locationName;
        [self.tableView.viewController presentViewController:vc animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        }];
    }
    else if ([model.messageBody isKindOfClass:[YWMessageBodyVoice class]]) {
        YWMessageBodyVoice * body = (YWMessageBodyVoice *)model.messageBody;
        @weakify(self);
        [body asyncGetVoiceDataWithProgress:^(CGFloat progress) {
            /// 音频下载进度
        } completion:^(NSData *data, NSError *aError) {
            if (aError) {
                [weak_self.tableView showToastWithText:@"音频文件下载失败" position:CSToastPositionCenter];
            }
            else {
                [weak_self.presenter startPlayVoice:data voiceId:messageId complete:^(NSString * messageId, CMVoicePlayState state) {
                    weak_self.playVoiceMsgId = messageId;
                    weak_self.playVoiceMsgState = state;
                    [weak_self.tableView reloadData];
                }];
            }
        }];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (TIMEVIEW_HEIGHT >0 ) {
        if (scrollView.contentOffset.y<=TIMEVIEW_HEIGHT&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y>=TIMEVIEW_HEIGHT) {
            scrollView.contentInset = UIEdgeInsetsMake(-TIMEVIEW_HEIGHT, 0, 0, 0);
        }
    }
}

/// 滚动到指定位置
- (void)tableViewScrollToBottom:(BOOL)animated {
    if (self.presenter.conversation.countOfFetchedObjects > 0) {
        [self tableViewScrollToBottom:self.presenter.conversation.countOfFetchedObjects - 1 animated:animated];
    }
}

- (void)tableViewScrollToBottom:(NSInteger)section animated:(BOOL)animated {
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
//    CGFloat contentHH = self.tableView.contentSize.height;
//    CGFloat tableHH = self.tableView.frame.size.height;
//    CGFloat Y = self.tableView.contentOffset.y;
//    if (contentHH <= tableHH) {
//        return;
//    }
//    if ((Y + tableHH) >= contentHH) {
//        return;
//    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
        //[self.tableView setContentOffset:CGPointMake(0, contentHH - tableHH) animated:animated];
    });
}
/// 格式化要显示的时间字符串
- (NSString *)timeStringForSection:(NSInteger)section {
    NSString * time = @"00:00";
    id <IYWMessage> model = [self.presenter.conversation.fetchedObjects objectAtIndex:section];
    NSString * hourM = [model.time stringWithFormat:@"HH:mm"];
    if ([model.time isToday]) {
        time = hourM;
    }
    else if ([model.time isYesterday]) {
        time = [NSString stringWithFormat:@"昨天 %@",hourM];
    }
    else if (![model.time isYesterday]) {
        if ([[NSDate new]day] - [model.time day] <= 5) {
            /// 星期三 00:00
            NSString * week = [CMToolClass weekdayStringForInteger:[model.time weekday]];
            time = [NSString stringWithFormat:@"%@ %@",week,hourM];
        }
        else {
            /// 2018-01-01 00:00 
            time = [model.time stringWithFormat:@"yyyy-MM-dd HH:mm"];
        }
    }
    return time;
}

/// 根据类型返回要显示的CellId
- (NSString *)cellForKey:(id <IYWMessage>)model {
    NSString * key = CMChatTextCellID;
    if ([model.messageBody isKindOfClass:[YWMessageBodyText class]]) {
        key = CMChatTextCellID;
    }
    else if ([model.messageBody isKindOfClass:[YWMessageBodyImage class]]) {
        key = CMChatImageCellID;
    }
    else if ([model.messageBody isKindOfClass:[YWMessageBodyLocation class]]) {
        key = CMChatLocationCellID;
    }
    else if ([model.messageBody isKindOfClass:[YWMessageBodyVoice class]]) {
        key = CMChatAudioCellID;
    }
    else if ([model.messageBody isKindOfClass:[YWMessageBodyCustomize class]]) {
        key = CMChatDynamicImageCellID;
    }
    return key;
}

- (void)cleanTimer {
    if (self.readTimer) {
        [self.readTimer invalidate];
        _readTimer = nil;
    }
}

- (void)dealloc {
    [self cleanTimer];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.separatorColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = EMOJI_BG_COLOR;
        RegisClassCell(_tableView, CMChatTextCellID, CMChatTextCellID);
        RegisClassCell(_tableView, CMChatImageCellID, CMChatImageCellID);
        RegisClassCell(_tableView, CMChatAudioCellID, CMChatAudioCellID);
        RegisClassCell(_tableView, CMChatLocationCellID, CMChatLocationCellID);
        RegisClassCell(_tableView, CMChatDynamicImageCellID, CMChatDynamicImageCellID);
    }
    return _tableView;
}

@end


