//
//  CarMsgChatDefaultCell.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/2.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CarMsgChatDefaultCell.h"

@interface CarMsgChatDefaultCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation CarMsgChatDefaultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    /// 异步绘制 内容需要反复重绘的情况设置为false
    self.layer.drawsAsynchronously = YES;
    /// cell优化尽量减少图层的数量，相当于就只有一层，相对画面中移动但自身外观不变的对象
    self.layer.shouldRasterize = YES;
    /// 必须制定分辨率
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)setPresenter:(CMCListCellPresenter *)presenter {
    self.titleLabel.text = presenter.titleText;
    self.numberLabel.text = presenter.numberText;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
