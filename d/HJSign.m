//
//  HJSign.m
//  d
//
//  Created by lyt on 2018/11/9.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//

#import "HJSign.h"
#import <Security/Security.h>

@implementation HJSign
+ (SecKeyRef)getPrivateKeyRefrenceFromData:(NSData*)p12Data password:(NSString*)password {
    p12Data = [[NSData alloc] initWithBase64EncodedData:p12Data options:NSDataBase64DecodingIgnoreUnknownCharacters];

    SecKeyRef privateKeyRef = NULL;
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    [options setObject: password forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import(CFBridgingRetain( p12Data), NULL, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    if(items){
        CFRelease(items);
    }
    
    return privateKeyRef;
    
    
}
+ (SecKeyRef) getPublicKey{// 从公钥证书文件中获取到公钥的SecKeyRef指针
    
    
    SecKeyRef _public_key = NULL ;
    if(_public_key == NULL){
        
        //由于后台给我的字符串时base过的所以要转回来，没有的请忽视
        
        NSData *certificateData = [NSData dataWithContentsOfFile:@"/Users/gd/Desktop/work/d/d/coinapi.crt"];
        certificateData = [[NSData alloc] initWithBase64EncodedData:certificateData options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        
        SecCertificateRef myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, CFBridgingRetain(certificateData));
        
        SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
        
        SecTrustRef myTrust;
        
        OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
        
        SecTrustResultType trustResult;
        
        if (status == noErr) {
            
            status = SecTrustEvaluate(myTrust, &trustResult);
            
        }
        
        _public_key = SecTrustCopyPublicKey(myTrust);
        
        CFRelease(myCertificate);
        
        CFRelease(myPolicy);
        
        CFRelease(myTrust);
        
    }
    
    return _public_key;
    
}

+ (void)sign{
    
    
    
    
    //私钥签名，公钥验证签名
    //    size_t siglen = SecKeyGetBlockSize(privateKeyRef);
    //    uint8_t *sig = malloc(siglen);
    //    bzero(sig, siglen);
    
    //    OSStatus SecKeyRawSign(
    //                           SecKeyRef           key,
    //                           SecPadding          padding,
    //                           const uint8_t       *dataToSign,
    //                           size_t              dataToSignLen,
    //                           uint8_t             *sig,
    //                           size_t              *sigLen)
    
    SecKeyRef publicKeyRef  = [self getPublicKey];
    
    NSData *privateKeyData = [NSData dataWithContentsOfFile:@"/Users/gd/Desktop/work/d/d/coinapi.key"];
    
    SecKeyRef privateKeyRef = [self getPrivateKeyRefrenceFromData:privateKeyData password:@""];//私钥
    
    
    //    NSString *tpath = [[NSBundle mainBundle] pathForResource:@"src.txt" ofType:nil];
    //    NSData *ttDt = [NSData dataWithContentsOfFile:tpath];
    //使用了下面封装的hash接口
    //    NSData *sha1dg = [ttDt hashDataWith:CCDIGEST_SHA1];
    NSData *sha1dg = nil;
    
    OSStatus ret;
    
    
    //私钥签名，公钥验证签名
    size_t siglen = SecKeyGetBlockSize(privateKeyRef);
    uint8_t *sig = malloc(siglen);
    bzero(sig, siglen);
    ret = SecKeyRawSign(privateKeyRef, kSecPaddingPKCS1SHA256, sha1dg.bytes, sha1dg.length, sig, &siglen);
    NSAssert(ret==errSecSuccess, @"签名失败");
}
@end
