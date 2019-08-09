//
//  MXApi.h
//  d
//
//  Created by lyt on 2018/11/19.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//

#import "MXApiObject.h"

NS_ASSUME_NONNULL_BEGIN
@interface NSString (MXApi)
- (NSString *)urlencodeAll;
- (NSString *)urlencodeKeyValue;

@end
@interface NSDictionary (MXApi)

- (NSData*)HTTPBody;
- (NSString*)query;

@end

@interface MXObject (MXApi)
/// 获取对象的所有属性 以及属性值
- (NSDictionary *)toDictionary;
// 将字典转成当前对象
- (void)toObjectWithDictionary:(NSDictionary*)dictionary;

- (id)toResp;


/// 返回当前对象的签名字符串
- (NSString*)generateSign;

/// 返回当前对象的urlencode字符串
- (NSString*)urlencode;

@end

@interface MXApi : NSObject

/*! @brief 发送请求 不同请求发送不同的BaseReq 的子类 或包含BaseReq子类的数组 等待返回onResp
 *
 * @param req 具体的发送请求
 * @param success 不同的BaseResp子类 或包含BaseResp子类的数组 或者字符串
 * @param failure ErrorResp
 * @return 成功返回YES，失败返回NO。
 */
+ (BOOL)sendReq:(BaseReq *)req success:(void (^)(id _Nullable response))success failure:(void (^)(ErrorResp * _Nullable response))failure;

@end

NS_ASSUME_NONNULL_END
