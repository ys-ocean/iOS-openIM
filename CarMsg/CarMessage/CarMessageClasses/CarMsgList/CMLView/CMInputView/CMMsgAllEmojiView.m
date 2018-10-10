//
//  CMMsgAllEmojiView.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/5.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMMsgAllEmojiView.h"
#import "CMDefaultEmojiViewController.h"
#import "CMPlugInViewController.h"
@interface CMMsgAllEmojiView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) CMDefaultEmojiViewController * defaultEmojiVC;
@property (strong, nonatomic) CMPlugInViewController * plugInVC;
@property (copy, nonatomic) void(^didPlugInKeyboardBlock)(void);
@end

@implementation CMMsgAllEmojiView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addUI];
    }
    return self;
}

- (void)addUI {
    self.backgroundColor = EMOJI_BG_COLOR;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.defaultEmojiVC = [CMDefaultEmojiViewController instanceWithViewFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.plugInVC = [CMPlugInViewController instanceWithPresenter:[[CMPlugInPresenter alloc]init]];
    @weakify(self);
    [self.plugInVC setDidPlugInBlokc:^{
        if (weak_self.didPlugInKeyboardBlock) {
            weak_self.didPlugInKeyboardBlock();
        }
    }];
    
    [self.scrollView addSubview:self.defaultEmojiVC.view];
    [self.scrollView addSubview:self.plugInVC.collectionView];
}

- (void)setSelectIndex:(NSUInteger)selectIndex {
    _selectIndex = selectIndex;
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * selectIndex, 0) animated:NO];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = EMOJI_BG_COLOR;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, EMOJI_SCROLL_HEIGHT);
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

@end
