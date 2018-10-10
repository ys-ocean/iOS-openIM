//
//  CMChatLocationTableCell.m
//  CarMessage
//
//  Created by 胡海峰 on 2038/3/35.
//  Copyright © 2038年 xiaohai. All rights reserved.
//

#import "CMChatLocationTableCell.h"

@interface CMChatLocationTableCell ()
@property (nonatomic, strong) UIImageView * messageImageView; //消息图片 imageView
@property (nonatomic, strong) UIImageView * maskImageView; //图片展示时候 遮罩
@property (nonatomic, strong) UIView * locationLabelView;
@property (nonatomic, strong) UILabel * locationLabel;
@end

@implementation CMChatLocationTableCell

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
    [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.container addSubview:self.locationLabelView];
    [self.locationLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0).priority(999);
    }];
    [self.locationLabelView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kLabelTopMargin);
        make.right.mas_equalTo(-kLabelTopMargin);
        make.bottom.mas_equalTo(-2*kLabelTopMargin);
        make.height.greaterThanOrEqualTo(@20);
    }];
}

- (void)setModel:(id<IYWMessage>)model {
    [super setModel:model];
    YWMessageBodyLocation * body = (YWMessageBodyLocation *)model.messageBody;
    self.locationLabel.text = body.locationName;
    [self setMessageOriginWithModel:model];
}

- (void)setMessageOriginWithModel:(id<IYWMessage>)model {
    [super setMessageOriginWithModel:model];

    if ([model.messageFromPerson.personId isEqualToString:CMUserDefadultGet(CMPersonIdKey)]) {
        /// 自己
        [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_top).offset(kLabelTopMargin);
            make.right.equalTo(self.avatarImageView.mas_left).offset(-kLabelTopMargin);
            make.height.mas_equalTo(kMaxChatLocationViewHeight);
            make.width.mas_equalTo(kMaxChatLocationViewWidth);
        }];

    }
    else {
        [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_top).offset(kLabelTopMargin);
            make.left.equalTo(self.avatarImageView.mas_right).offset(kLabelTopMargin);
            make.height.mas_equalTo(kMaxChatLocationViewHeight);
            make.width.mas_equalTo(kMaxChatLocationViewWidth);
        }];

    }
    self.maskImageView.image = self.containerBackgroundImageView.image;
    self.container.layer.mask = self.maskImageView.layer;
    @weakify(self);
    [self.containerBackgroundImageView setDidFinishAutoLayoutBlock:^(CGRect frame) { ///containerBackgroundImageView 必须是 SDAutoLayout 设置的约束 否则这里size 不走 图片不显示
        // 在_containerBackgroundImageView的frame确定之后设置maskImageView的size等于containerBackgroundImageView的size
        weak_self.maskImageView.size = frame.size;
    }];
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc]init];
        _locationLabel.textColor = [UIColor whiteColor];
        _locationLabel.font = [UIFont systemFontOfSize:12];
        _locationLabel.numberOfLines = 2;
        _locationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _locationLabel;
}

- (UIView *)locationLabelView {
    if (!_locationLabelView) {
        _locationLabelView = [[UIView alloc]init];
        _locationLabelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }
    return _locationLabelView;
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView =[UIImageView new];
    }
    return _maskImageView;
}


- (UIImageView *)messageImageView {
    if (!_messageImageView) {
        _messageImageView =[UIImageView new];
        _messageImageView.image = [UIImage imageNamed:@"location_bg"];
    }
    return _messageImageView;
}

@end
