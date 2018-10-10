//
//  CMChatAudioTableCell.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/15.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMChatAudioTableCell.h"

@interface CMChatAudioTableCell ()
@property (nonatomic, strong) UILabel * timeLabel; //语音时长 Label
@property (nonatomic, strong) UIImageView * audioImageView;//
@end


@implementation CMChatAudioTableCell

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
    
    [self.container addSubview:self.audioImageView];
    [self.container addSubview:self.timeLabel];
}

- (void)containerViewGesClick:(id)sender {
    
    if (self.audioImageView.isAnimating) {
        [self.audioImageView stopAnimating];
    }
    else {
        [self.audioImageView startAnimating];
    }
    [super containerViewGesClick:sender];
}

- (void)setModel:(id<IYWMessage>)model {
    [super setModel:model];
    YWMessageBodyVoice * body = (YWMessageBodyVoice *)model.messageBody;
    if (body.messageVoiceDuration <1) {
        self.timeLabel.text = [NSString stringWithFormat:@"?''"];
    }
    else {
        self.timeLabel.text = [NSString stringWithFormat:@"%.f''",body.messageVoiceDuration];
    }
    [self setMessageOriginWithModel:model];
}

- (void)setMessageOriginWithModel:(id<IYWMessage>)model {
    [super setMessageOriginWithModel:model];
    YWMessageBodyVoice * body = (YWMessageBodyVoice *)model.messageBody;
    CGFloat space = 2;
    CGFloat WW = 50;
    WW += [self messageWW:body.messageVoiceDuration];
    if ([model.messageFromPerson.personId isEqualToString:CMUserDefadultGet(CMPersonIdKey)]) {
        /// 自己
        [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_top).offset(kLabelTopMargin);
            make.right.equalTo(self.avatarImageView.mas_left).offset(-kLabelTopMargin);
            make.height.mas_equalTo(40 + kLabelTopMargin);
            make.width.mas_equalTo(WW);
        }];
        
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kLabelTopMargin + space);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-kLabelTopMargin);
        }];
        [self.audioImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kLabelTopMargin-space);
            make.top.mas_equalTo((40-15)/2);
            make.width.height.mas_equalTo(15);
        }];
        self.audioImageView.image =[UIImage imageNamed:@"weiliao_icon_yuyinright"];
        self.audioImageView.animationImages =@[[UIImage imageNamed:@"weiliao_icon_yuyinright"],[UIImage imageNamed:@"weiliao_icon_yuyinright1"],[UIImage imageNamed:@"weiliao_icon_yuyinright2"]];
    }
    else {
        [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_top).offset(kLabelTopMargin);
            make.left.equalTo(self.avatarImageView.mas_right).offset(kLabelTopMargin);
            make.height.mas_equalTo(40 + kLabelTopMargin);
            make.width.mas_equalTo(WW);
        }];
        
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kLabelTopMargin-space);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-kLabelTopMargin);
        }];
        [self.audioImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kLabelTopMargin+space);
            make.top.mas_equalTo((40-15)/2);
            make.width.height.mas_equalTo(15);
        }];
        self.audioImageView.image =[UIImage imageNamed:@"weiliao_icon_yuyinleft"];
        self.audioImageView.animationImages =@[[UIImage imageNamed:@"weiliao_icon_yuyinleft"],[UIImage imageNamed:@"weiliao_icon_yuyinleft1"],[UIImage imageNamed:@"weiliao_icon_yuyinleft2"]];
    }
    if (self.voiceState == CMVoicePlayStatePlaying) {
        [self.audioImageView startAnimating];
    }
    else {
        [self.audioImageView stopAnimating];
    }
}

- (CGFloat)messageWW:(NSTimeInterval)audioLength {
    CGFloat allW =(SCREEN_WIDTH -150);
    CGFloat mult =0;
    
    if (audioLength > 2 && audioLength <= 10) {
        mult = 0.35;
    }
    else if (audioLength >11 && audioLength <= 20) {
        mult = 0.25;
    }
    else if (audioLength > 21 && audioLength <= 30) {
        mult = 0.2;
    }
    else if (audioLength > 31 && audioLength <= 40) {
        mult = 0.15;
    }
    else if (audioLength > 41 && audioLength <= 50) {
        mult = 0.1;
    }
    else {
        mult = 0.5;
    }
    CGFloat subMult = audioLength/10.0;
    return allW * mult * subMult;
}

- (void)dealloc {
    if (self.audioImageView.isAnimating) {
        [self.audioImageView stopAnimating];
    }
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor grayColor];
    }
    return _timeLabel;
}

- (UIImageView *)audioImageView {
    if (!_audioImageView) {
        _audioImageView =[UIImageView new];
        _audioImageView.animationDuration = 1.0;
        //设置重复次数，0表示无限
        _audioImageView.animationRepeatCount = 0;
    }
    return _audioImageView;
}
@end
