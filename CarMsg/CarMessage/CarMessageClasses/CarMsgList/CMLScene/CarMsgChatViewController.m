//
//  CarMsgChatViewController.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/2.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CarMsgChatViewController.h"
#import "CarMsgChatController.h"
#import "CarMsgInputController.h"
#import "Enumeration.h"
#define isOnlineKey @"addPersonOnlineStatusChanged"
@interface CarMsgChatViewController ()
@property (strong, nonatomic) CarMsgChatController * chatVC;
@property (strong, nonatomic) CarMsgInputController * inputVC;
@property (strong, nonatomic) YWPerson * person;
/// 显示对方是否在线和名称的View
@property (strong, nonatomic) UIView * titleView;
@end

@implementation CarMsgChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addUI];
    
    [self configuration];
    
    [self fetchData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    /// 设置会话已读
    [self.conversation markConversationAsRead];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /// 设置会话已读
    [self.conversation markConversationAsRead];
}

- (void)fetchData {
    @weakify(self);
    [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService]updateOnlineStatusForPersons:@[self.person] withExpire:0 andOnlineStatusUpdateBlock:^(BOOL isSuccess) {
        [weak_self.titleView setValue:@(isSuccess) forKey:@"isOnline"];
    }];
}

- (void)configuration {
    @weakify(self);
    
    [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] addPersonOnlineStatusChanged:@[self.person] withBlock:^BOOL(YWPerson *person, BOOL onlineStatus) {
        [weak_self.titleView setValue:@(onlineStatus) forKey:@"isOnline"];
        return YES;
    } forKey:isOnlineKey ofPriority:YWBlockPriorityDeveloper];
}


- (void)addUI {
    
    if (@available(iOS 11.0, *)) {
        // 版本适配
        self.navigationItem.titleView = self.titleView;
        [self.titleView layoutIfNeeded];
        [self.titleView setValue:self.nickName forKey:@"name"];
    }
    else {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 40)];
        self.navigationItem.titleView = view;
        [view addSubview:self.titleView];
        [self.titleView setValue:self.nickName forKey:@"name"];
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    
    [self.view addSubview:self.inputVC.contentView];
    [self.inputVC.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-AreaBottomHeight);
    }];
    
    @weakify(self);
    [self.view addSubview:self.chatVC.tableView];
    [self.chatVC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVBAR_HEIGHT);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(weak_self.inputVC.contentView.mas_top);
    }];
}

- (void)dealloc {
    [self.chatVC cleanTimer];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService]removePersonOnlineStatusChangedBlockForKey:isOnlineKey];
    [self.conversation stopConversation];
}

/// 昵称
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = FETCHVIEW_XIB(@"CMOnlineTitleView", self, nil, 0);
    }
    return _titleView;
}

- (YWPerson *)person {
    if (!_person) {
        _person = [[YWPerson alloc]initWithPersonId:self.personId appKey:CMAPPKEY];
    }
    return _person;
}

/// 聊天table
- (CarMsgChatController *)chatVC {
    if (!_chatVC) {
        _chatVC = [CarMsgChatController instanceWithPresenter:[CarMsgChatPresenter presenterWithConversation:self.conversation]];
    }
    return _chatVC;
}

/// 键盘
- (CarMsgInputController *)inputVC {
    if (!_inputVC) {
        _inputVC = [CarMsgInputController instanceWithPresenter:[CMMsgInputViewPresenter presenterWithConversation:self.conversation]];
    }
    return _inputVC;
}
@end
