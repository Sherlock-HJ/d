//
//  MXPrivateApiObject.h
//  d
//
//  Created by lyt on 2018/11/20.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//

#import "MXApiObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrivateOrder : Order
///收款人 如果appid=muxin则必传
@property (nonatomic, strong) NSString* tousercode;
@end

NS_ASSUME_NONNULL_END
