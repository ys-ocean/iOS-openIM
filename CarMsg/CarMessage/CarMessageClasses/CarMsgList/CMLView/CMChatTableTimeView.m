//
//  CMChatTableTimeView.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/20.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMChatTableTimeView.h"

@interface CMChatTableTimeView ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation CMChatTableTimeView

- (void)awakeFromNib {
    self.backgroundColor = EMOJI_BG_COLOR;
}

- (void)setTime:(NSString *)time {
    self.timeLabel.text = time;
}

@end
