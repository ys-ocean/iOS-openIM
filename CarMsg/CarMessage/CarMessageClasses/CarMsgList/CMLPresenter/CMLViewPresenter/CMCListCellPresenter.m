//
//  CMCListCellPresenter.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/1.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMCListCellPresenter.h"

@interface CMCListCellPresenter ()
@property (strong, nonatomic) YWConversation * conversation;

@end

@implementation CMCListCellPresenter

+ (instancetype)presenterWithPeopleMsg:(YWConversation *)conversation {
    CMCListCellPresenter * presenter = [[CMCListCellPresenter alloc]init];
    presenter.conversation = conversation;
    return presenter;
}

- (UIImage *)avatarImage {
    /// 默认头像 异步获取成功后通过set方法替换 更新cell (做了缓存后可以默认获取缓存,没有显示默认头像)
    if (!_avatarImage) {
        return CarPlaceholderImage;
    }
    return _avatarImage;
}
- (NSString *)titleText {
    if ([self.conversation.conversationId isEqualToString:CarMsgListViewMessageDynamic]) {
        return @"消息动态";
    }
    else {
        return @"系统消息";
    }
}
- (NSString *)timeText {
    return [self.conversation.conversationLatestMessageTime stringWithFormat:@"HH:mm"];
}
- (NSMutableAttributedString *)contentText {
    NSMutableAttributedString * str = [CMDefaultEmojiPresenter processCommentContentWithEmoticonInfo:self.conversation.conversationLatestMessageContent];
    str.color = [UIColor grayColor];
    UIFont * font = [UIFont systemFontOfSize:15.0f];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    return str;
}
- (NSString *)numberText {
    return [self.conversation.conversationUnreadMessagesCount integerValue]>99?@"99":[self.conversation.conversationUnreadMessagesCount stringValue];
}

+ (void)asyncGetPorfileWithPerson:(YWPerson *)person completion:(YWFetchProfileCompletionBlock)aCompletion; {

    [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] asyncGetProfileFromServerForPerson:person withTribe:nil withProgress:nil andCompletionBlock:^(BOOL aIsSuccess, YWProfileItem *item) {
       
        if (aCompletion) {
            aCompletion(aIsSuccess, item.person, item.displayName, item.avatar);
        }
    }];
}

+ (void)syncGetProfileCacheWithPerson:(YWPerson *)person completion:(YWFetchProfileCompletionBlock)aCompletion {
    YWProfileItem * item = [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] getProfileForPerson:person withTribe:nil];

    NSString * displayName = item.displayName;
    UIImage * avatar = item.avatar;
    if (item.updateDateFromServer && [[NSDate date] timeIntervalSinceDate:item.updateDateFromServer] <= 24 * 3600) {
        if (displayName == nil) {
            displayName = person.personId;
        }
        if (avatar == nil) {
            avatar = CarPlaceholderImage;
        }
        if (aCompletion) {
            aCompletion(YES, item.person, item.displayName, item.avatar);
        }
    }
}
@end
