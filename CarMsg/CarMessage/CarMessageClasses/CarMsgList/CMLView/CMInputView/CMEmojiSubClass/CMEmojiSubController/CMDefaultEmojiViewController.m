//
//  CMDefaultEmojiViewController.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/7.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMDefaultEmojiViewController.h"
#import "CMEmojiPageCollectionView.h"
#import "CMDynamicEmojiPageCollectionView.h"

#import "HMSegmentedControl.h"
#import "CMEmojiPageViewLayout.h"
#define SEND_BTN_WIDTH 80
#define PAGECONTROL_HEIGHT 20
@interface CMDefaultEmojiViewController ()
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) HMSegmentedControl * segmented;
@property (strong, nonatomic) UIPageControl * pageControl;
@property (strong, nonatomic) CMEmojiPageCollectionView * collectionView;
@property (strong, nonatomic) CMDynamicEmojiPageCollectionView * dynamicCollectionView;
@property (assign, nonatomic) CGRect viewFrame;
@property (strong, nonatomic) UIButton * sendBtn;

@end

@implementation CMDefaultEmojiViewController

+ (instancetype)instanceWithViewFrame:(CGRect)frame {
    CMDefaultEmojiViewController * obj = [[CMDefaultEmojiViewController alloc]init];
    obj.viewFrame = frame;
    return obj;
}

- (void)viewDidLoad {
    [self addUI];
    [self configuration];
}

- (void)addUI {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.collectionView];
    [self.scrollView addSubview:self.dynamicCollectionView];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.segmented];
    [self.view addSubview:self.sendBtn];
    CGFloat w = self.segmented.frame.size.width;
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_segmented.mas_top);
        make.left.equalTo(_segmented.mas_right).offset(SCREEN_WIDTH - w - SEND_BTN_WIDTH);
        make.width.mas_equalTo(SEND_BTN_WIDTH);
        make.height.mas_equalTo(TABBAR_HEIGHT - AreaBottomHeight);
    }];
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageControl.frame), self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1];
    [self.view addSubview:lineView];
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmented.frame), self.view.frame.size.width, 1)];
    lineView2.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1];
    [self.view addSubview:lineView2];
    
    /// 默认显示第一个
    self.pageControl.numberOfPages = self.collectionView.presenter.dataArray.count;
}

- (void)configuration {
    
    @weakify(self);
    
    [self.collectionView setAddEmojiBlock:^(CMTextAttachment * attach) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CMEmojiDidSelectNotification object:nil userInfo:@{CMEmojiDidSelectKey:attach}];
    }];
    [self.collectionView setDeleteEmoji:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:CMEmojiDidDeleteNotification object:nil userInfo:nil];
    }];
    [self.dynamicCollectionView setDidSelectDynamicEmojiBlock:^(NSString * imageName) {
        [weak_self sendDynamicEmojiNotification:imageName];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationMethod:) name:CMKeyBoardWillShowWillHideKey object:nil];
}

- (void)notificationMethod:(NSNotification *)notification {
    NSDictionary * userInfo = notification.userInfo;
    NSNumber * number = userInfo[CMKeyBoardShowHideUserInfoValueKey];
    if ([number integerValue]<1) {
        self.segmented.selectedSegmentIndex = 0;
    }
}

- (void)sendDynamicEmojiNotification:(NSString *)imageName {
    [[NSNotificationCenter defaultCenter]postNotificationName:CMSendNotificationKey object:nil userInfo:@{CMSendMsgNotificationTypeKey:@(CMSendMessageTypeDynamicImage),CMSendMsgSubNotifiImageKey:imageName}];
}

- (void)sendBtnMessageNotification {
    [[NSNotificationCenter defaultCenter]postNotificationName:CMSendNotificationKey object:nil userInfo:@{CMSendMsgNotificationTypeKey:@(CMSendMessageTypeText)}];
}

- (void)pageControlNumberOfPages:(NSInteger)index {
    if (index == 0) {
        self.pageControl.numberOfPages = self.collectionView.presenter.dataArray.count;
        self.pageControl.currentPage = self.collectionView.lastSelectIndex;
    }
    else {
        self.pageControl.numberOfPages = self.dynamicCollectionView.itemArray.count;
        self.pageControl.currentPage = self.dynamicCollectionView.lastSelectIndex;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (UIView *)view {
    if (!_view) {
        _view = [[UIView alloc]initWithFrame:self.viewFrame];
        _view.backgroundColor = EMOJI_BG_COLOR;
        [self viewDidLoad];
    }
    return _view;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat h = self.viewFrame.size.height - TABBAR_HEIGHT  - PAGECONTROL_HEIGHT;
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.viewFrame.size.width, h)];
        _scrollView.scrollEnabled = NO;
        _scrollView.backgroundColor = EMOJI_BG_COLOR;
    }
    return _scrollView;
}

