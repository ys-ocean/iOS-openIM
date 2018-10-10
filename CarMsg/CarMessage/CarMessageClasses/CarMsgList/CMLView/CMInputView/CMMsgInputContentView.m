//
//  CMMsgInputContentView.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/5.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMMsgInputContentView.h"
#import "EmojiModel.h"
#import "NSAttributedString+EmojiExtensionString.h"

@interface CMMsgInputContentView () <YWRecordKitDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>
@property (copy, nonatomic) void(^postTextMessageBlock)(NSString *);
@property (copy, nonatomic) void(^postAudioMessageBlock)(NSData *, NSTimeInterval);
@property (copy, nonatomic) void(^postLocationMessageBlock)(CLLocationCoordinate2D, NSString *);
@property (copy, nonatomic) void(^postImageMessageBlock)(UIImage *);
@property (copy, nonatomic) void(^postDynamicImageMessageBlock)(NSString *);
@property (strong, nonatomic) UITapGestureRecognizer * gesture;

@property (weak, nonatomic) IBOutlet UIButton * moreBtn;
@property (weak, nonatomic) IBOutlet UIButton * emojiBtn;
@property (weak, nonatomic) IBOutlet UIButton * voiceBtn;
/// 键盘是否弹起
@property (assign, nonatomic) BOOL isTextViewFirstResponse;
/// 键盘是否弹起
@property (assign, nonatomic) CGFloat keyboardHeight;
/// 是否点击了textView变成编辑状态（点击插件btn 恢复textView变成未点击状态）
@property (assign, nonatomic) BOOL isTouchTextView;

/// 键盘切换语音前textView的文本
@property (copy, nonatomic) NSAttributedString * lastAttributedString;
/// textView最小高度
@property (assign, nonatomic) CGFloat minTextViewH;
/// textView最大高度
@property (assign, nonatomic) CGFloat maxTextViewH;
/// textView当前高度
@property (assign, nonatomic) CGFloat currentTextViewH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightLayout;

@end

@implementation CMMsgInputContentView

- (BOOL)isTextViewFirstResponse {
    return self.textView.isFirstResponder;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addUI];
    [self configEmoji];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    self.minTextViewH = 37.5;
    self.maxTextViewH = 116;
}
- (void)addUI {
    self.textView.delegate = self;
    self.textView.font = CHAT_FONT;
    self.textView.layer.borderColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0].CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.cornerRadius = 4.0;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.returnKeyType = UIReturnKeySend;
//    if (@available(iOS 11.0, *)) {
//        self.textView.textDragInteraction.enabled = NO;
//    }
    //点击手势
    self.gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapChange:)];
    self.gesture.numberOfTapsRequired = 1;
    self.gesture.delegate = self;
    [self.textView addGestureRecognizer:self.gesture];
    
    UIImage * add_fix = [UIImage imageNamed:@"input_ico_add_nor"];
    add_fix = [add_fix imageByRotate:M_PI_4 fitSize:NO];
    [self.moreBtn setImage:add_fix forState:UIControlStateSelected];
    
    [self addSubview:self.recordKit.recordView];
    self.recordKit.recordView.layer.borderWidth = 0.5;
    self.recordKit.recordView.layer.cornerRadius = 4.0;
}
/// 配置表情视图
- (void)configEmoji {
    self.emojiView.backgroundColor = EMOJI_BG_COLOR;
    @weakify(self);
    [self.emojiView setDidPlugInKeyboardBlock:^{
        [weak_self moreButtonClick:weak_self.moreBtn];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:CMEmojiDidSelectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtnClicked) name:CMEmojiDidDeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationMethod:) name:CMSendNotificationKey object:nil];
}

- (void)notificationMethod:(NSNotification *)notification {
    NSDictionary * userInfo = notification.userInfo;
    CMSendMessageType type = [userInfo[CMSendMsgNotificationTypeKey]integerValue];
    if (type == CMSendMessageTypeText) {
        [self sendMsg];
    }
    else if (type == CMSendMessageTypeLocation) {
        double lon = [userInfo[CMSendMsgSubNotifiLongitudeKey]doubleValue];
        double lat = [userInfo[CMSendMsgSubNotifiLatitudeKey]doubleValue];
        NSString * title = userInfo[CMSendMsgSubNotifiLocationNameKey];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lon);
        [self postLocationMsg:coordinate title:title];
    }
    else if (type == CMSendMessageTypeImage) {
        UIImage * image = userInfo[CMSendMsgSubNotifiImageKey];
        [self postImageMsg:image];
    }
    else if (type == CMSendMessageTypeDynamicImage) {
        NSString * gifImageName = userInfo[CMSendMsgSubNotifiImageKey];
        [self postDynamicImage:gifImageName];
    }
}

- (void)postDynamicImage:(NSString *)aImageName {
    self.postDynamicImageMessageBlock ? self.postDynamicImageMessageBlock(aImageName) : nil;
}

/// 发送图片
- (void)postImageMsg:(UIImage *)image {
    self.postImageMessageBlock ? self.postImageMessageBlock(image) : nil;
}

