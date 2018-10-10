//
//  CMChatImageTableCell.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/15.
//  Copyright © 2018年 xiaohai. All rights reserved.a
//

#import "CMChatImageTableCell.h"
#import "XLPhotoBrowser.h"
@interface CMChatImageTableCell ()<XLPhotoBrowserDelegate,XLPhotoBrowserDatasource>
@property (nonatomic, strong) UIImageView * messageImageView; //消息图片 imageView
@property (nonatomic, strong) UIImageView * maskImageView; //图片展示时候 遮罩
@end

@implementation CMChatImageTableCell

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
}

- (void)setModel:(id<IYWMessage>)model {
    [super setModel:model];
    YWMessageBodyImage * body = (YWMessageBodyImage *)model.messageBody;
    @weakify(self);
    [body asyncGetThumbnailImageWithProgress:^(CGFloat progress) {
        
    } completion:^(NSData *imageData, NSError *aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
           weak_self.messageImageView.image = [UIImage imageWithData:imageData];
        });
    }];
    [self setMessageOriginWithModel:model];

}

- (void)setMessageOriginWithModel:(id<IYWMessage>)model {
    [super setMessageOriginWithModel:model];
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
    
    if ([model.messageFromPerson.personId isEqualToString:CMUserDefadultGet(CMPersonIdKey)]) {
        /// 自己
        [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_top).offset(kLabelTopMargin);
            make.right.equalTo(self.avatarImageView.mas_left).offset(-kLabelTopMargin);
            make.height.mas_equalTo(HH);
            make.width.mas_equalTo(WW);
        }];
    }
    else {
        [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_top).offset(kLabelTopMargin);
            make.left.equalTo(self.avatarImageView.mas_right).offset(kLabelTopMargin);
            make.height.mas_equalTo(HH);
            make.width.mas_equalTo(WW);
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


- (void)containerViewGesClick:(id)sender {
    XLPhotoBrowser * browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:0 imageCount:1 datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleSimple;
}

#pragma mark    -   XLPhotoBrowserDatasource
- (CGRect)photoBrowser:(XLPhotoBrowser *)browser imageViewRectForIndex:(NSInteger)index {
    //self 上的messageImageView 相对于 window上的坐标
    return [self convertRect:self.container.frame toView:[UIApplication sharedApplication].keyWindow];
}
/**
 *  返回这个位置的占位图片 , 也可以是原图(如果不实现此方法,会默认使用placeholderImage)
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 占位图片
 */
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return self.messageImageView.image;
}

/**
 *  返回指定位置图片的UIImageView,用于做图片浏览器弹出放大和消失回缩动画等
 *  如果没有实现这个方法,没有回缩动画,如果传过来的view不正确,可能会影响回缩动画效果
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 展示图片的容器视图,如UIImageView等
 */
- (UIView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index {
    return self.messageImageView;
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
    }
    return _messageImageView;
}
@end