- (CMEmojiPageCollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat h = self.viewFrame.size.height - TABBAR_HEIGHT  - PAGECONTROL_HEIGHT;
        CMEmojiPageViewLayout * layout = [[CMEmojiPageViewLayout alloc]init];
        layout.isWidthEqualHeight = YES;
        layout.width = self.viewFrame.size.width;
        layout.height = h;
        layout.VerticalNumber = [NSNumber numberWithUnsignedInteger:CMPageViewVerticalCount];
        layout.HorizontalNumber = [NSNumber numberWithUnsignedInteger:CMPageViewHorizontalCount];
        layout.inset = UIEdgeInsetsMake(16, 8, 16, 8);
        layout.itemLRSpace = 8;
        _collectionView = [[CMEmojiPageCollectionView alloc]initWithFrame:CGRectMake(0, 0, layout.width, layout.height) collectionViewLayout:layout];
        _collectionView.pageControl = self.pageControl;
    }
    return _collectionView;
}
- (CMDynamicEmojiPageCollectionView *)dynamicCollectionView {
    if (!_dynamicCollectionView) {
        CGFloat h = self.viewFrame.size.height - TABBAR_HEIGHT  - PAGECONTROL_HEIGHT;
        CMEmojiPageViewLayout * layout = [[CMEmojiPageViewLayout alloc]init];
        layout.width = self.viewFrame.size.width;
        layout.height = h;
        layout.VerticalNumber = [NSNumber numberWithUnsignedInteger:CMDynamicPageVerticalCount];
        layout.HorizontalNumber = [NSNumber numberWithUnsignedInteger:CMDynamicPageHorizontalCount];
        layout.inset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemLRSpace = 0;
        _dynamicCollectionView = [[CMDynamicEmojiPageCollectionView alloc]initWithFrame:CGRectMake(layout.width, 0, layout.width, layout.height) collectionViewLayout:layout];
        _dynamicCollectionView.pageControl = self.pageControl;
    }
    return _dynamicCollectionView;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), self.view.frame.size.width, PAGECONTROL_HEIGHT)];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#F5A623"];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#BCBCBC"];
        _pageControl.currentPage = 0;
        _pageControl.backgroundColor = EMOJI_BG_COLOR;
    }
    return _pageControl;
}

- (HMSegmentedControl *)segmented {
    if (!_segmented) {
        UIColor * lineColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1];
        NSArray * imgs = @[[UIImage imageNamed:@"face_w"],[UIImage imageNamed:@"face_w"]];
        _segmented = [[HMSegmentedControl alloc]initWithSectionImages:imgs sectionSelectedImages:imgs];
        _segmented.backgroundColor = EMOJI_BG_COLOR;
        _segmented.selectionIndicatorBoxColor = [UIColor grayColor];
        _segmented.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmented.selectionStyle = HMSegmentedControlSelectionStyleBox;
        _segmented.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
        _segmented.verticalDividerEnabled = YES;
        _segmented.verticalDividerColor = lineColor;
        _segmented.verticalDividerWidth = 1.0f;
        /// maxWidth SCREEN_WIDTH - SEND_BTN_WIDTH
        CGFloat h = TABBAR_HEIGHT - AreaBottomHeight;
        CGFloat w = SEND_BTN_WIDTH * imgs.count;
        _segmented.frame = CGRectMake(0, self.view.frame.size.height - TABBAR_HEIGHT, w, h);
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(w - 1, 0, 1, h)];
        line.backgroundColor = lineColor;
        [_segmented addSubview:line];
        @weakify(self);
        [_segmented setIndexChangeBlock:^(NSInteger index) {
            [weak_self.scrollView setContentOffset:CGPointMake(weak_self.viewFrame.size.width * index, 0) animated:NO];
            [weak_self pageControlNumberOfPages:index];
        }];
    }
    return _segmented;
}
- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBtn.backgroundColor = [UIColor blueColor];
        [_sendBtn setTarget:self action:@selector(sendBtnMessageNotification) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
@end
