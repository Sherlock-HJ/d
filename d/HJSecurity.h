//
//  HJSign.h
//  d
//
//  Created by lyt on 2018/11/9.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJSecurity : NSObject

#pragma mark - 获取p12文件中的信息


+ (SecKeyRef) getPublicKeyFromFile:(NSString*)path;

/** 获取p12文件Identity
 *@param p12Data p12文件的data
 *@param password p12文件密码
 * 成功返回SecIdentityRef ， 失败返回NULL
 */
+ (SecIdentityRef)getIdentityFromP12Data:(NSData*)p12Data password:(NSString*)password;
/** 获取私钥
 *@param p12Data p12文件的data
 *@param password p12文件密码
 * 成功返回SecKeyRef ， 失败返回NULL
 */
+ (SecKeyRef)getPrivateKeyFromP12Data:(NSData*)p12Data password:(NSString*)password ;
/** 获取证书
 *@param p12Data p12文件的data
 *@param password p12文件密码
 * 成功返回SecCertificateRef ， 失败返回NULL
 */
+ (SecCertificateRef)getCertificateFromP12Data:(NSData*)p12Data password:(NSString*)password ;


#pragma mark - 签名相关
/** SHA256WithRSA 加签
 *@param plainData 要加签的data
 *@param p12Data p12文件的data
 *@param password p12文件密码
 * 成功返回base64加密的字符串 ， 失败返回空字符串
 */
+ (NSString*)signSHA256PlainData:(NSData*)plainData privateKeyData:(NSData*)p12Data  password:(NSString*)password;
/**  加签
 *@param plainData 要加签的data
 *@param p12Data p12文件的data
 *@param password p12文件密码
 *@param padding 填充方式
 * 成功返回base64加密的字符串 ， 失败返回空字符串
 */
+ (NSString*)signPlainData:(NSData*)plainData privateKeyData:(NSData*)p12Data  password:(NSString*)password padding:(SecPadding)padding;
/** 加签
 *@param plainData 要加签的data
 *@param privateKeyRef 私钥
 *@param padding 填充方式
 * 成功返回base64加密的字符串 ， 失败返回空字符串
 */
+ (NSString*)signPlainData:(NSData*)plainData privateKeyRef:(SecKeyRef)privateKeyRef  padding:(SecPadding)padding;
@end

NS_ASSUME_NONNULL_END
