//
//  CarMsgListViewController.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/1.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CarMsgListViewController.h"
#import "CarMsgChatListController.h"

#import "HMSegmentedControl.h"
@interface CarMsgListViewController ()
@property (strong, nonatomic) CarMsgChatListController * chatList;

@end
#define SEG_HEIGHT 40
@implementation CarMsgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.chatList.presenter refreshData];
}

- (void)fetchData {
    
    @weakify(self);
    [self showHUD];
    [self.chatList.presenter fetchDataWithCompletionHandler:^(id result, NSError *error) {
        [self hideHUD];
        if (error) {
            [weak_self.view showToastWithText:@"网络链接出错" position:CSToastPositionCenter];
        }
        else {
            [weak_self.chatList.tableView reloadData];
        }
    }];
}

- (void)configuration {
    
    self.navigationItem.title = @"消息";
    
    @weakify(self);
    [self.chatList setDidSelectedRowHandler:^(CMCListCellPresenter * presenter) {
        
        YWConversation * conver = presenter.conversation;
        if ([conver.conversationId isEqualToString:CarMsgListViewMessageDynamic]||[conver.conversationId isEqualToString:CarMsgListViewMessageDynamic]) {
            [weak_self.view showToastWithText:@"您选择了系统消息或者消息动态" position:CSToastPositionCenter];
        }
        else {
            UIViewController * vc = [[NSClassFromString(@"CarMsgChatViewController") alloc]init];
            [vc setValue:presenter.conversation forKey:@"conversation"];
            [vc setValue:presenter.nickNameText forKey:@"nickName"];
            [vc setValue:presenter.personId forKey:@"personId"];
            [weak_self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)addUI {
    [self.view addSubview:self.chatList.tableView];
    [self.chatList.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVBAR_HEIGHT);
        make.right.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}

#pragma mark - LAZY
- (CarMsgChatListController *)chatList {
    if (!_chatList) {
        _chatList = [CarMsgChatListController instanceWithPresenter:[CarMsgChatListPresenter presenterWithUserId:self.userId]];
    }
    return _chatList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
