//
//  NSAttributedString+EmojiExtensionString.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/17.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "NSAttributedString+EmojiExtensionString.h"
#import "EmojiModel.h"

@implementation NSAttributedString (EmojiExtensionString)

//遍历替换图片得到普通字符
- (NSString *)getPlainString {
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(CMTextAttachment * value, NSRange range, BOOL *stop) {
                      if (value) {
                          NSString * str = [NSString stringWithFormat:@"%@",value.imageName];
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:str];
                          base += str.length - 1;
                      }
                  }];
    return plainString;
}

@end
