//
//  PlugInProtocol.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/13.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CMInputViewPluginType) {
    CMInputViewPluginPhoto,
    CMInputViewPluginCamera,
    CMInputViewPluginLocation,
    
};

@protocol PlugInProtocol <NSObject>
@property (assign, nonatomic) CMInputViewPluginType plugInType;
@end

@interface PlugInModel : NSObject <PlugInProtocol>
@property (copy, nonatomic) NSString * imageName;
@property (copy, nonatomic) NSString * title;
@end
