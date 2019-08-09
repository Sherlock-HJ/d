//
//  MXApiObject.h
//  d
//
//  Created by lyt on 2018/11/19.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 基类
@interface MXObject : NSObject

@end

#pragma mark - BaseReq
/*! @brief 该类为所有请求类的基类
 *
 */
@interface BaseReq : MXObject

///请求方法名  形如  **.**.**  的字符串
@property (nonatomic, strong) NSString* method;
///页码 1开始
@property (nonatomic, assign) int page;
///每页长度
@property (nonatomic, assign) int count;

+(instancetype)request;

@end



#pragma mark - BaseResp
/*! @brief 该类为所有响应类的基类
 *
 */
@interface BaseResp : MXObject

+(instancetype)response;

@end

@interface ErrorResp : BaseResp
/** 错误码 */
@property (nonatomic, assign) int error_code;
/** 错误提示字符串 */
@property (nonatomic, strong) NSString *error_info;

@end

#pragma mark - Specific

/// 创建账户
@interface AccountCreateReq : BaseReq

@property (nonatomic, strong) NSString* pwd;
@property (nonatomic, strong) NSString* usercode;

@end
/// 创建账户
@interface AccountCreateResp : BaseResp

@end

/// 账户 - 被继承的
@interface AccountReq : BaseReq

///MRY系统身份id
@property (nonatomic, strong) NSString* acctid;

@end
/// 账户 - 被继承的
@interface AccountResp : BaseResp

///MRY系统身份id
@property (strong, nonatomic) NSString *acctCode;

@end

/// 账户解冻
@interface ThawReq : AccountReq

@property (nonatomic, strong) NSString* money;

@end
/// 账户解冻
@interface ThawResp : BaseResp


@end

/// 账户冻结
@interface FreezeReq : AccountReq

@property (nonatomic, strong) NSString* money;

@end
/// 账户冻结
@interface FreezeResp : AccountResp

@property (nonatomic, strong) NSString* money;

@end
/// 查询交易记录
@interface RecordsReq : AccountReq

@end

/// 查询交易记录
@interface RecordsResp : BaseResp

@end


/// 查询余额
@interface BalanceReq : AccountReq

@end
/// 查询余额
@interface BalanceResp : AccountResp
@property (strong, nonatomic) NSString *acctMoney;
@property (strong, nonatomic) NSString *acctPsw;
@property (strong, nonatomic) NSString *acctState;
@property (strong, nonatomic) NSString *bindId;
@property (strong, nonatomic) NSString *coinCode;
@property (strong, nonatomic) NSString *freezeMoney;

@end

/// 创建订单
@interface OrderCreateReq : BaseReq
///
@property (nonatomic, strong) NSString* uid;
///
@property (nonatomic, strong) NSString* usercode;
/// urlencode之后的query字符串 详情见OrderCreateReq
@property (nonatomic, strong) NSString* order_body;

@end

/// 创建订单
@interface OrderCreateResp : BaseResp
///流水号
@property (nonatomic, strong) NSString* tradnum;

@end

/// 订单
@interface Order : MXObject
///商户id
@property (nonatomic, strong) NSString* appid;
///商品信息
@property (nonatomic, strong) NSString* body;
///商户订单号
@property (nonatomic, strong) NSString* out_trade_no;
///总价
@property (nonatomic, strong) NSString* total_fee;
///交易类型
@property (nonatomic, strong) NSString* trade_type;
///备注 (可不填)
@property (nonatomic, strong) NSString* note;
///接口回调通知的url 成功需要返回success
@property (nonatomic, strong) NSString* notify_url;
/// 随机字符串 (可不填)
@property (nonatomic, strong) NSString* nonce_str;
/// 时间戳 (可不填)
@property (nonatomic, strong) NSString* timestamp;
/// 签名字符串 (可不填)
@property (nonatomic, strong) NSString* sign;
@end



/// 订单支付
@interface PayReq : BaseReq
///流水号
@property (nonatomic, strong) NSString* tradnum;
///
@property (nonatomic, strong) NSString* pwd;

@end

/// 订单支付
@interface PayResp : BaseResp
///流水号
@property (nonatomic, strong) NSString* tradnum;
///商品信息
@property (nonatomic, strong) NSString* body;
///总价
@property (nonatomic, strong) NSString* total_fee;
///商户订单号
@property (nonatomic, strong) NSString* out_trade_no;
///交易类型
@property (nonatomic, strong) NSString* trade_type;
///备注 (可不填)
@property (nonatomic, strong) NSString* note;
@property (nonatomic, strong) NSString* ctime;

///接口回调通知的url 成功需要返回success
@property (nonatomic, strong) NSString* notify_url;
@property (nonatomic, strong) NSString* paystatus;
@property (nonatomic, strong) NSString* fromuid;
@property (nonatomic, strong) NSString* touid;
@property (nonatomic, strong) NSString* fromcard;
@property (nonatomic, strong) NSString* tocard;
@property (nonatomic, strong) NSString* fromusercode;
@property (nonatomic, strong) NSString* tousercode;

@end

NS_ASSUME_NONNULL_END
