//
//  CMDefaultEmojiPresenter.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/8.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMDefaultEmojiPresenter.h"

@implementation CMDefaultEmojiPresenter

+ (instancetype)instanceWithEmojiPlistName:(NSString *)name {
    CMDefaultEmojiPresenter * obj = [[CMDefaultEmojiPresenter alloc]init];
    obj.dataArray = [NSMutableArray new];
    if ([name isEqualToString:@"EmoticonInfo"]) {
        [obj initWithEmoticonInfo:name];
    }
    else {
        [obj initWithNameDefault:name];
    }
    return obj;
}

+ (instancetype)instanceWithSystemNewEmojiPlistName:(NSString *)name {
    CMDefaultEmojiPresenter * obj = [[CMDefaultEmojiPresenter alloc]init];
    obj.dataArray = [NSMutableArray new];
    [obj initWithNewName:name];
    return obj;
}

- (void)initWithNameDefault:(NSString *)name {
    /// 根据plist的格式 修改相关的逻辑
    NSString * path = [NSBundle.mainBundle pathForResource:name ofType:@"plist"];
    NSAssert(path,@"找不到表情图片对应的plist文件");
    NSArray * array = [[NSArray alloc] initWithContentsOfFile:path];
    int page = -1;
    CMEmojiPageCellPresenter * presenter = nil;
    for (int i = 0;i < array.count;i++) {
        if (i%CMPageViewMaxEmojiCount == 0) {
            ++page;
            CMEmojiPageCellPresenter * p = [CMEmojiPageCellPresenter instanceWithPageNumber:page];
            [self.dataArray addObject:p];
            presenter = p;
        }
        EmojiModel * model = [EmojiModel initModelWithImageId:array[i][@"emoji_id"] desc:array[i][@"desc"]];
        [presenter.dataArray addObject:model];
    }
    
    [self.dataArray enumerateObjectsUsingBlock:^(CMEmojiPageCellPresenter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EmojiModel * model = [EmojiModel initModelWithImageId:CarMsgEmojiDeleteKey desc:@"talk_ico_delete_nor"];
        NSInteger objCount = obj.dataArray.count;
        if (objCount < CMPageViewMaxEmojiCount) {
            NSInteger number = CMPageViewMaxEmojiCount - objCount;
            for (int i = 0; i < number; i++) {
                /// 用来填充删除图标和表情图标中间的空白区域
                EmojiModel * model = [EmojiModel initModelWithImageId:@"" desc:@""];
                [obj.dataArray addObject:model];
            }
        }
        [obj.dataArray addObject:model];
    }];
}

- (void)initWithEmoticonInfo:(NSString *)name {
    /// 根据plist的格式 修改相关的逻辑
    NSString * path = [NSBundle.mainBundle pathForResource:name ofType:@"plist"];
    NSAssert(path,@"找不到表情图片对应的plist文件");
    NSDictionary * dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray * keyArray = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return NSOrderedAscending;
        }
        else {
            return NSOrderedDescending;
        }
    }];
    int page = -1;
    CMEmojiPageCellPresenter * presenter = nil;
    for (int i = 0;i < keyArray.count;i++) {
        if (i%CMPageViewMaxEmojiCount == 0) {
            ++page;
            CMEmojiPageCellPresenter * p = [CMEmojiPageCellPresenter instanceWithPageNumber:page];
            [self.dataArray addObject:p];
            presenter = p;
        }
        NSString * imageId = keyArray[i];/// 001
        NSArray * emoji = dic[imageId];
        EmojiModel * model = [EmojiModel initEmoticonInfoModelWithImageId:imageId desc:emoji.firstObject];
        [presenter.dataArray addObject:model];
    }
    [self.dataArray enumerateObjectsUsingBlock:^(CMEmojiPageCellPresenter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EmojiModel * model = [EmojiModel initModelWithImageId:CarMsgEmojiDeleteKey desc:@"talk_ico_delete_nor"];
        NSInteger objCount = obj.dataArray.count;
        if (objCount < CMPageViewMaxEmojiCount) {
            NSInteger number = CMPageViewMaxEmojiCount - objCount;
            for (int i = 0; i < number; i++) {
                /// 用来填充删除图标和表情图标中间的空白区域
                EmojiModel * model = [EmojiModel initEmoticonInfoModelWithImageId:@"" desc:@""];
                [obj.dataArray addObject:model];
            }
        }
        [obj.dataArray addObject:model];
    }];
    
}

