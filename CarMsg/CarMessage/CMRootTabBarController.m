//
//  CMRootTabBarController.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/29.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMRootTabBarController.h"

@interface CMRootTabBarController ()

@end

@implementation CMRootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addUI];
    [self configuration];
}

- (void)addUI {
    UIViewController * vc = [[NSClassFromString(@"CarMsgListViewController") alloc]init];
    [vc setValue:self.userId forKeyPath:@"userId"];
    UINavigationController * nav = [[NSClassFromString(@"CMBaseNavViewController") alloc]initWithRootViewController:vc];
    
    UIViewController * vc2 = [[UIViewController alloc]init];
    self.viewControllers = @[nav,vc2];
    
    self.tabBar.tintColor = [UIColor blueColor];
    
    UITabBarItem * item = self.tabBar.items.firstObject;
    item.title = @"消息";
    UITabBarItem * item2 = self.tabBar.items[1];
    item2.title = @"我的";
}

- (void)configuration {
    
    UITabBarItem * item = self.tabBar.items.firstObject;
    NSInteger count = [[SPKitExample sharedInstance].ywIMKit getTotalUnreadCount];
    NSString * badgeValue = count > 0 ?[ @(count) stringValue] : nil;
    item.badgeValue = badgeValue;
    
    @weakify(self);
    [[SPKitExample sharedInstance].ywIMKit setUnreadCountChangedBlock:^(NSInteger aCount) {
        if (weak_self.tabBar.items.count > CMMsgVCIndex) {
            NSString * badgeValue = aCount > 0 ?[ @(aCount) stringValue] : nil;
            UITabBarItem * item = weak_self.tabBar.items[CMMsgVCIndex];
            item.badgeValue = badgeValue;
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = aCount;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
