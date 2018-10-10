//
//  CarMsgMacro.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/1.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#ifndef CarMsgMacro_h
#define CarMsgMacro_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CMEmojiMacro.h"
/// 加载一些头文件
#import "UIView+CMCAlert.h"
#import "UIImage+Compress.h"
#import "CMConst.h"
#import "CMChatBaseTableCell.h"
#import "CMToolClass.h"

/// 三方库头文件
#import "MJRefresh.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "YYKit.h"
#import "UITableView+FDTemplateLayoutCell.h"
/// SDK胶水头文件
#import "SPKitExample.h"
#import "SPUtil.h"

/// 消息模块在TabBarControllers 里面的位置
#define CMMsgVCIndex 0

///collectionView 注册cell
#define FETCHCOLLECTIONVIEW_CELL_NIB(obj,str,ide) [obj registerNib:[UINib nibWithNibName:str bundle:nil] forCellWithReuseIdentifier:ide]
#define FETCHCOLLECTIONVIEW_CELL_CLASS(obj,str,ide) [obj registerClass:[NSClassFromString(str) class] forCellWithReuseIdentifier:ide];
/// 占位图
#define CarPlaceholderImage        [UIImage imageNamed:@"image1"]
#define AvatarPlaceholderImage     [UIImage imageNamed:@"image1"]
/// 屏幕宽高
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
/// 导航栏高度
#define NAVBAR_HEIGHT (SCREEN_HEIGHT == 812.0 ? 88 : 64)
#define TABBAR_HEIGHT (SCREEN_HEIGHT == 812.0 ? 83 : 49)
/// 安全距离宏
#define AreaBottomHeight ({\
    CGFloat x = 0.0;\
    if(@available(iOS 11.0, *)) {\
    x = UIApplication.sharedApplication.delegate.window.safeAreaInsets.bottom;\
    }\
    x;\
})

#define AreaTopHeight ({\
    CGFloat x = 0.0;\
    if(@available(iOS 11.0, *)) {\
        x = UIApplication.sharedApplication.delegate.window.safeAreaInsets.top;\
    }\
    x;\
})

#define CMAPPKEY            @"23015524"

/// 判断是否是iphone4
#define SCREEN_IPHONE_4     (([[UIScreen mainScreen] bounds].size.height) == 480)

/// 判断是否是iphone5
#define SCREEN_IPHONE_5     (([[UIScreen mainScreen] bounds].size.height) == 568)

/// 判断是否为iphone6
#define SCREEN_IPHONE_6     (([[UIScreen mainScreen] bounds].size.height) == 667)

/// 判断是否为iphone6P
#define SCREEN_IPHONE_6PLUS (([[UIScreen mainScreen] bounds].size.height) == 736)

/// 判断是否为iphoneX
#define SCREEN_IPHONE_X (([[UIScreen mainScreen] bounds].size.height) == 812)

/// 为iPhoneX 添加footerView
#define IPHONEX_TABLEFOOTER(tableView) \
if (SCREEN_IPHONE_X) { \
    tableView.tableFooterView = ({ \
    UIView * view = [[UIView alloc]init]; \
    view.backgroundColor = tableView.backgroundColor; \
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, AreaBottomHeight); \
    view; \
    }); \
} \

/// 打印信息
#ifdef DEBUG
#define XHLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define XHLog(...)
#endif

///获取xib View
#define FETCHVIEW_XIB(str,obj,params,number) [[[NSBundle mainBundle]loadNibNamed:str owner:obj options:params]objectAtIndex:number]

///获取xib Controller
#define FETCHVIEWCONTROLLER_XIB(str) [[NSClassFromString(str) alloc] initWithNibName:str bundle:[NSBundle mainBundle]]

/// 注册cell
#define RegisClassCell(view,str,ide) [view registerClass:[NSClassFromString(str) class] forCellReuseIdentifier:ide]
#define RegisNibCell(view,nibName,ide) [view registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:ide]

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define CMUserDefadultSave(Object,Key) [[NSUserDefaults standardUserDefaults] setObject:Object forKey:Key]
#define CMUserDefadultGet(Key) [[NSUserDefaults standardUserDefaults] objectForKey:Key]

#endif /* CarMsgMacro_h */
