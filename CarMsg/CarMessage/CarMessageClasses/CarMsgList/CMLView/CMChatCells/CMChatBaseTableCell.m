//
//  CMChatBaseTableCell.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/13.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMChatBaseTableCell.h"

@interface CMChatBaseTableCell ()
@property (copy, nonatomic) void(^avatarClickBlock)(YWPerson *);
@property (copy, nonatomic) void(^containerClickBlock)(NSString *);
@property (copy, nonatomic) void(^deleteMessageBlock)(NSString *);
@property (copy, nonatomic) void(^rePostMessageBlock)(NSString *);
@property (copy, nonatomic) void(^readMessageBlock)(NSString *);
/// 发送进度指示器
@property (strong, nonatomic) UIActivityIndicatorView * activityIndicator;

/// 发送失败按钮
@property (strong, nonatomic) UIButton * failButton;

/// 消息未读
//@property (strong, nonatomic) UILabel * unReadLabel;

/// cell上这条消息的Id
@property (copy, nonatomic) NSString * messageId;
/// cell上这个人的Id
@property (copy, nonatomic) NSString * personId;
@end

@implementation CMChatBaseTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    /// 异步绘制 内容需要反复重绘的情况设置为false
    self.layer.drawsAsynchronously = YES;
    /// cell优化尽量减少图层的数量，相当于就只有一层，相对画面中移动但自身外观不变的对象
    self.layer.shouldRasterize = YES;
    /// 必须制定分辨率
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    self.backgroundColor = EMOJI_BG_COLOR;
    
    [self configuration];
}

- (void)addUI {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [self.contentView addSubview:self.avatarImageView];
    
    [self.container insertSubview:self.containerBackgroundImageView atIndex:0];
    [self.contentView addSubview:self.container];
    
    [self.contentView addSubview:self.activityIndicator];
    
    [self.contentView addSubview:self.failButton];
    
//    [self.contentView addSubview:self.unReadLabel];
    /// 配合SDAutoLayout使用
    self.containerBackgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
//    @weakify(self);
//    [self.unReadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(weak_self.container.mas_bottom).offset(-kLabelTopMargin);
//        make.right.mas_equalTo(weak_self.container.mas_left).offset(-kLabelTopMargin/2.0);
//    }];
}

- (void)configuration {
    
}

- (void)resetUIState {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidesWhenStopped = YES;
    self.failButton.hidden = YES;
}

- (void)cellLongPress:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {

        [self becomeFirstResponder];
        // 获得菜单
        UIMenuController * menu = [UIMenuController sharedMenuController];

        [menu setTargetRect:self.container.frame inView:self];
        //为什么要设置2个参数  为了通用 \
        一个是矩形框, 一个是在哪个View上面
        //传了矩形框, 要告诉坐标原点在哪, 坐标原点就在view上\
        以tagreView的左上角为坐标原点
        // 苹果设计2个参数 是因为矩形框一旦修改 出现的位置在哪里都是可以的
        
        /*
         targetRect：menuController指向的矩形框
         targetView：targetRect以targetView的左上角为坐标原点
         */
        // 显示菜单
        [menu setMenuVisible:YES animated:YES];
    }
}

