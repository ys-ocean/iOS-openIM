//
//  CMEmojiMacro.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/8.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

/// 可滑动表情区域高度
#define EMOJI_SCROLL_HEIGHT          (180.0 + TABBAR_HEIGHT)
/// 发送按钮宽度
#define SEND_BTN_WIDTH               80
/// pageControl高度
#define PAGECONTROL_HEIGHT           20
/// 表情键盘的背景图
#define EMOJI_BG_COLOR               [UIColor colorWithRed:(250.0)/255.0 green:(250.0)/255.0 blue:(250.0)/255.0 alpha:1]
/// 聊天文字大小
#define CHAT_FONT                    [UIFont systemFontOfSize:17]
/// 聊天表情大小
#define EMOJI_SIZE                   22

/// 默认表情Plist名字
#define EmojiPlistName               @"DefaultEmoji"
/// 系统新表情Plist名字
#define NewEmojiPlistName            @"emoji"
/// 阿里表情Plist名字
#define EmoticonPlistName            @"EmoticonInfo"

static NSString *const emojiCheckStr = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
/// 表情Plist名字(修改在此修改)
static NSString *const EmoticonInfoPlistName = @"EmoticonInfo";

