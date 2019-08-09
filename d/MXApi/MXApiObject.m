//
//  MXApiObject.m
//  d
//
//  Created by lyt on 2018/11/19.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//

#import "MXApiObject.h"

@implementation MXObject

@end

#pragma mark - BaseReq

@implementation BaseReq
+ (instancetype)request{
    return [self request:nil];
}
+ (instancetype)request:(NSString*)method{
    BaseReq *obj = [[self alloc]init];
    obj.method = method;
    return obj;
}
@end



#pragma mark - BaseResp

@implementation BaseResp
+(instancetype)response{
    
    return [[self alloc]init];
}

@end

@implementation ErrorResp


@end
#pragma mark - Specific

/// 创建账户
@implementation AccountCreateReq
+ (instancetype)request{
    
    return [super request:@"coinos.Account.create"];
    
}
@end
@implementation AccountCreateResp

@end
/// 账户
@implementation AccountReq

@end
@implementation AccountResp


@end


/// 账户解冻
@implementation ThawReq

+ (instancetype)request{
    
    return [super request:@"coinos.Account.thaw"];
    
}
@end
@implementation ThawResp


@end

/// 账户冻结
@implementation FreezeReq
+ (instancetype)request{
    
    return [super request:@"coinos.Account.freeze"];
    
}

@end
@implementation FreezeResp


@end
/// 查询交易记录
@implementation RecordsReq
+ (instancetype)request{
    
    return [super request:@"coinos.Account.records"];
    
}
@end
/// 查询交易记录
@implementation RecordsResp

@end


/// 查询余额
@implementation BalanceReq
+ (instancetype)request{
    
    return [super request:@"coinos.Account.balance"];
    
}
@end
/// 查询余额
@implementation BalanceResp

@end

/// 创建订单
@implementation OrderCreateReq
+ (instancetype)request{
    
    return [super request:@"coinos.Order.create"];
    
}
@end

@implementation OrderCreateResp

@end

/// 订单
@implementation Order

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.note = @"";
        self.nonce_str = [NSUUID UUID].UUIDString;
        self.timestamp = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
        /// 放在最后
        self.sign = [self sign];

    }
    return self;
}
@end
/// 订单支付
@implementation PayReq
+ (instancetype)request{
    
    return [super request:@"coinos.Order.pay"];
    
}
@end

@implementation PayResp

@end



