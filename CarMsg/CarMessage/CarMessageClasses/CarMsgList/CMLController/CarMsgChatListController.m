//
//  CarMsgChatListController.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/1.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CarMsgChatListController.h"
#import "CarMsgChatListCell.h"
#import "CarMsgChatDefaultCell.h"
@interface CarMsgChatListController ()<UITableViewDelegate,UITableViewDataSource,CarMsgChatListPresenterCallBack>
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) CarMsgChatListPresenter * presenter;
@property (copy, nonatomic) void(^didSelectedRowHandler)(CMCListCellPresenter *);
@end

static NSString * cellId = @"CarMsgChatListCell";
static NSString * defCellId = @"CarMsgChatDefaultCell";
@implementation CarMsgChatListController

+ (instancetype)instanceWithPresenter:(CarMsgChatListPresenter *)presenter {
    return [[CarMsgChatListController alloc]initWithPresenter:presenter];
}

- (instancetype)initWithPresenter:(CarMsgChatListPresenter *)presenter {
    if (self = [super init]) {
        self.presenter = presenter;
        self.presenter.delegate = self;
        @weakify(self);
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weak_self.presenter refreshData];
        }];
        RegisNibCell(self.tableView, cellId, cellId);
        RegisNibCell(self.tableView, defCellId, defCellId);
        IPHONEX_TABLEFOOTER(self.tableView);
    }
    return self;
}

#pragma mark - CarMsgChatListPresenterCallBack
- (void)carMsgChatListPresenter:(CarMsgChatListPresenter *)presenter didRefreshDataWithResult:(id)result error:(NSError *)error {
    [self.tableView.mj_header endRefreshing];
    if (!error) {
        [self.tableView reloadData];
        [self.tableView.mj_footer resetNoMoreData];
    }
    else {
        [self.tableView showToastWithText:@"刷新失败!"];
    }
}

- (void)carMsgChatListPresenter:(CarMsgChatListPresenter *)presenter didLoadMoreDataWithResult:(id)result error:(NSError *)error {
    [self.tableView.mj_footer endRefreshing];
    if (!error) {
        [self.tableView reloadData];
    }
    else {
        [self.tableView showToastWithText:error.domain];
        if (error.code == CMNetworkErrorNoMoreData) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

#pragma mark - UITableViewDataSource && Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.presenter.allDatas count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.presenter.allDatas[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    }
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 30;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CarMsgChatDefaultCell * cell = [tableView dequeueReusableCellWithIdentifier:defCellId];
        cell.presenter = self.presenter.defaultDatas[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else {
        CarMsgChatListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        __block CMCListCellPresenter * presenter = self.presenter.msgDatas[indexPath.row];
        if ([presenter.conversation isKindOfClass:[YWP2PConversation class]]) {
            YWP2PConversation * conversation = (YWP2PConversation *)presenter.conversation;
            cell.identifier = conversation.person.personId;
            presenter.personId = conversation.person.personId;
            [CMCListCellPresenter syncGetProfileCacheWithPerson:conversation.person completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                presenter.nickNameText = aDisplayName;
                presenter.avatarImage = aAvatarImage;
                presenter.personId = aPerson.personId;
            }];
            
            if (!presenter.nickNameText) {
                presenter.nickNameText = conversation.person.personId;
                presenter.personId = conversation.person.personId;
                __weak __typeof(cell) weakCell = cell;
                [CMCListCellPresenter asyncGetPorfileWithPerson:conversation.person completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                    presenter.nickNameText = aDisplayName;
                    presenter.avatarImage = aAvatarImage;
                    presenter.personId = aPerson.personId;
                    if (aDisplayName && [weakCell.identifier isEqualToString:aPerson.personId]) {
                        NSIndexPath *aIndexPath = [tableView indexPathForCell:weakCell];
                        if (!aIndexPath) {
                            return ;
                        }
                        [tableView reloadRowsAtIndexPaths:@[aIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }];
            }
        }
        cell.presenter = presenter;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    label.text = @"  消息列表";
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CMCListCellPresenter * p = indexPath.section == 0 ? self.presenter.defaultDatas[indexPath.row] : self.presenter.msgDatas[indexPath.row];
    !self.didSelectedRowHandler ?: self.didSelectedRowHandler(p);
}
/// 设置可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
/// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
/// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
/// 设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        @weakify(self);
        CMCListCellPresenter * presenter = self.presenter.msgDatas[indexPath.row];
        [self.presenter deleteConversationId:presenter.conversation.conversationId completionHandler:^(id result, NSError *error) {
            if (!error) {
                [weak_self.presenter.msgDatas removeObjectAtIndex:indexPath.row];
                [weak_self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
            }
        }];
    }
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
        _tableView.separatorColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        /// 修改分割线的inset
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
@end
