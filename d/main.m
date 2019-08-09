//
//  main.m
//  d
//
//  Created by lyt on 2018/11/8.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJNet.h"
#import "HJSecurity.h"
#import "MXApi.h"
#import "MXPrivateApiObject.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        AccountCreate *a = [AccountCreate request];
//        a.pwd = @"123456";
//        a.usercode = @"whj";
//        [MXApi sendReq:a success:^(BaseResp * _Nullable response) {
//            NSLog(@"%@",response);
//
//        } failure:^(ErrorResp * _Nullable response) {
//            NSLog(@"%@",response.error_info);
//        }];

//        ThawReq *t = [ThawReq request];
//        t.acctid = @"7782890000154261946274449";
//        t.page = 2;
//        [MXApi sendReq:t success:^(BaseResp * _Nullable response) {
//
//        } failure:^(ErrorResp * _Nullable response) {
//            NSLog(@"%@",response.error_info);
//
//        }];
        
        PrivateOrder *p = [[PrivateOrder alloc]init];
        p.tousercode = @"wzh";
        p.body = @"我的商品123";
        p.out_trade_no = @"2113021994";
        p.total_fee = @"10";
        p.trade_type = @"转账";
        p.note = @"无所谓";
        p.notify_url = @"https://www.baidu.com";
        /// 放在最后
        p.sign = [p generateSign];

        OrderCreateReq *o = [OrderCreateReq request];
        o.uid = @"123";
        o.usercode = @"whj";
        o.order_body = [p urlencode];
        
        [MXApi sendReq:o success:^(OrderCreateResp * _Nullable response) {
            
            NSLog(@"%@",response.tradnum);
            PayReq *p = [PayReq request];
            p.tradnum = response.tradnum;
            p.pwd = @"22";
            
            [MXApi sendReq:p success:^(id  _Nullable response) {
                
                NSLog(@"%@",response);
                
            } failure:^(ErrorResp * _Nullable response) {
                NSLog(@"%@",response.error_info);
                
            }];
        } failure:^(ErrorResp * _Nullable response) {
            NSLog(@"%@",response.error_info);
            
        }];
        
        BalanceReq *b = [BalanceReq request];
        b.acctid = @"7782890000154269952567715";
        b.page = 2;
        [MXApi sendReq:b success:^(BaseResp * _Nullable response) {
            
        } failure:^(ErrorResp * _Nullable response) {
            NSLog(@"%@",response.error_info);
            
        }];
        
        RecordsReq *r = [RecordsReq request];
        r.acctid = @"7782890000154261946274449";
        r.page = 2;
        [MXApi sendReq:r success:^(BaseResp * _Nullable response) {
            
        } failure:^(ErrorResp * _Nullable response) {
            NSLog(@"%@",response.error_info);

        }];
//
//        Thaw *t = [Thaw request];
//        t.page = 2;
//        [MXApi sendReq:t success:^(BaseResp * _Nullable response) {
//            
//        } failure:^(ErrorResp * _Nullable response) {
//            
//        }];
//
//
//       NSString* sign = [HJSecurity signSHA256PlainData:[@"a=1&b=2" dataUsingEncoding:NSUTF8StringEncoding] privateKeyData:[NSData dataWithContentsOfFile:@"/Users/gd/Desktop/work/d/d/p.p12"] password:@"1111"];
//        NSLog(@"%@",sign);
        
//
//        [NetTool POST:@"http://localhost/test.php/" parameters:@{@"whj":@"%= =吴宏佳",@"wzh":@"%=吴宏佳"}];
//        [HJNet POST:@"https://www.baidu.com/" parameters:@{@"whj":@"%= =吴宏佳",@"wzh":@"%=吴宏佳"} delegate:[[MXApi alloc] init]];
//        [HJNet POST:@"https://192.168.113.107:8085/api" parameters:@{@"whj":@"%= =吴宏佳",@"wzh":@"%=吴宏佳"} delegate:[[MXApi alloc] init]];
//
//        [HJNet POST:@"http://192.168.113.131/coinflow/" parameters:@{@"method":@"test.test.en",@"wzh":@"%=吴宏佳"}];
//
//
//        [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            [HJNet POST:@"http://192.168.113.131/coinflow/" parameters:@{@"method":@"test.test.en",@"wzh":@"%=吴宏佳"}];
//
//        }];
//        
//   
//
//        [[HJNet share] setResBlock:^(id _Nonnull res) {
//            NSLog(@"%@",res);
//            
//        }];
        

        [[NSRunLoop mainRunLoop] run];
        
    }
    return 0;
}