/**
 * 通过这个方法告诉UIMenuController它内部应该显示什么内容
 * 返回YES，就代表支持action这个操作
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    //打印, 将一个方法转换成字符串 你就会看到许多方法
    NSLog(@"%@",NSStringFromSelector(action));
//    action == @selector(cut:)
//    action == @selector(copy:)
//    action == @selector(paste:)

    if (action == @selector(delete:)) {
        return YES;
    }
    
    return NO;
}

//监听事情需要对应的方法 冒号之后传入的是UIMenuController
- (void)delete:(UIMenuController *)menu {
    if (self.deleteMessageBlock) {
        self.deleteMessageBlock(self.messageId);
    }
}



- (void)setModel:(id<IYWMessage>)model {
    self.messageId = model.messageId;
}

- (void)setMessageOriginWithModel:(id<IYWMessage>)model {
//    self.unReadLabel.hidden = NO;
    BOOL isMeSend = YES;
    isMeSend = [model.messageFromPerson.personId isEqualToString:CMUserDefadultGet(CMPersonIdKey)]?YES:NO;
    /// 消息发送成功或失败
    if (model.messageSendStatus == YWMessageSendStatusSuccess) {
        [self resetUIState];
//        self.unReadLabel.hidden = NO;
//        if (isMeSend) {/// 只有自己的消息才要看对方是否已读
//            self.unReadLabel.text = model.receiverHasReaded ? @"已读" : @"未读";
//            self.unReadLabel.textColor = model.receiverHasReaded ? [UIColor grayColor] : [UIColor blueColor];
//        }
    }
    else {
        //self.unReadLabel.hidden = YES;
        if (model.messageSendStatus == YWMessageSendStatusFailed) {
            self.failButton.hidden = NO;
        }
        else {
            self.failButton.hidden = YES;
            [self.activityIndicator startAnimating];
        }
    }
    
    if (isMeSend) {
        ///发送者是自己
        [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(kLabelTopMargin);
            make.right.equalTo(self.contentView).offset(-kLabelTopMargin);
            make.width.height.mas_equalTo(kChatCellIconImageViewWH);
        }];
        
        self.activityIndicator.sd_resetLayout.centerYEqualToView(self.container)
        .rightSpaceToView(self.container, 2*kLabelTopMargin).widthIs(30).heightIs(30);
        
        self.failButton.sd_resetLayout
        .centerYEqualToView(self.container)
        .rightSpaceToView(self.container, kLabelTopMargin).widthIs(30).heightIs(30);
        
        self.containerBackgroundImageView.image =[UIImage imageNamed:@"SenderTextNodeBkg"];
    }
    else {
        
        //self.unReadLabel.hidden = YES;
        [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(kLabelTopMargin);
            make.width.height.mas_equalTo(kChatCellIconImageViewWH);
        }];
        
        self.activityIndicator.sd_resetLayout.centerYEqualToView(self.container)
        .leftSpaceToView(self.container, 2*kLabelTopMargin).widthIs(30).heightIs(30);
        
        self.failButton.sd_resetLayout.centerYEqualToView(self.container)
        .leftSpaceToView(self.container, kLabelTopMargin).widthIs(30).heightIs(30);
        
        self.containerBackgroundImageView.image = [UIImage imageNamed:@"ReceiverTextNodeBkg"] ;
        
        if (!model.receiverHasReaded) {
            /// 自己是否已读 自己就是接收者
            self.readMessageBlock ? self.readMessageBlock(self.messageId) : nil;
        }
    }
    
    self.personId = model.messageFromPerson.personId;
    
    __block UIImage * avatarImage;
    @weakify(self);
    [[SPUtil sharedInstance] syncGetCachedProfileIfExists:model.messageFromPerson
                                               completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                   avatarImage = aAvatarImage;
                                               }];
    if (!avatarImage) {
        [[SPUtil sharedInstance] asyncGetProfileWithPerson:model.messageFromPerson
                                                  progress:^(YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      [weak_self handleProfileResult:aDisplayName avatar:aAvatarImage];
                                                  } completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      [weak_self handleProfileResult:aDisplayName avatar:aAvatarImage];
                                                  }];
    }
    else {
        self.avatarImageView.image = avatarImage;
    }
    
}

- (void)handleProfileResult:(NSString *)displayName avatar:(UIImage *)avatar {
    if (avatar) {
        self.avatarImageView.image = avatar;
    }
    else {
        self.avatarImageView.image = AvatarPlaceholderImage;
    }
    
}

- (void)avatarImageViewGesClick:(id)sender {
    if (self.avatarClickBlock) {
        YWPerson * aPerson = [[YWPerson alloc]initWithPersonId:self.personId appKey:CMAPPKEY];
        self.avatarClickBlock(aPerson);
    }
}

- (void)containerViewGesClick:(id)sender {
    /// imageCell 重写了这个方法(没有调用父类这个方法) 所以imageCell 不会走这里
    if (self.containerClickBlock) {
        self.containerClickBlock(self.messageId);
    }
}

- (void)failBtnClick {
    if (self.rePostMessageBlock) {
        self.rePostMessageBlock(self.messageId);
    }
}
#pragma mark - 算高 -
+ (CGFloat)cellTextHeight:(id<IYWMessage>)model textLayoutDic:(NSMutableDictionary *)textLayoutDic {
    NSString * key = model.messageId;
    YWMessageBodyText * body = (YWMessageBodyText *)model.messageBody;
    YYTextLayout * lay = textLayoutDic[key];
    if (lay) {
        CGFloat height = lay.textBoundingSize.height + 6*kLabelTopMargin;
        return height;
    }
    NSMutableAttributedString * attMessage = [CMDefaultEmojiPresenter processCommentContentWithEmoticonInfo:body.messageText];
    YYTextContainer *container = [YYTextContainer new];
    CGSize maxsize = CGSizeMake(SCREEN_WIDTH - kMinContainerWidth, MAXFLOAT);
    container.size = maxsize;
    container.maximumNumberOfRows = 0;
    // 生成排版结果
    YYTextLayout * layout = [YYTextLayout layoutWithContainer:container text:attMessage];
    [textLayoutDic setValue:layout forKey:key];
    CGFloat height = layout.textBoundingSize.height + 6*kLabelTopMargin;
    return height;
}

+ (CGFloat)cellImageHeight:(id<IYWMessage>)model {
    YWMessageBodyImage * body = (YWMessageBodyImage *)model.messageBody;
    CGFloat WW = body.thumbnailImageSize.width;
    CGFloat HH = body.thumbnailImageSize.height;
    CGFloat widthHeightRatio = 0;
    CGFloat standardWidthHeightRatio = kMaxChatImageViewWidth / kMaxChatImageViewHeight;
    if (WW > kMaxChatImageViewWidth || WW > kMaxChatImageViewHeight) {
        widthHeightRatio = WW / HH;
        if (widthHeightRatio > standardWidthHeightRatio) {
            WW = kMaxChatImageViewWidth;
            HH = WW * (body.thumbnailImageSize.height / body.thumbnailImageSize.width);
        } else {
            HH = kMaxChatImageViewHeight;
            WW = HH * widthHeightRatio;
        }
    }
    return kLabelTopMargin + kLabelTopMargin + HH;
}

+ (CGFloat)cellLocationHeight {
    return kLabelTopMargin + kLabelTopMargin + kMaxChatLocationViewHeight;
}
+ (CGFloat)cellAudioHeight {
    return 64.0;
}
+ (CGFloat)cellDynamicHeight {
    return kLabelTopMargin + kLabelTopMargin + kLabelTopMargin + 80 + 2.5 * kLabelTopMargin;
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark --懒加载--
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewGesClick:)];
        [_avatarImageView addGestureRecognizer:tap];
        _avatarImageView.userInteractionEnabled = YES;
    }
    return _avatarImageView;
}

- (UIView *)container {
    if (!_container) {
        _container = [UIView new];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerViewGesClick:)];
        [_container addGestureRecognizer:tap];
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
        [_container addGestureRecognizer:longPress];
    }
    return _container;
}
- (UIImageView *)containerBackgroundImageView {
    if (!_containerBackgroundImageView) {
        _containerBackgroundImageView = [UIImageView new];
    }
    return _containerBackgroundImageView;
}
- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityIndicator;
}

- (UIButton *)failButton {
    if (!_failButton) {
        _failButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_failButton setImage:[UIImage imageNamed:@"msg_fail"] forState:UIControlStateNormal];
        [_failButton setTarget:self action:@selector(failBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failButton;
}
//
//- (UILabel *)unReadLabel {
//    if (!_unReadLabel) {
//        _unReadLabel = [[UILabel alloc]init];
//        _unReadLabel.font = [UIFont systemFontOfSize:12];
//        _unReadLabel.text = @"未读";
//        _unReadLabel.textColor = [UIColor grayColor];
//    }
//    return _unReadLabel;
//}
@end
