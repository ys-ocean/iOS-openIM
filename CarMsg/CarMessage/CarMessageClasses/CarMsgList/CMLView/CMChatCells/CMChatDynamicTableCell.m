//
//  CMChatDynamicTableCell.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/17.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMChatDynamicTableCell.h"
@interface CMChatDynamicTableCell ()
@property (strong, nonatomic) YYAnimatedImageView * messageImageView;
@end

@implementation CMChatDynamicTableCell

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
    [self.container addSubview:self.messageImageView];
}

- (void)setModel:(id<IYWMessage>)model {
    
    [super setModel:model];
    YWMessageBodyCustomize * body = (YWMessageBodyCustomize *)model.messageBody;
    YYImage * image = [YYImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",body.content] ofType:@"gif"]];
    self.messageImageView.image = image;
    
    [self setMessageOriginWithModel:model];
}

- (void)setMessageOriginWithModel:(id<IYWMessage>)model {
    [super setMessageOriginWithModel:model];
    
    CGFloat WW = [CMChatBaseTableCell cellDynamicHeight] - kLabelTopMargin - kLabelTopMargin;
    CGFloat HH = WW;
    
    if ([model.messageFromPerson.personId isEqualToString:CMUserDefadultGet(CMPersonIdKey)]) {
        /// 自己发送的消息
        [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_top).offset(kLabelTopMargin);
            make.right.equalTo(self.avatarImageView.mas_left).offset(-kLabelTopMargin);
            make.height.mas_equalTo(HH);
            make.width.mas_equalTo(WW);
        }];
        [self.messageImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kLabelTopMargin);
            make.bottom.mas_equalTo(-2.5 * kLabelTopMargin);
            make.left.mas_equalTo(kLabelTopMargin/2);
            make.right.mas_equalTo(-2 * kLabelTopMargin);
        }];
    }
    else {
        [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_top).offset(kLabelTopMargin);
            make.left.equalTo(self.avatarImageView.mas_right).offset(kLabelTopMargin);
            make.height.mas_equalTo(HH);
            make.width.mas_equalTo(WW);
        }];
        [self.messageImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kLabelTopMargin);
            make.bottom.mas_equalTo(-2.5 * kLabelTopMargin);
            make.right.mas_equalTo(-kLabelTopMargin/2);
            make.left.mas_equalTo(2 * kLabelTopMargin);
        }];
    }
}

- (YYAnimatedImageView *)messageImageView {
    if (!_messageImageView) {
        _messageImageView = [[YYAnimatedImageView alloc]init];
        _messageImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _messageImageView;
}
@end
