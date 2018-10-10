//
//  ViewController.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/1.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "ViewController.h"
#import "SPUtil.h"
#import "SPKitExample.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeAll;
//    NSString * str = @"文字/:0657/:planeplane文字";
//    //创建匹配对象
//    NSError * error;
//    NSRegularExpression * regularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\/:+\\d{4}" options:NSRegularExpressionCaseInsensitive error:&error];
//    //判断
//    if (!regularExpression) {
//        NSLog(@"正则创建失败 error = %@",[error localizedDescription]);
//    }
//    else {
//        NSArray * resultArray = [regularExpression matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)];
//        NSLog(@"resultArray:%@ \n",resultArray);
//    }
}

- (IBAction)gesClick:(id)sender {
    [self.accountText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

- (IBAction)pushCarMsgScene:(id)sender {

    [self showHUD];
    
    @weakify(self);
    //这里先进行应用的登录
    //应用登陆成功后，登录IMSDK
    [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:self.accountText.text
                                                                           passWord:self.passwordText.text
                                                                    preloginedBlock:^{
                                                                        /// 预处理
                                                                    } successBlock:^{
                                                                        //  到这里已经完成SDK接入并登录成功
                                                                        [weak_self hideHUD];
                                                                        
                                                                        [weak_self pushConversationListVC];
                                                                        
                                                                    } failedBlock:^(NSError *aError) {
                                                                        [weak_self showToastWithText:@"登录失败"];
                                                                    }];
}

- (void)pushConversationListVC {
    NSString * loginId = [[SPKitExample sharedInstance].ywIMKit.IMCore getLoginService].currentLoginedUserId;
    CMUserDefadultSave(loginId, CMPersonIdKey);
    UITabBarController * vc = [[NSClassFromString(@"CMRootTabBarController") alloc]init];
    [vc setValue:@"1" forKeyPath:@"userId"];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