/// 发送地理位置
- (void)postLocationMsg:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
    self.postLocationMessageBlock ? self.postLocationMessageBlock(coordinate, title) : nil;
}

/// 发送文本
- (void)sendMsg {
    if ([self.textView.text length]) {
        if (self.postTextMessageBlock) {
            self.postTextMessageBlock([self msgText]);
        }
        self.lastAttributedString = [[NSAttributedString alloc]initWithString:@""];
        self.textView.text = @"";
        [self textViewDidChange:self.textView];
    }
    else {
        [self showToastWithText:@"字数不得少于零" position:CSToastPositionCenter];
    }
}
- (void)emotionDidSelected:(NSNotification *)notifi {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTextAttachment * attach = notifi.userInfo[CMEmojiDidSelectKey];
        NSUInteger loc = self.textView.selectedRange.location;
        NSRange range = self.textView.selectedRange;
        NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
        /// 拼接其他文字
        [attributedText replaceCharactersInRange:range withAttributedString:imageStr];
        [attributedText addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, attributedText.length)];
        self.textView.attributedText = attributedText;
        /// 移除光标到表情的后面
        self.textView.selectedRange = NSMakeRange(loc + 1, 0);
        [self textViewDidChange:self.textView];
    });
}
- (void)deleteBtnClicked {
    [self.textView deleteBackward];
}

#pragma mark --处理键盘和视图的上移下移--
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    if (![self.textView.inputView isEqual:self.emojiView]) {
        /// 记录文本键盘高度
        self.keyboardHeight = keyboardF.size.height;
    }

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyboardF.size.height);
    }];
    [self.viewController.view layoutIfNeeded];

    [[NSNotificationCenter defaultCenter]postNotificationName:CMKeyBoardWillShowWillHideKey object:nil userInfo:@{CMKeyBoardShowHideUserInfoValueKey:@(1)}];
}

- (void)keyboardWillHideChangeFrame:(NSNotification *)notification {
//    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//
    self.isTouchTextView = NO;
    
    [self resetTextContentViewBtnStatus:nil];

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.viewController.view.mas_bottom).offset(-AreaBottomHeight);
    }];
    [self.viewController.view layoutIfNeeded];

    self.textView.inputView = nil;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:CMKeyBoardWillShowWillHideKey object:nil userInfo:@{CMKeyBoardShowHideUserInfoValueKey:@(0)}];
}


- (void)didTapChange:(UITapGestureRecognizer *)gestureRecognizer {

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (!self.isTouchTextView) {
            self.isTouchTextView = YES;
            [self resetTextContentViewBtnStatus:nil];
            [self rightAwayOpenKeyboardLayout];
            [self textViewBecomeResponder];
        }
        CGPoint point = [gestureRecognizer locationInView:self.textView];
        UITextPosition * position = [self.textView closestPositionToPoint:point];
        [self.textView setSelectedTextRange:[self.textView textRangeFromPosition:position toPosition:position]];
    }
}

/// 与ScrollView 冲突处理 这个方法返回YES，第一个和第二个互斥时，第二个会失效
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldBeRequiredToFailByGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"otherGestureRecognizer:%@ \n",NSStringFromClass([otherGestureRecognizer class]));
    if (gestureRecognizer == self.gesture && ![NSStringFromClass([otherGestureRecognizer class])isEqualToString:@"_UITextSelectionForceGesture"]) {
        return YES;
    }
    return NO;
}


#pragma mark --UITextViewDelegate--
- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing");
}
- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSLog(@"textViewDidChangeSelection");
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) { //判断输入的字是否是回车，即按下return
        [self sendMsg];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat editHeight = ceilf([textView sizeThatFits:textView.frame.size].height);
    if (editHeight < self.minTextViewH) {
        editHeight = self.minTextViewH;
    }
    if(editHeight > self.maxTextViewH)  {
        editHeight = self.maxTextViewH;
    }
    if (editHeight == self.currentTextViewH) {
        return;
    }
    self.currentTextViewH = editHeight;
    
    self.textViewHeightLayout.constant = editHeight;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        [self.textView scrollRangeToVisible:NSMakeRange(textView.text.length, 0)];
        [[NSNotificationCenter defaultCenter]postNotificationName:CMKeyBoardWillShowWillHideKey object:nil userInfo:@{CMKeyBoardShowHideUserInfoValueKey:@(1)}];
    }];
}


#pragma mark - RecordKitDelegate
/**
 *  完成录音的回调
 */
- (void)recordKit:(YWRecordKit *)aRecordKit didEndRecordWithData:(NSData *)aData duration:(NSTimeInterval)aDuration {
    if (self.postAudioMessageBlock) {
        self.postAudioMessageBlock(aData, aDuration);
    }
}

/**
 *  录音即将开始
 */
- (void)recordKitWillStartRecord:(YWRecordKit *)aRecordKit {
    
}

/**
 *  录音被取消
 */
- (void)recordKitDidCancel:(YWRecordKit *)aRecordKit {
    
}