- (void)initWithNewName:(NSString *)name {
    /// 根据plist的格式 修改相关的逻辑
    NSString * path = [NSBundle.mainBundle pathForResource:name ofType:@"plist"];
    NSAssert(path,@"找不到表情图片对应的plist文件");
    NSArray * array = [[NSArray alloc]initWithContentsOfFile:path];
    int page = -1;
    CMEmojiPageCellPresenter * presenter = nil;
    for (int i = 0;i < array.count;i++) {
        if (i%CMPageViewMaxEmojiCount == 0) {
            ++page;
            CMEmojiPageCellPresenter * p = [CMEmojiPageCellPresenter instanceWithPageNumber:page];
            [self.dataArray addObject:p];
            presenter = p;
        }
        EmojiModel * model = [EmojiModel initModelWithNewCode:array[i][@"code"] type:array[i][@"type"]];
        [presenter.dataArray addObject:model];
    }
    
    [self.dataArray enumerateObjectsUsingBlock:^(CMEmojiPageCellPresenter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EmojiModel * model = [EmojiModel initModelWithImageId:CarMsgEmojiDeleteKey desc:@"talk_ico_delete_nor"];
        NSInteger objCount = obj.dataArray.count;
        if (objCount < CMPageViewMaxEmojiCount) {
            NSInteger number = CMPageViewMaxEmojiCount - objCount;
            for (int i = 0; i < number; i++) {
                /// 用来填充删除图标和表情图标中间的空白区域
                EmojiModel * model = [EmojiModel initModelWithImageId:@"" desc:@""];
                [obj.dataArray addObject:model];
            }
        }
        [obj.dataArray addObject:model];
    }];
}

+ (NSMutableAttributedString *)processCommentContentWithEmoticonInfo:(NSString *)text {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]init];
    if (!text) {
        return attributedString;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];//调整行间距
    [paragraphStyle setParagraphSpacing:4];//调整行间距
    NSDictionary *attri = [NSDictionary dictionaryWithObjects:@[CHAT_FONT,paragraphStyle] forKeys:@[NSFontAttributeName,NSParagraphStyleAttributeName]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:attri]];
    //创建匹配对象
    NSError * error;
    NSRegularExpression * regularExpression = [NSRegularExpression regularExpressionWithPattern:emojiCheckStr options:NSRegularExpressionCaseInsensitive error:&error];
    //判断
    if (!regularExpression) {
        NSLog(@"正则创建失败 error = %@",[error localizedDescription]);
        return attributedString;
    }
    else {
        NSArray * resultArray = [regularExpression matchesInString:attributedString.string options:NSMatchingReportCompletion range:NSMakeRange(0, attributedString.string.length)];
        NSString * path = [[NSBundle mainBundle] pathForResource:EmoticonInfoPlistName ofType:@"plist"];
        id obj;
        if ([EmoticonInfoPlistName isEqualToString:EmojiPlistName]) {
            obj = [[NSArray alloc] initWithContentsOfFile:path];
        }
        else if ([EmoticonInfoPlistName isEqualToString:EmoticonPlistName]) {
            obj = [[NSDictionary alloc] initWithContentsOfFile:path];
        }
        else {
            /// 暂未做处理;
            attributedString = [[NSMutableAttributedString alloc]initWithString:@"暂未做处理"];
            return attributedString;
        }
        //开始遍历 逆序遍历
        for (NSInteger i = resultArray.count - 1; i >= 0; i --) {
            //获取检查结果，里面有range
            NSTextCheckingResult * result = resultArray[i];
            //根据range获取字符串
            NSString * rangeString = [attributedString.string substringWithRange:result.range];
            NSString * imageName =  [self imageNameWithKey:rangeString obj:obj];
            if (imageName) {
                //获取图片
                UIImage * image = [UIImage imageNamed:imageName];//这是个自定义的方法
                if (image != nil) {
                    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
                    imageView.width = EMOJI_SIZE;
                    imageView.height = EMOJI_SIZE;
                    NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:CHAT_FONT alignment:YYTextVerticalAlignmentCenter];
                    //开始替换
                    [attributedString replaceCharactersInRange:result.range withAttributedString:attachText];
                }
            }
        }
    }
    return attributedString;
}

+ (NSString *)imageNameWithKey:(NSString *)key obj:(id)obj {
    __block NSString * val = @"";
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray * arr = (NSArray *)obj;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary * dic = obj;
            NSString * value = dic[@"desc"];
            if ([value isEqualToString:key]) {
                val = value;
                *stop = YES;
            }
        }];
    }
    else if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dic = (NSDictionary *)obj;
        [dic.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * value = obj;
            NSArray * array = dic[value];
            if ([array.firstObject isEqualToString:key]) {
                val = value;
                *stop = YES;
            }
        }];
    }
    return val;
}
@end
