//
//  HJNet.m
//  d
//
//  Created by lyt on 2018/11/9.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//

#import "HJNet.h"
#import "HJSecurity.h"

@interface NSDictionary (HJNet)
- (NSData*)HTTPBody;
@end
@implementation NSDictionary (HJNet)

- (NSData*)HTTPBody{
    
    NSMutableString *mutStr = [NSMutableString string];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mutStr appendFormat:@"%@=%@&",key,obj];
    }];
    NSString *str = [mutStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}


@end


@interface HJNet ()<NSURLSessionDataDelegate>
//@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) id<HJNetDelegate> delegate;

@end

@implementation HJNet

+ (NSURLSessionTask*)POST:(NSString*)urlStr parameters:(NSDictionary*)params delegate:(nonnull id<HJNetDelegate>)delegate{
    HJNet *net = [[HJNet alloc]init];
    net.delegate = delegate;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:net delegateQueue:[NSOperationQueue mainQueue]];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc]initWithURL:url];
    mutableRequest.HTTPMethod = @"POST";
    mutableRequest.HTTPBody = params.HTTPBody ;
    [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
    }
    NSURLSessionTask * task = [session dataTaskWithRequest:mutableRequest];
    [task resume];
    
    return task;
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    //    NSLog(@"didReceiveChallenge");
    //    NSLog(@"%@", challenge.protectionSpace.authenticationMethod);
    
    // 1.从服务器返回的受保护空间中拿到证书的类型
    // 2.判断服务器返回的证书是否是服务器信任的
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSLog(@"是服务器信任的证书");
        NSLog(@"%@",challenge.protectionSpace.serverTrust);
        // 3.根据服务器返回的受保护空间创建一个证书
        //         void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *)
        //         代理方法的completionHandler block接收两个参数:
        //         第一个参数: 代表如何处理证书
        //         第二个参数: 代表需要处理哪个证书
        //创建证书
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        // 4.安装证书
        completionHandler(NSURLSessionAuthChallengeUseCredential , credential);
    }else if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate]){
        //客户端证书认证
        
        NSData *p12Data = [NSData dataWithContentsOfFile:@"/Users/gd/Desktop/work/d/d/coinapi.p12"];
        SecIdentityRef identity = [HJSecurity getIdentityFromP12Data:p12Data password:@"1111"];
        
        SecCertificateRef certificate = [HJSecurity getCertificateFromP12Data:p12Data password:@"1111"];
        
        NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identity certificates:@[(__bridge id)certificate] persistence:NSURLCredentialPersistencePermanent];
        ////        // 4.发送证书
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
    
}

#pragma mark - NSURLSessionTaskDelegate
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
//    
//}
#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    
    completionHandler(NSURLSessionResponseAllow);
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask{
    
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask{
    
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (res) {
        [self.delegate responseSuccess:res];
        
    }else{
        [self.delegate responseSuccess:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
        
    }
    
    
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler{
    
}


@end
