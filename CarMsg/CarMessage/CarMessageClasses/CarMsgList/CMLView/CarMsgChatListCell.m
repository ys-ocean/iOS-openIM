//
//  CarMsgChatListCell.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/2.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CarMsgChatListCell.h"

@interface CarMsgChatListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView * numberView;
@property (weak, nonatomic) IBOutlet UILabel * numberLabel;
@property (strong, nonatomic) YYLabel * contentLabel;
@end

@implementation CarMsgChatListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    /// 异步绘制 内容需要反复重绘的情况设置为false
    self.layer.drawsAsynchronously = YES;
    /// cell优化尽量减少图层的数量，相当于就只有一层，相对画面中移动但自身外观不变的对象
    self.layer.shouldRasterize = YES;
    /// 必须制定分辨率
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.content.hidden = YES;
    self.numberView.hidden = YES;
    [self addSubview:self.contentLabel];
}

- (void)setPresenter:(CMCListCellPresenter *)presenter {
    _presenter = presenter;
    self.headImage.image = _presenter.avatarImage;
    self.nickName.text = _presenter.nickNameText;
    self.time.text = _presenter.timeText;
    
    self.contentLabel.attributedText = _presenter.contentText;
    
    self.numberLabel.text = _presenter.numberText;

    if ([_presenter.numberText integerValue] < 1) {
        self.numberView.hidden = YES;
    }
    else {
        self.numberView.hidden = NO;
    }
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc]initWithFrame:CGRectMake(66, 40, SCREEN_WIDTH - 66 - 8, 20)];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor grayColor];
        ///异步加载 内容非常大 还是建议打开 虽然刷新有时候看上去 有点闪
        _contentLabel.displaysAsynchronously = NO;
        _contentLabel.numberOfLines = 1;
        _contentLabel.userInteractionEnabled = NO;
    }
    return _contentLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
