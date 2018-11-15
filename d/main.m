//
//  main.m
//  d
//
//  Created by lyt on 2018/11/8.
//  Copyright © 2018年 吴宏佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetTool.h"
#import "HJSign.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {

       NSString* sign = [HJSign signSHA256PlainData:[@"a=1&b=2" dataUsingEncoding:NSUTF8StringEncoding] privateKeyData:[NSData dataWithContentsOfFile:@"/Users/gd/Desktop/work/d/d/p.p12"] password:@"1111"];
        NSLog(@"%@",sign);

//
//        [NetTool POST:@"http://localhost/test.php/" parameters:@{@"whj":@"%= =吴宏佳",@"wzh":@"%=吴宏佳"}];
//        [NetTool POST:@"https://www.baidu.com/" parameters:@{@"whj":@"%= =吴宏佳",@"wzh":@"%=吴宏佳"}];
        [NetTool POST:@"https://192.168.113.107:8085/" parameters:@{@"whj":@"%= =吴宏佳",@"wzh":@"%=吴宏佳"}];

        
        [[NetTool share] setResBlock:^(id _Nonnull res) {
            NSLog(@"%@",res);
            
        }];
        
        [[NSRunLoop mainRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop mainRunLoop] run]; 
        
    }
    return 0;
}
