//
//  HJSign.m
//  d
//
//  Created by lyt on 2018/11/9.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//
#define kRSA_KEY_SIZE 1024

#import "HJSecurity.h"
#import <Security/Security.h>

@implementation HJSecurity
+ (void)initialize{
    
}
#pragma mark - 获取p12文件中的信息

+ (SecIdentityRef)getIdentityFromP12Data:(NSData*)p12Data password:(NSString*)password {
    
    NSDictionary * options = @{(__bridge id)kSecImportExportPassphrase:password};
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    OSStatus securityError = SecPKCS12Import(CFBridgingRetain(p12Data), CFBridgingRetain(options), &items);
    NSArray* itemArr = CFBridgingRelease(items);
    
    SecIdentityRef identityRef = NULL;
    
    if (securityError == noErr && itemArr.count > 0) {
        NSDictionary* identityDic = itemArr.firstObject;
        
        identityRef = (SecIdentityRef)CFBridgingRetain(identityDic[(__bridge id)kSecImportItemIdentity]);
        
    }
    
    
    return identityRef;
    
}
+ (SecKeyRef)getPrivateKeyFromP12Data:(NSData*)p12Data password:(NSString*)password {
    
    SecKeyRef privateKeyRef = NULL;
    SecIdentityRef identityRef = [self getIdentityFromP12Data:p12Data password:password];
    OSStatus securityError = SecIdentityCopyPrivateKey(identityRef, &privateKeyRef);
    CFRelease(identityRef);
    if (securityError != noErr) {
        privateKeyRef = NULL;
    }
    
    return privateKeyRef;
    
}
+ (SecCertificateRef)getCertificateFromP12Data:(NSData*)p12Data password:(NSString*)password {
    
    SecCertificateRef certificateRef = NULL;
    
    SecIdentityRef identityRef = [self getIdentityFromP12Data:p12Data password:password];
    
    OSStatus securityError = SecIdentityCopyCertificate(identityRef, &certificateRef);
    CFRelease(identityRef);
    
    if (securityError != noErr) {
        certificateRef = NULL;
    }
    
    
    return certificateRef;
    
}
+ (SecKeyRef) getPublicKeyFromCertificate:(SecCertificateRef)certificate  {
    
    
    //    不需要验证信任
    //    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    //
    //    SecTrustRef myTrust;
    //
    //    OSStatus status = SecTrustCreateWithCertificates(certificate,myPolicy,&myTrust);
    //
    //    SecTrustResultType trustResult;
    //
    //    if (status == noErr) {
    //
    //        status = SecTrustEvaluate(myTrust, &trustResult);
    //
    //    }
    SecKeyRef publicKeyRef = NULL;
    OSStatus status = SecCertificateCopyPublicKey(certificate, &publicKeyRef);
    CFRelease(certificate);
    if (status != noErr) {
        publicKeyRef = NULL;
    }
    
    return publicKeyRef;
}
+ (SecKeyRef) getPublicKeyFromP12Data:(NSData*)p12Data password:(NSString*)password {
    
    SecCertificateRef certificate = [self getCertificateFromP12Data:p12Data password:password];
    return  [self getPublicKeyFromCertificate:certificate];
    
}
+ (SecKeyRef) getPublicKeyFromFile:(NSString*)path {
    
    NSString* certificateStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    certificateStr = [certificateStr stringByReplacingOccurrencesOfString:@"-----BEGIN CERTIFICATE-----" withString:@""];
    certificateStr = [certificateStr stringByReplacingOccurrencesOfString:@"-----END CERTIFICATE-----" withString:@""];
    
    NSData *certificateData = [[NSData alloc] initWithBase64EncodedData:[certificateStr dataUsingEncoding:NSUTF8StringEncoding] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    SecCertificateRef certificate = SecCertificateCreateWithData(kCFAllocatorDefault, CFBridgingRetain(certificateData));
    return [self getPublicKeyFromCertificate:certificate];
    
}

#pragma mark - 签名相关

+ (NSString*)signSHA256PlainData:(NSData *)plainData privateKeyData:(NSData *)p12Data password:(NSString *)password{
    
    SecKeyRef ref = [self getPrivateKeyFromP12Data:p12Data password:password];
    return [self signPlainData:plainData privateKeyRef:ref padding:kSecPaddingPKCS1SHA256];
}

+ (NSString*)signPlainData:(NSData *)plainData privateKeyData:(NSData *)p12Data password:(NSString *)password padding:(SecPadding)padding{
    
    SecKeyRef ref = [self getPrivateKeyFromP12Data:p12Data password:password];
    return [self signPlainData:plainData privateKeyRef:ref padding:padding];
}

+ (NSString*)signPlainData:(NSData *)plainData privateKeyRef:(SecKeyRef)privateKeyRef padding:(SecPadding)padding{
    
    //私钥签名
    size_t siglen = SecKeyGetBlockSize(privateKeyRef);
    uint8_t *sig = malloc(siglen);
    bzero(sig, siglen);
    
    OSStatus ret = SecKeyRawSign(privateKeyRef, padding, plainData.bytes, plainData.length, sig, &siglen);
    NSString *string = nil;
    if (ret==errSecSuccess) {
        string = [[NSData dataWithBytes:sig length:siglen] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    free(sig);
    
    return string;
}
@end
