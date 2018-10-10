//
//  CMChatBaseTableCell.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/13.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXOpenIMSDKFMWK/IYWMessage.h>
#import "SDAutoLayout.h"
#import "CMDefaultEmojiPresenter.h"
#import "Enumeration.h"

#define kMinContainerWidth 160
#define kLabelTopMargin 8.f
#define kChatCellIconImageViewWH 40.f
#define kChatCellRedBagHeight 260.f
#define kMaxChatImageViewWidth 150.f
#define kMaxChatImageViewHeight 200.f
#define kMaxChatLocationViewWidth 128.f
#define kMaxChatLocationViewHeight 88.f


@interface CMChatBaseTableCell : UITableViewCell
/// 文本高度计算保存
@property (weak, nonatomic) NSMutableDictionary * textLayoutDic;

/// 头像
@property (strong, nonatomic) UIImageView * avatarImageView;

/// 容器
@property (strong, nonatomic) UIView * container;

/// 容器图
@property (strong, nonatomic) UIImageView * containerBackgroundImageView;

/// cell上这条消息
@property (weak, nonatomic) id<IYWMessage> model;

/// 音频播放的状态
@property (assign, nonatomic) CMVoicePlayState voiceState;

/// 添加UI
- (void)addUI;

/// 设置约束 根据自己或者对方变换
- (void)setMessageOriginWithModel:(id<IYWMessage>)model;
/// 点击容器调用的方法 子类实现
- (void)containerViewGesClick:(id)sender;

/// 点击头像回调
- (void)setAvatarClickBlock:(void (^)(YWPerson *))avatarClickBlock;
/// 点击容器回调
- (void)setContainerClickBlock:(void (^)(NSString *))containerClickBlock;
/// 删除一条消息回调
- (void)setDeleteMessageBlock:(void (^)(NSString *))deleteMessageBlock;
/// 重发信息的回调
- (void)setRePostMessageBlock:(void (^)(NSString *))rePostMessageBlock;
/// 如果别人发给我的消息未读 设置已读
- (void)setReadMessageBlock:(void (^)(NSString *))readMessageBlock;

/// 返回文字加表情高度 用约束算高 当然也可以这里返回
+ (CGFloat)cellTextHeight:(id<IYWMessage>)model textLayoutDic:(NSMutableDictionary *)textLayoutDic;
/// 返回图片的 cell高度
+ (CGFloat)cellImageHeight:(id<IYWMessage>)model;
/// 返回地理位置 cell高度
+ (CGFloat)cellLocationHeight;
/// 返回语音 cell高度
+ (CGFloat)cellAudioHeight;
/// 动态图片高度(固定的)
+ (CGFloat)cellDynamicHeight;
@end
