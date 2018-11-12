//
//  NetTool.m
//  d
//
//  Created by lyt on 2018/11/9.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//

#import "NetTool.h"

@interface NSDictionary (NetTool)
- (NSData*)HTTPBody;
@end
@implementation NSDictionary (NetTool)

- (NSData*)HTTPBody{
    
    NSMutableString *mutStr = [NSMutableString string];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mutStr appendFormat:@"%@=%@&",key,obj ];
    }];
    NSString *str = [mutStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}


@end


@interface NetTool ()<NSURLSessionDataDelegate>

@end

@implementation NetTool

+(instancetype)share{
    static NetTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[NetTool alloc]init];
    });
    return tool;
}

+ (NSURLSession*)session{
   return  [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:[NetTool share] delegateQueue:[NSOperationQueue mainQueue]];
}
+ (NSURLSessionTask*)POST:(NSString*)urlStr parameters:(NSDictionary*)params{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc]initWithURL:url];
    mutableRequest.HTTPMethod = @"POST";
    mutableRequest.HTTPBody = params.HTTPBody ;
    [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
    }
    NSURLSessionTask * task = [self.session dataTaskWithRequest:mutableRequest];
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
    }else if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate]){
        
        
//        NSURLCredential *credential =  [NSURLCredential credentialWithIdentity:<#(nonnull SecIdentityRef)#> certificates:<#(nullable NSArray *)#> persistence:<#(NSURLCredentialPersistence)#>];
//        
//        // 4.发送证书
//        completionHandler(NSURLSessionAuthChallengeUseCredential , credential);

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
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler{
    
}


@end
