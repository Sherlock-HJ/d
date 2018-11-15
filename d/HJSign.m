//
//  HJSign.m
//  d
//
//  Created by lyt on 2018/11/9.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//
#define kRSA_KEY_SIZE 1024

#import "HJSign.h"
#import <Security/Security.h>
#import <Security/SecBase.h>
#include <Security/SecKey.h>

@implementation HJSign
+ (SecKeyRef)getPrivateKeyRefrenceFromData:(NSData*)p12Data password:(NSString*)password {
    
    SecKeyRef privateKeyRef = NULL;
    NSDictionary * options = @{(__bridge id)kSecImportExportPassphrase:password};
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import(CFBridgingRetain( p12Data), CFBridgingRetain( options), &items);
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
    
    SecKeyRef public_key = SecTrustCopyPublicKey(myTrust);
    
    CFRelease(myCertificate);
    
    CFRelease(myPolicy);
    
    CFRelease(myTrust);
    
    
    
    return public_key;
    
}

+ (NSString*)signSHA256PlainData:(NSData *)plainData privateKeyData:(NSData *)privateKeyData password:(NSString *)password{
    
    SecKeyRef ref = [self getPrivateKeyRefrenceFromData:privateKeyData password:password];
    return [self signPlainData:plainData privateKeyRef:ref padding:kSecPaddingPKCS1SHA256];
}

+ (NSString*)signPlainData:(NSData *)plainData privateKeyData:(NSData *)privateKeyData password:(NSString *)password padding:(SecPadding)padding{

    SecKeyRef ref = [self getPrivateKeyRefrenceFromData:privateKeyData password:password];
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
        string = [[NSData dataWithBytes:sig length:siglen] base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
    }
    free(sig);

    return string;
}
@end
