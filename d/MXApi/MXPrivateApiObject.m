//
//  MXPrivateApiObject.m
//  d
//
//  Created by lyt on 2018/11/20.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//

#import "MXPrivateApiObject.h"

@implementation PrivateOrder
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.appid = @"muxin";
    }
    return self;
}
@end
