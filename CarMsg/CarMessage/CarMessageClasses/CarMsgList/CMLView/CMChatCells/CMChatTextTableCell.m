//
//  CMChatTextTableCell.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/14.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMChatTextTableCell.h"

@interface CMChatTextTableCell ()
@property (nonatomic, strong) YYLabel * contentLabel; //内容
@property (nonatomic, strong) NSMutableAttributedString * attMessage;
@end


@implementation CMChatTextTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addUI];
}

- (void)addUI {
    [super addUI];
    
    [self.container addSubview:self.contentLabel];
    
}

- (void)setModel:(id<IYWMessage>)model {
    [super setModel:model];
    YWMessageBodyText * body = (YWMessageBodyText *)model.messageBody;
    self.attMessage = [CMDefaultEmojiPresenter processCommentContentWithEmoticonInfo:body.messageText];
    [self setMessageOriginWithModel:model];
    self.contentLabel.attributedText = self.attMessage;
}

- (void)setMessageOriginWithModel:(id<IYWMessage>)model {
    [super setMessageOriginWithModel:model];
    CGSize textWH = [self returnMessageLayout:model];
    if ([model.messageFromPerson.personId isEqualToString:CMUserDefadultGet(CMPersonIdKey)]) {
        /// 自己
        [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_top).offset(kLabelTopMargin);
            make.right.equalTo(self.avatarImageView.mas_left).offset(-kLabelTopMargin);
            make.height.mas_equalTo(textWH.height + 4*kLabelTopMargin);
            make.width.mas_equalTo(textWH.width + 4*kLabelTopMargin);
            //make.bottom.mas_equalTo(-kLabelTopMargin).priority(999); /// 约束算高需要加上
        }];
        self.contentLabel.frame =CGRectMake(kLabelTopMargin *2 , 1.5 *kLabelTopMargin, textWH.width, textWH.height);
    }
    else {
        [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_top).offset(kLabelTopMargin);
            make.left.equalTo(self.avatarImageView.mas_right).offset(kLabelTopMargin);
            make.height.mas_equalTo(textWH.height + 4*kLabelTopMargin);
            make.width.mas_equalTo(textWH.width + 4*kLabelTopMargin);
            //make.bottom.mas_equalTo(0).priority(999); /// 约束算高需要加上
        }];
        self.contentLabel.frame = CGRectMake(kLabelTopMargin * 2 + 2, 1.5 * kLabelTopMargin, textWH.width, textWH.height);
        
    }
}

- (CGSize)returnMessageLayout:(id<IYWMessage>)model {
    
    NSString * key = model.messageId;
    YYTextLayout * lay = self.textLayoutDic[key];
    if (lay) {
        self.contentLabel.textLayout = lay;
        CGSize size = CGSizeMake(lay.textBoundingSize.width, lay.textBoundingSize.height);
        return size;
    }
    NSMutableAttributedString * attMessage = self.attMessage;
    YYTextContainer *container = [YYTextContainer new];
    CGSize maxsize = CGSizeMake(SCREEN_WIDTH - kMinContainerWidth, MAXFLOAT);
    container.size = maxsize;
    container.maximumNumberOfRows = 0;
    // 生成排版结果
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attMessage];
    self.contentLabel.textLayout = layout;
    CGSize size = CGSizeMake(layout.textBoundingSize.width, layout.textBoundingSize.height);

    [self.textLayoutDic setValue:layout forKey:key];
    return size;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc]init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = CHAT_FONT;
        ///异步加载 内容非常大 还是建议打开 虽然刷新有时候看上去 有点闪
        _contentLabel.displaysAsynchronously = NO;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _contentLabel.userInteractionEnabled = NO;
        _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - kMinContainerWidth;
    }
    return _contentLabel;
}
@end
