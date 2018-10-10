//
//  CMCListCellPresenter.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/1.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMCListCellPresenter : NSObject
@property (strong, nonatomic) UIImage * avatarImage;
@property (copy, nonatomic) NSString * nickNameText;
@property (copy, nonatomic) NSString * personId;

+ (instancetype)presenterWithPeopleMsg:(YWConversation *)conversation;

- (YWConversation *)conversation;
/// 好友头像
- (UIImage *)avatarImage;
/// 好友昵称
- (NSString *)nickNameText;
/// 最后消息时间
- (NSString *)timeText;
/// 最后一条消息内容
- (NSMutableAttributedString *)contentText;
/// 未读消息数量
- (NSString *)numberText;

/// 消息动态&&系统消息
- (NSString *)titleText;

/// 获取用户Porfile
+ (void)asyncGetPorfileWithPerson:(YWPerson *)person completion:(YWFetchProfileCompletionBlock)aCompletion;
+ (void)syncGetProfileCacheWithPerson:(YWPerson *)person completion:(YWFetchProfileCompletionBlock)aCompletion;
@end