/**
 *  音波强度
 */
- (void)recordKit:(YWRecordKit *)aRecordKit voicePowerPercentDidUpdate:(CGFloat)aCurrentPercent {

}

/// 重置TextContentView按钮状态
- (void)resetTextContentViewBtnStatus:(UIButton *)sender {
    if (sender) {
        /// 点击插件btn 恢复textView变成未点击状态
        self.isTouchTextView = NO;
        if (![sender isEqual:self.voiceBtn]) {
            self.voiceBtn.selected = NO;
            self.recordKit.recordView.hidden = YES;
            self.textView.hidden = NO;
        }
        if (![sender isEqual:self.emojiBtn]) {
            self.emojiBtn.selected = NO;
        }
        if (![sender isEqual:self.moreBtn]) {
            self.moreBtn.selected = NO;
        }
    }
    else {
        self.voiceBtn.selected = NO;
        self.recordKit.recordView.hidden = YES;
        self.textView.hidden = NO;
        self.emojiBtn.selected = NO;
        self.moreBtn.selected = NO;
    }
}

- (IBAction)emojiButtonClick:(UIButton *)sender {
    BOOL sel = !sender.selected;
    /// 重置一些UI
    [self resetTextContentViewBtnStatus:sender];

    /// 设置状态
    sender.selected = sel;
    
    if (sel) { /// 选中状态
        /// 立即更新约束
        [self rightAwayOpenEmojiLayout];
        
        [self textViewBecomeResponderForEmojiViewIndex:0];
    }
    else {/// 未选中状态 文本键盘弹起
        [self rightAwayOpenKeyboardLayout];
        
        [self textViewBecomeResponder];
    }
    
}

- (IBAction)moreButtonClick:(UIButton *)sender {
    BOOL sel = !sender.selected;
    /// 重置一些UI状态
    [self resetTextContentViewBtnStatus:sender];

    /// 设置状态
    sender.selected = sel;

    /// 选中状态
    if (sel) {
        [self rightAwayOpenEmojiLayout];
        
        [self textViewBecomeResponderForEmojiViewIndex:1];
    }
    else {/// 未选中状态 文本键盘降下
        [self textViewResignResponder];
    }
}

- (IBAction)voiceButtonClick:(UIButton *)sender {
    BOOL sel = !sender.selected;
    /// 重置一些UI状态
    [self resetTextContentViewBtnStatus:sender];
    /// 设置状态
    sender.selected = sel;

    /// 选中状态
    if (sender.selected) {
        if (self.isTextViewFirstResponse) {
            [self textViewResignResponder];
        }
        sender.selected = YES;
        self.lastAttributedString = self.textView.attributedText;
        self.textView.text = @"";
    }
    else {/// 未选中状态文本键盘弹起
        [self textViewBecomeResponder];
        self.textView.attributedText = self.lastAttributedString;
    }
    self.recordKit.recordView.hidden = !sel;
    self.textView.hidden = sel;
    [self textViewDidChange:self.textView];
}

- (void)rightAwayOpenEmojiLayout {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-EMOJI_SCROLL_HEIGHT);
    }];
    [self.viewController.view layoutIfNeeded];
}
/// 立即更新约束
- (void)rightAwayOpenKeyboardLayout {
    if (self.keyboardHeight > 0) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-_keyboardHeight);
        }];
        [self.viewController.view layoutIfNeeded];
    }
}

- (void)textViewBecomeResponderForEmojiViewIndex:(NSInteger)selectedIndex {
    self.emojiView.selectIndex = selectedIndex;

    self.textView.inputView = self.emojiView;
    
    [self.textView reloadInputViews];
    [self.textView becomeFirstResponder];
}

- (void)textViewBecomeResponder {
    self.textView.inputView = nil;
    [self.textView reloadInputViews];
    [self.textView becomeFirstResponder];
}

- (void)textViewResignResponder {
    self.textView.inputView = nil;
    [self.textView resignFirstResponder];
}

- (NSString *)msgText {
    NSMutableString * fullText = [NSMutableString string];
    [self.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.textView.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        // 如果是图片表情
        CMTextAttachment * attch = attrs[@"NSAttachment"];
        if (attch) { // 图片
            [fullText appendString:attch.imageName];
        } else { // emoji、普通文本
            // 获得这个范围内的文字
            NSAttributedString * str = [self.textView.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    return fullText;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CMMsgAllEmojiView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[CMMsgAllEmojiView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, EMOJI_SCROLL_HEIGHT)];
    }
    return _emojiView;
}

- (YWRecordKit *)recordKit {
    if (!_recordKit) {
        [self layoutIfNeeded];
        _recordKit = [[YWRecordKit alloc] initWithRecordViewFrame:self.textView.frame
                                                         delegate:self
                                                         andImkit:nil];
        _recordKit.recordView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _recordKit.recordView.translatesAutoresizingMaskIntoConstraints = YES;
        _recordKit.recordView.hidden = YES;
        _recordKit.recordView.backgroundColor = [UIColor blueColor];
    }
    return _recordKit;
}
@end
