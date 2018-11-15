//
//  HJSign.h
//  d
//
//  Created by lyt on 2018/11/9.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJSign : NSObject
/** SHA256WithRSA 加签
 *@param plainData 要加签的data
 *@param privateKeyData p12文件的data
 *@param password p12文件密码
 * 成功返回base64加密的字符串 ， 失败返回空字符串
 */
+ (NSString*)signSHA256PlainData:(NSData*)plainData privateKeyData:(NSData*)privateKeyData  password:(NSString*)password;
/**  加签
 *@param plainData 要加签的data
 *@param privateKeyData p12文件的data
 *@param password p12文件密码
 *@param padding 填充方式
 * 成功返回base64加密的字符串 ， 失败返回空字符串
 */
+ (NSString*)signPlainData:(NSData*)plainData privateKeyData:(NSData*)privateKeyData  password:(NSString*)password padding:(SecPadding)padding;
/** 加签
 *@param plainData 要加签的data
 *@param privateKeyRef 私钥
 *@param padding 填充方式
 * 成功返回base64加密的字符串 ， 失败返回空字符串
 */
+ (NSString*)signPlainData:(NSData*)plainData privateKeyRef:(SecKeyRef)privateKeyRef  padding:(SecPadding)padding;
@end

NS_ASSUME_NONNULL_END
